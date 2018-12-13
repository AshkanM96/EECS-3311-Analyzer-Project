#!/bin/sh

# Clears cache and returns 0
clearCache() {
	[ -d "~/.cache" ] && yes | rm -rf "~/.cache" &> /dev/null
	[ -d ""$HOME"/.cache" ] && yes | rm -rf ""$HOME"/.cache" &> /dev/null
	return 0;
}

# Check if the given argument is an integer or not

# Returns -1 if number of given arguments is not 1

# Returns 0 to indicate true and 2 otherwise
isInt() {
	[ "$#" -ne 1 ] && return -1;
	return $(test "$1" -eq "$1" &> /dev/null);
}

min=1 ; max=100 ; bname="at"
if [ "$#" -eq 1 ]; then
	max="$1"
elif [ "$#" -eq 2 ]; then
	min="$1" ; max="$2"
elif [ "$#" -eq 3 ]; then
	min="$1" ; max="$2" ; bname="$3"
else
	echo -e "Usage:\n"$0" MaxTestCaseNumber\nOR\n"$0" MinTestCaseNumber MaxTestCaseNumber"
	echo -e "OR\n"$0" MinTestCaseNumber MaxTestCaseNumber TestCaseBaseName"
	exit 2;
fi

argError=0 ; intError=0
(isInt "$min") &> /dev/null ; ret="$?"
if [ "$ret" -ne 0 ]; then
	echo "Given value for the minimum test case number("$min") is not an integer."
	argError=`expr "$argError" + 1`
elif [ "$min" -lt 1 ]; then
	echo "Given value for the minimum test case number("$min") is less than 1."
	intError=`expr "$intError" + 1`
fi
if [ "$argError" -ne 0 -o "$intError" -ne 0 ]; then
	min=1
fi
(isInt "$max") &> /dev/null ; ret="$?"
if [ "$ret" -ne 0 ]; then
	echo "Given value for the maximum test case number("$max") is not an integer."
	argError=`expr "$argError" + 1`
elif [ "$max" -lt "$min" ]; then
	echo "Given value for the maximum test case number("$max") is less than the given value for the minimum test case number("$min")."
	intError=`expr "$intError" + 1`
fi
if [ -z "$bname" ]; then
	echo "Given value for the test case base name cannot be the empty string."
	argError=`expr "$argError" + 1`
fi
[ "$argError" -ne 0 -o "$intError" -ne 0 ] && echo -e "\nargument error = "$argError", integer error = "$intError"" && exit 3;

if [ ! -f "./analyzer" ]; then
	echo "Missing: ./analyzer"
	exit 4;
fi

chmod +x ./analyzer
[ -f ./oracle ] && chmod +x ./oracle

dash="" ; i=0
while [ "$i" -lt 20 ]; do
	dash=""$dash"----------"
	i=`expr "$i" + 1`
done

(clearCache) &> /dev/null

pass=0 ; total=0 ; testError=0

i=`expr "$min" - 1`
while [ "$i" -lt "$max" ]; do
	i=`expr "$i" + 1`
	name=""$bname""$i""

	in=""$name".txt"
	if [ ! -f "$in" ]; then
		continue;
	fi
	expect=""$name".expected.txt" ; actual=""$name".actual.txt"

	[ -f "$actual" ] && yes | rm -f "$actual" &> /dev/null
	before=$(date +%s%N)
	(timeout -s KILL 5'm' ./analyzer -b "$in" &> "$actual") &> /dev/null ; ret="$?"
	after=$(date +%s%N) ; analyzerElapsed=`expr "$after" - "$before"`
	(clearCache) &> /dev/null

	error=0
	if [ "$ret" -eq 137 ]; then
		echo "analyzer did not finish processing "$in" after 5 minutes and so it had to be killed."
		error=1
	elif [ "$ret" -eq 127 ]; then
		echo "TIMEOUT ERROR 127: ./analyzer -b COMMAND could not be found."
		error=2
	elif [ "$ret" -eq 126 ]; then
		echo "TIMEOUT ERROR 126: ./analyzer -b COMMAND could not be invoked."
		error=3
	elif [ "$ret" -eq 125 ]; then
		echo "TIMEOUT ERROR 125: Failed on ./analyzer -b "$in""
		error=4
	fi
	if [ "$error" -ne 0 ]; then
		yes | rm -f "$actual" &> /dev/null
		testError=`expr "$testError" + 1`
		continue;
	fi

	oracleElapsed="0"
	if [ ! -f "$expect" ]; then
		if [ -f "./oracle" ]; then
			before=$(date +%s%N)
			(timeout -s KILL 5'm' ./oracle -b "$in" &> "$expect") &> /dev/null ; ret="$?"
			after=$(date +%s%N) ; oracleElapsed=`expr "$after" - "$before"`
			(clearCache) &> /dev/null

			error=0
			if [ "$ret" -eq 137 ]; then
				echo "oracle did not finish processing "$in" after 5 minutes and so it had to be killed."
				error=1
			elif [ "$ret" -eq 127 ]; then
				echo "TIMEOUT ERROR 127: ./oracle -b COMMAND could not be found."
				error=2
			elif [ "$ret" -eq 126 ]; then
				echo "TIMEOUT ERROR 126: ./oracle -b COMMAND could not be invoked."
				error=3
			elif [ "$ret" -eq 125 ]; then
				echo "TIMEOUT ERROR 125: Failed on ./oracle -b "$in""
				error=4
			fi
			if [ "$error" -ne 0 ]; then
				yes | rm -f "$expect" &> /dev/null
				testError=`expr "$testError" + 1`
				continue;
			fi
		else
			echo -e "analyzer output of "$in" has been saved in "$actual"(took "$analyzerElapsed" nanoseconds) but could not be tested since an expected result could not be found/generated."
			testError=`expr "$testError" + 1`
			continue;
		fi
	fi

	if [ "$oracleElapsed" -ne 0 ]; then
		if [ "$analyzerElapsed" -lt "$oracleElapsed" ]; then
			fasterBy=`expr "$oracleElapsed" - "$analyzerElapsed"`
			fasterPercent=$(echo "scale=2; 100 * "$fasterBy" / "$oracleElapsed"" | bc)
			faster="analyzer is faster by "$fasterBy" nanoseconds("$fasterPercent"%)"
		elif [ "$analyzerElapsed" -eq "$oracleElapsed" ]; then
			fasterBy="0"
			faster="analyzer and oracle ran for the exact same amount of time"
		else
			fasterBy=`expr "$analyzerElapsed" - "$oracleElapsed"`
			fasterPercent=$(echo "scale=2; 100 * "$fasterBy" / "$analyzerElapsed"" | bc)
			faster="oracle is faster by "$fasterBy" nanoseconds("$fasterPercent"%)"
		fi
	fi

	d=""$name".diff.txt"
	[ -f "$d" ] && yes | rm -f "$d" &> /dev/null

	(cmp -s "$actual" "$expect") &> /dev/null ; ret="$?"
	if [ "$ret" -eq 0 ]; then
		if [ "$oracleElapsed" -eq 0 ]; then
			echo "PASS: "$name" (analyzer took: "$analyzerElapsed" nanoseconds)"
		else
			echo "PASS: "$name" ("$faster". analyzer took: "$analyzerElapsed" nanoseconds & oracle took: "$oracleElapsed" nanoseconds)"
		fi
		pass=`expr "$pass" + 1`

		yes | rm -f "$actual" &> /dev/null
	elif [ "$ret" -eq 1 ]; then
		if [ "$oracleElapsed" -eq 0 ]; then
			echo "FAIL: "$name" (analyzer took: "$analyzerElapsed" nanoseconds)"
		else
			echo "FAIL: "$name" ("$faster". analyzer took: "$analyzerElapsed" nanoseconds & oracle took: "$oracleElapsed" nanoseconds)"
		fi

		echo -e ""$actual" is on the left and "$expect" is on the right.\n"$dash"" > "$d"
		(diff -y --width=250 "$actual" "$expect" >> "$d") &> /dev/null
	else
		total=`expr "$total" - 1`
		testError=`expr "$testError" + 1`
		echo "CMP ERROR "$ret" on "$name""
	fi
	total=`expr "$total" + 1`
done

# The script returns 1 if at least one test case FAILS, 0 if all PASS, -1 if no test cases found and -2 if any test error(s) occurred.
result=0

if [ "$testError" -ne 0 ]; then
	result="-2"

	echo -e "\n"$testError" testing error(s) occurred during running test cases with base name '"$bname"' and number in the range of ["$min", "$max"]."
fi
if [ "$total" -ne 0 ]; then
	if [ "$pass" -ne "$total" ]; then
		result=1
	fi

	perP=$(echo "scale=2; 100 * "$pass" / "$total"" | bc)
	echo -e "\nPASSED: "$pass" of "$total"\nPASS Rate: "$perP"%"
elif [ "$testError" -eq 0 ]; then
	result="-1"

	echo -e "\nNo test cases found with base name '"$bname"' and number in the range of ["$min", "$max"]."
fi

(clearCache) &> /dev/null

exit "$result";

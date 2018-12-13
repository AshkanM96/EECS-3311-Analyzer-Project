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
	exit 1;
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
[ "$argError" -ne 0 -o "$intError" -ne 0 ] && echo -e "\nargument error = "$argError", integer error = "$intError"" && exit 2;

(clearCache) &> /dev/null

alldiff=1 ; total=0

i=`expr "$min" - 1`
while [ "$i" -lt "$max" ]; do
	i=`expr "$i" + 1`
	in=""$bname""$i".txt"
	if [ ! -f "$in" ]; then
		continue;
	fi

	total=`expr "$total" + 1`

	j="$i"
	while [ "$j" -lt "$max" ]; do
		j=`expr "$j" + 1`
		jn=""$bname""$j".txt"
		if [ ! -f "$jn" ]; then
			continue;
		fi

		(cmp -s "$in" "$jn") &> /dev/null ; ret="$?"
		if [ "$ret" -eq 0 ]; then
			echo -e ""$in" is the same as "$jn"\n"

			alldiff=0
		elif [ "$ret" -ne 1 ]; then
			echo -e "CMP ERROR "$ret" on "$in" and "$jn"\n"
		fi
	done
done

if [ "$total" -eq 0 ]; then
	echo "No test cases found with base name '"$bname"' and number in the range of ["$min", "$max"]."
elif [ "$alldiff" -eq 1 ]; then
	echo "All "$total" test case(s) found with base name '"$bname"' and number in the range of ["$min", "$max"] are different."
fi

(clearCache) &> /dev/null

exit 0;

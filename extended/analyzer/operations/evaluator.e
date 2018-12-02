note
	description: "Summary description for {EVALUATOR}."
	author: "Ashkan Moatamed"

frozen class
	EVALUATOR

inherit

	VISITOR

feature {EVALUATOR} -- Elements Set Attribute

	set: SET_ENUMERATION

feature -- Constructor

	default_create
		do
			is_new := True
			value := ""
			create {SET_ENUMERATION} set.make_empty
		ensure then
			open_set: set.is_open
			empty_set: set.is_empty
		end

feature -- Constant Expressions

	visit_null_expression (e: NULL_EXPRESSION)
		do
			is_new := False
		ensure then
			correct_value: value.is_empty
			empty_set: set.is_empty
		end

	visit_boolean_constant (e: BOOLEAN_CONSTANT)
		do
			is_new := False
			value := e.out
		ensure then
			correct_value: value.is_boolean and then (value ~ e.out)
			empty_set: set.is_empty
		end

	visit_integer_constant (e: INTEGER_CONSTANT)
		do
			is_new := False
			value := e.out
		ensure then
			correct_value: value.is_integer_64 and then (value ~ e.out)
			empty_set: set.is_empty
		end

	visit_empty_set_constant (e: EMPTY_SET_CONSTANT)
		do
			is_new := False
			value := e.out
		ensure then
			correct_value: (value ~ "{}") and then (value ~ e.out)
			empty_set: set.is_empty
		end

	visit_unevaluable_expression (e: UNEVALUABLE_EXPRESSION)
		do
			is_new := False
			value := e.out
		ensure then
			correct_value: value ~ e.out
			empty_set: set.is_empty
		end

feature -- Binary Op. Expressions

	visit_equality (e: EQUALITY)
		local
			eval: EVALUATOR
		do
			is_new := False

				-- evaluate left child
			create {EVALUATOR} eval.default_create
			e.left.visit (eval)

				-- save evaluation results before resetting
			value := eval.value
			set := eval.set

				-- only evaluate right child if value does not contain "/0" or "%%!+"
			if value.has_substring ("/0") then
				if value.has_substring ("%%!+") then
					value := "/0%%!+"
				else
					value := "/0"
				end
			elseif value.has_substring ("%%!+") then
				value := "%%!+"
			else

					-- evaluate right child
				eval.reset
				e.right.visit (eval)

					-- evaluate current
				if eval.value.has_substring ("/0") then
					if eval.value.has_substring ("%%!+") then
						value := "/0%%!+"
					else
						value := "/0"
					end
				elseif eval.value.has_substring ("%%!+") then
					value := "%%!+"
				else
					if (set.is_empty or else eval.set.is_empty) then
						value := (value ~ eval.value).out
					else
							-- set equality
						value := (set ~ eval.set).out
					end
				end
			end
			set.wipe_out -- make set empty
		ensure then
			correct_value: value.is_boolean or else (value ~ "/0") or else (value ~ "%%!+") or else (value ~ "/0%%!+")
			empty_set: set.is_empty
		end

		-- Boolean

	visit_conjunction (e: CONJUNCTION) -- AND
		local
			eval: EVALUATOR
		do
			is_new := False

				-- evaluate left child
			create {EVALUATOR} eval.default_create
			e.left.visit (eval)

				-- evaluate current
			if (eval.value ~ "/0") then
				value := "/0"
			elseif (eval.value ~ "%%!+") then
				value := "%%!+"
			elseif (eval.value ~ "/0%%!+") then
				value := "/0%%!+"
			elseif (eval.value ~ "False") then

					-- (False && p) = False
				value := "False"
			else
					-- evaluate right child
				eval.reset
				e.right.visit (eval)

					-- (True && p) = p
				value := eval.value
			end
		ensure then
			correct_value: value.is_boolean or else (value ~ "/0") or else (value ~ "%%!+") or else (value ~ "/0%%!+")
			empty_set: set.is_empty
		end

	visit_disjunction (e: DISJUNCTION) -- OR
		local
			eval: EVALUATOR
		do
			is_new := False

				-- evaluate left child
			create {EVALUATOR} eval.default_create
			e.left.visit (eval)

				-- evaluate current
			if (eval.value ~ "/0") then
				value := "/0"
			elseif (eval.value ~ "%%!+") then
				value := "%%!+"
			elseif (eval.value ~ "/0%%!+") then
				value := "/0%%!+"
			elseif (eval.value ~ "True") then

					-- (True || p) = True
				value := "True"
			else
					-- evaluate right child
				eval.reset
				e.right.visit (eval)

					-- (False || p) = p
				value := eval.value
			end
		ensure then
			correct_value: value.is_boolean or else (value ~ "/0") or else (value ~ "%%!+") or else (value ~ "/0%%!+")
			empty_set: set.is_empty
		end

	visit_exclusive_disjunction (e: EXCLUSIVE_DISJUNCTION) -- XOR
		local
			eval: EVALUATOR
		do
			is_new := False

				-- evaluate left child
			create {EVALUATOR} eval.default_create
			e.left.visit (eval)

				-- save evaluation results before resetting
			if (eval.value ~ "/0") then
				value := "/0"
			elseif (eval.value ~ "%%!+") then
				value := "%%!+"
			elseif (eval.value ~ "/0%%!+") then
				value := "/0%%!+"
			else
				value := eval.value

					-- evaluate right child
				eval.reset
				e.right.visit (eval)

					-- evaluate current
				if (eval.value ~ "/0") then
					value := "/0"
				elseif (eval.value ~ "%%!+") then
					value := "%%!+"
				elseif (eval.value ~ "/0%%!+") then
					value := "/0%%!+"
				elseif (value ~ eval.value) then
						-- True ^ True = False = False ^ False
					value := "False"
				else
						-- True ^ False = True = False ^ True
					value := "True"
				end
			end
		ensure then
			correct_value: value.is_boolean or else (value ~ "/0") or else (value ~ "%%!+") or else (value ~ "/0%%!+")
			empty_set: set.is_empty
		end

	visit_implication (e: IMPLICATION)
		local
			eval: EVALUATOR
		do
			is_new := False

				-- evaluate left child
			create {EVALUATOR} eval.default_create
			e.left.visit (eval)

				-- evaluate current
			if (eval.value ~ "/0") then
				value := "/0"
			elseif (eval.value ~ "%%!+") then
				value := "%%!+"
			elseif (eval.value ~ "/0%%!+") then
				value := "/0%%!+"
			elseif (eval.value ~ "False") then

					-- (False => p) = True
				value := "True"
			else
					-- evaluate right child
				eval.reset
				e.right.visit (eval)

					-- (True => p) = p
				value := eval.value
			end
		ensure then
			correct_value: value.is_boolean or else (value ~ "/0") or else (value ~ "%%!+") or else (value ~ "/0%%!+")
			empty_set: set.is_empty
		end

		-- Number

	visit_addition (e: ADDITION)
		local
			eval: EVALUATOR
		do
			is_new := False

				-- evaluate left child
			create {EVALUATOR} eval.default_create
			e.left.visit (eval)

				-- save evaluation results before resetting
			if (eval.value ~ "/0") then
				value := "/0"
			elseif (eval.value ~ "%%!+") then
				value := "%%!+"
			elseif (eval.value ~ "/0%%!+") then
				value := "/0%%!+"
			else
				value := eval.value

					-- evaluate right child
				eval.reset
				e.right.visit (eval)

					-- evaluate current
				if (eval.value ~ "/0") then
					value := "/0"
				elseif (eval.value ~ "%%!+") then
					value := "%%!+"
				elseif (eval.value ~ "/0%%!+") then
					value := "/0%%!+"
				else
					value := (value.to_integer_64 + eval.value.to_integer_64).out
				end
			end
		ensure then
			correct_value: value.is_integer_64 or else (value ~ "/0") or else (value ~ "%%!+") or else (value ~ "/0%%!+")
			empty_set: set.is_empty
		end

	visit_subtraction (e: SUBTRACTION)
		local
			eval: EVALUATOR
		do
			is_new := False

				-- evaluate left child
			create {EVALUATOR} eval.default_create
			e.left.visit (eval)

				-- save evaluation results before resetting
			if (eval.value ~ "/0") then
				value := "/0"
			elseif (eval.value ~ "%%!+") then
				value := "%%!+"
			elseif (eval.value ~ "/0%%!+") then
				value := "/0%%!+"
			else
				value := eval.value

					-- evaluate right child
				eval.reset
				e.right.visit (eval)

					-- evaluate current
				if (eval.value ~ "/0") then
					value := "/0"
				elseif (eval.value ~ "%%!+") then
					value := "%%!+"
				elseif (eval.value ~ "/0%%!+") then
					value := "/0%%!+"
				else
					value := (value.to_integer_64 - eval.value.to_integer_64).out
				end
			end
		ensure then
			correct_value: value.is_integer_64 or else (value ~ "/0") or else (value ~ "%%!+") or else (value ~ "/0%%!+")
			empty_set: set.is_empty
		end

	visit_multiplication (e: MULTIPLICATION)
		local
			eval: EVALUATOR
		do
			is_new := False

				-- evaluate left child
			create {EVALUATOR} eval.default_create
			e.left.visit (eval)

				-- save evaluation results before resetting
			if (eval.value ~ "/0") then
				value := "/0"
			elseif (eval.value ~ "%%!+") then
				value := "%%!+"
			elseif (eval.value ~ "/0%%!+") then
				value := "/0%%!+"
			else
				value := eval.value

					-- evaluate right child
				eval.reset
				e.right.visit (eval)

					-- evaluate current
				if (eval.value ~ "/0") then
					value := "/0"
				elseif (eval.value ~ "%%!+") then
					value := "%%!+"
				elseif (eval.value ~ "/0%%!+") then
					value := "/0%%!+"
				else
					value := (value.to_integer_64 * eval.value.to_integer_64).out
				end
			end
		ensure then
			correct_value: value.is_integer_64 or else (value ~ "/0") or else (value ~ "%%!+") or else (value ~ "/0%%!+")
			empty_set: set.is_empty
		end

	visit_division (e: DIVISION)
		local
			eval: EVALUATOR
		do
			is_new := False

				-- evaluate left child
			create {EVALUATOR} eval.default_create
			e.left.visit (eval)

				-- save evaluation results before resetting
			if (eval.value ~ "/0") then
				value := "/0"
			elseif (eval.value ~ "%%!+") then
				value := "%%!+"
			elseif (eval.value ~ "/0%%!+") then
				value := "/0%%!+"
			else
				value := eval.value

					-- evaluate right child
				eval.reset
				e.right.visit (eval)

					-- evaluate current
				if ((eval.value ~ "/0") or else (eval.value ~ "0")) then
					value := "/0"
				elseif (eval.value ~ "%%!+") then
					value := "%%!+"
				elseif (eval.value ~ "/0%%!+") then
					value := "/0%%!+"
				else
					value := (value.to_integer_64 / eval.value.to_integer_64).truncated_to_integer_64.out
				end
			end
		ensure then
			correct_value: value.is_integer_64 or else (value ~ "/0") or else (value ~ "%%!+") or else (value ~ "/0%%!+")
			empty_set: set.is_empty
		end

	visit_mod (e: MOD)
		local
			eval: EVALUATOR
			i, modulus: INTEGER_64
		do
			is_new := False

				-- evaluate left child
			create {EVALUATOR} eval.default_create
			e.left.visit (eval)

				-- save evaluation results before resetting
			if (eval.value ~ "/0") then
				value := "/0"
			elseif (eval.value ~ "%%!+") then
				value := "%%!+"
			elseif (eval.value ~ "/0%%!+") then
				value := "/0%%!+"
			else
				value := eval.value

					-- evaluate right child
				eval.reset
				e.right.visit (eval)

					-- evaluate current
				if (eval.value ~ "/0") then
					value := "/0"
				elseif (eval.value ~ "%%!+") then
					value := "%%!+"
				elseif (eval.value ~ "/0%%!+") then
					value := "/0%%!+"
				else
					modulus := eval.value.to_integer_64
					if (modulus <= 0) then
						value := "%%!+"
					else
						i := value.to_integer_64 \\ modulus
						if (i < 0) then
							i := i + modulus
						end
						value := i.out
					end
				end
			end
		ensure then
			correct_value: value.is_integer_64 or else (value ~ "/0") or else (value ~ "%%!+") or else (value ~ "/0%%!+")
			empty_set: set.is_empty
		end

	visit_less_than_or_equal (e: LESS_THAN_OR_EQUAL)
		local
			eval: EVALUATOR
		do
			is_new := False

				-- evaluate left child
			create {EVALUATOR} eval.default_create
			e.left.visit (eval)

				-- save evaluation results before resetting
			if (eval.value ~ "/0") then
				value := "/0"
			elseif (eval.value ~ "%%!+") then
				value := "%%!+"
			elseif (eval.value ~ "/0%%!+") then
				value := "/0%%!+"
			else
				value := eval.value

					-- evaluate right child
				eval.reset
				e.right.visit (eval)

					-- evaluate current
				if (eval.value ~ "/0") then
					value := "/0"
				elseif (eval.value ~ "%%!+") then
					value := "%%!+"
				elseif (eval.value ~ "/0%%!+") then
					value := "/0%%!+"
				else
					value := (value.to_integer_64 <= eval.value.to_integer_64).out
				end
			end
		ensure then
			correct_value: value.is_boolean or else (value ~ "/0") or else (value ~ "%%!+") or else (value ~ "/0%%!+")
			empty_set: set.is_empty
		end

	visit_less_than (e: LESS_THAN)
		local
			eval: EVALUATOR
		do
			is_new := False

				-- evaluate left child
			create {EVALUATOR} eval.default_create
			e.left.visit (eval)

				-- save evaluation results before resetting
			if (eval.value ~ "/0") then
				value := "/0"
			elseif (eval.value ~ "%%!+") then
				value := "%%!+"
			elseif (eval.value ~ "/0%%!+") then
				value := "/0%%!+"
			else
				value := eval.value

					-- evaluate right child
				eval.reset
				e.right.visit (eval)

					-- evaluate current
				if (eval.value ~ "/0") then
					value := "/0"
				elseif (eval.value ~ "%%!+") then
					value := "%%!+"
				elseif (eval.value ~ "/0%%!+") then
					value := "/0%%!+"
				else
					value := (value.to_integer_64 < eval.value.to_integer_64).out
				end
			end
		ensure then
			correct_value: value.is_boolean or else (value ~ "/0") or else (value ~ "%%!+") or else (value ~ "/0%%!+")
			empty_set: set.is_empty
		end

	visit_greater_than (e: GREATER_THAN)
		local
			eval: EVALUATOR
		do
			is_new := False

				-- evaluate left child
			create {EVALUATOR} eval.default_create
			e.left.visit (eval)

				-- save evaluation results before resetting
			if (eval.value ~ "/0") then
				value := "/0"
			elseif (eval.value ~ "%%!+") then
				value := "%%!+"
			elseif (eval.value ~ "/0%%!+") then
				value := "/0%%!+"
			else
				value := eval.value

					-- evaluate right child
				eval.reset
				e.right.visit (eval)

					-- evaluate current
				if (eval.value ~ "/0") then
					value := "/0"
				elseif (eval.value ~ "%%!+") then
					value := "%%!+"
				elseif (eval.value ~ "/0%%!+") then
					value := "/0%%!+"
				else
					value := (value.to_integer_64 > eval.value.to_integer_64).out
				end
			end
		ensure then
			correct_value: value.is_boolean or else (value ~ "/0") or else (value ~ "%%!+") or else (value ~ "/0%%!+")
			empty_set: set.is_empty
		end

	visit_greater_than_or_equal (e: GREATER_THAN_OR_EQUAL)
		local
			eval: EVALUATOR
		do
			is_new := False

				-- evaluate left child
			create {EVALUATOR} eval.default_create
			e.left.visit (eval)

				-- save evaluation results before resetting
			if (eval.value ~ "/0") then
				value := "/0"
			elseif (eval.value ~ "%%!+") then
				value := "%%!+"
			elseif (eval.value ~ "/0%%!+") then
				value := "/0%%!+"
			else
				value := eval.value

					-- evaluate right child
				eval.reset
				e.right.visit (eval)

					-- evaluate current
				if (eval.value ~ "/0") then
					value := "/0"
				elseif (eval.value ~ "%%!+") then
					value := "%%!+"
				elseif (eval.value ~ "/0%%!+") then
					value := "/0%%!+"
				else
					value := (value.to_integer_64 >= eval.value.to_integer_64).out
				end
			end
		ensure then
			correct_value: value.is_boolean or else (value ~ "/0") or else (value ~ "%%!+") or else (value ~ "/0%%!+")
			empty_set: set.is_empty
		end

		-- Set

	visit_union (e: UNION)
		local
			eval: EVALUATOR
		do
			is_new := False

				-- evaluate left child
			create {EVALUATOR} eval.default_create
			e.left.visit (eval)

				-- save evaluation results before resetting
			set := eval.set

				-- evaluate right child
			eval.reset
			e.right.visit (eval)

				-- evaluate current
			set.union (eval.set)
			set.is_open := False
			set.remove_duplicates
			value := set.out
		ensure then
			correct_value: value.starts_with ("{") and then value.ends_with ("}")
		end

	visit_intersection (e: INTERSECTION)
		local
			eval: EVALUATOR
		do
			is_new := False

				-- evaluate left child
			create {EVALUATOR} eval.default_create
			e.left.visit (eval)

				-- save evaluation results before resetting
			set := eval.set

				-- evaluate right child
			eval.reset
			e.right.visit (eval)

				-- evaluate current
			set.intersect (eval.set)
			set.is_open := False
				-- duplicates are removed by other visitations
			value := set.out
		ensure then
			correct_value: value.starts_with ("{") and then value.ends_with ("}")
		end

	visit_difference (e: DIFFERENCE)
		local
			eval: EVALUATOR
		do
			is_new := False

				-- evaluate left child
			create {EVALUATOR} eval.default_create
			e.left.visit (eval)

				-- save evaluation results before resetting
			set := eval.set

				-- evaluate right child
			eval.reset
			e.right.visit (eval)

				-- evaluate current
			set.difference (eval.set)
			set.is_open := False
				-- duplicates are removed by other visitations
			value := set.out
		ensure then
			correct_value: value.starts_with ("{") and then value.ends_with ("}")
		end

	visit_subset_equal (e: SUBSET_EQUAL)
		local
			eval: EVALUATOR
		do
			is_new := False

				-- evaluate left child
			create {EVALUATOR} eval.default_create
			e.left.visit (eval)

				-- save evaluation results before resetting
			if eval.value.has_substring ("/0") then
				if eval.value.has_substring ("%%!+") then
					value := "/0%%!+"
				else
					value := "/0"
				end
			elseif eval.value.has_substring ("%%!+") then
				value := "%%!+"
			else
				set := eval.set

					-- evaluate right child
				eval.reset
				e.right.visit (eval)

					-- evaluate current
				if eval.value.has_substring ("/0") then
					if eval.value.has_substring ("%%!+") then
						value := "/0%%!+"
					else
						value := "/0"
					end
				elseif eval.value.has_substring ("%%!+") then
					value := "%%!+"
				else
					value := set.subset_equal (eval.set).out
				end
			end
			set.wipe_out -- make set empty
		ensure then
			correct_value: value.is_boolean or else (value ~ "/0") or else (value ~ "%%!+") or else (value ~ "/0%%!+")
			empty_set: set.is_empty
		end

	visit_subset_proper (e: SUBSET_PROPER)
		local
			eval: EVALUATOR
		do
			is_new := False

				-- evaluate left child
			create {EVALUATOR} eval.default_create
			e.left.visit (eval)

				-- save evaluation results before resetting
			if eval.value.has_substring ("/0") then
				if eval.value.has_substring ("%%!+") then
					value := "/0%%!+"
				else
					value := "/0"
				end
			elseif eval.value.has_substring ("%%!+") then
				value := "%%!+"
			else
				set := eval.set

					-- evaluate right child
				eval.reset
				e.right.visit (eval)

					-- evaluate current
				if eval.value.has_substring ("/0") then
					if eval.value.has_substring ("%%!+") then
						value := "/0%%!+"
					else
						value := "/0"
					end
				elseif eval.value.has_substring ("%%!+") then
					value := "%%!+"
				else
					value := set.subset_proper (eval.set).out
				end
			end
			set.wipe_out -- make set empty
		ensure then
			correct_value: value.is_boolean or else (value ~ "/0") or else (value ~ "%%!+") or else (value ~ "/0%%!+")
			empty_set: set.is_empty
		end

	visit_superset_equal (e: SUPERSET_EQUAL)
		local
			eval: EVALUATOR
		do
			is_new := False

				-- evaluate left child
			create {EVALUATOR} eval.default_create
			e.left.visit (eval)

				-- save evaluation results before resetting
			if eval.value.has_substring ("/0") then
				if eval.value.has_substring ("%%!+") then
					value := "/0%%!+"
				else
					value := "/0"
				end
			elseif eval.value.has_substring ("%%!+") then
				value := "%%!+"
			else
				set := eval.set

					-- evaluate right child
				eval.reset
				e.right.visit (eval)

					-- evaluate current
				if eval.value.has_substring ("/0") then
					if eval.value.has_substring ("%%!+") then
						value := "/0%%!+"
					else
						value := "/0"
					end
				elseif eval.value.has_substring ("%%!+") then
					value := "%%!+"
				else
					value := set.superset_equal (eval.set).out
				end
			end
			set.wipe_out -- make set empty
		ensure then
			correct_value: value.is_boolean or else (value ~ "/0") or else (value ~ "%%!+") or else (value ~ "/0%%!+")
			empty_set: set.is_empty
		end

	visit_superset_proper (e: SUPERSET_PROPER)
		local
			eval: EVALUATOR
		do
			is_new := False

				-- evaluate left child
			create {EVALUATOR} eval.default_create
			e.left.visit (eval)

				-- save evaluation results before resetting
			if eval.value.has_substring ("/0") then
				if eval.value.has_substring ("%%!+") then
					value := "/0%%!+"
				else
					value := "/0"
				end
			elseif eval.value.has_substring ("%%!+") then
				value := "%%!+"
			else
				set := eval.set

					-- evaluate right child
				eval.reset
				e.right.visit (eval)

					-- evaluate current
				if eval.value.has_substring ("/0") then
					if eval.value.has_substring ("%%!+") then
						value := "/0%%!+"
					else
						value := "/0"
					end
				elseif eval.value.has_substring ("%%!+") then
					value := "%%!+"
				else
					value := set.superset_proper (eval.set).out
				end
			end
			set.wipe_out -- make set empty
		ensure then
			correct_value: value.is_boolean or else (value ~ "/0") or else (value ~ "%%!+") or else (value ~ "/0%%!+")
			empty_set: set.is_empty
		end

feature -- Unary Op. Expressions

		-- Boolean

	visit_negation (e: NEGATION)
		local
			eval: EVALUATOR
		do
			is_new := False

				-- evaluate child
			create {EVALUATOR} eval.default_create
			e.child.visit (eval)

				-- evaluate current
			if (eval.value ~ "/0") then
				value := "/0"
			elseif (eval.value ~ "%%!+") then
				value := "%%!+"
			elseif (eval.value ~ "/0%%!+") then
				value := "/0%%!+"
			else
				value := (not eval.value.to_boolean).out
			end
		ensure then
			correct_value: value.is_boolean or else (value ~ "/0") or else (value ~ "%%!+") or else (value ~ "/0%%!+")
			empty_set: set.is_empty
		end

	visit_count (e: COUNT)
		local
			eval: EVALUATOR
			i: INTEGER_64
		do
			is_new := False

				-- evaluate child
			create {EVALUATOR} eval.default_create
			e.child.visit (eval)

				-- evaluate current
			if eval.value.has_substring ("/0") then
				if eval.value.has_substring ("%%!+") then
					value := "/0%%!+"
				else
					value := "/0"
				end
			elseif eval.value.has_substring ("%%!+") then
				value := "%%!+"
			else
				i := 0
				across
					eval.set as cursor
				loop
					if cursor.item.out.to_boolean then
						i := i + 1
					end
				end
				value := i.out
			end
		ensure then
			correct_value: value.is_integer_64 or else (value ~ "/0") or else (value ~ "%%!+") or else (value ~ "/0%%!+")
			empty_set: set.is_empty
		end

	visit_for_all (e: FOR_ALL)
		local
			eval: EVALUATOR
			ic: ITERATION_CURSOR [EXPRESSION]
			b: BOOLEAN
		do
			is_new := False

				-- evaluate child
			create {EVALUATOR} eval.default_create
			e.child.visit (eval)

				-- evaluate current
			if eval.value.has_substring ("/0") then
				if eval.value.has_substring ("%%!+") then
					value := "/0%%!+"
				else
					value := "/0"
				end
			elseif eval.value.has_substring ("%%!+") then
				value := "%%!+"
			else
				from
					ic := eval.set.new_cursor
					b := True
				until
					ic.after or else (not b) -- not (ic.has_next and then b)
				loop
					b := ic.item.out.to_boolean
					ic.forth
				end
				value := b.out
			end
		ensure then
			correct_value: value.is_boolean or else (value ~ "/0") or else (value ~ "%%!+") or else (value ~ "/0%%!+")
			empty_set: set.is_empty
		end

	visit_there_exists (e: THERE_EXISTS)
		local
			eval: EVALUATOR
			ic: ITERATION_CURSOR [EXPRESSION]
			b: BOOLEAN
		do
			is_new := False

				-- evaluate child
			create {EVALUATOR} eval.default_create
			e.child.visit (eval)

				-- evaluate current
			if eval.value.has_substring ("/0") then
				if eval.value.has_substring ("%%!+") then
					value := "/0%%!+"
				else
					value := "/0"
				end
			elseif eval.value.has_substring ("%%!+") then
				value := "%%!+"
			else
				from
					ic := eval.set.new_cursor
					b := False
				until
					ic.after or else b -- not (ic.has_next and then (not b))
				loop
					b := ic.item.out.to_boolean
					ic.forth
				end
				value := b.out
			end
		ensure then
			correct_value: value.is_boolean or else (value ~ "/0") or else (value ~ "%%!+") or else (value ~ "/0%%!+")
			empty_set: set.is_empty
		end

		-- Number

	visit_negative (e: NEGATIVE)
		local
			eval: EVALUATOR
		do
			is_new := False

				-- evaluate child
			create {EVALUATOR} eval.default_create
			e.child.visit (eval)

				-- evaluate current
			if (eval.value ~ "/0") then
				value := "/0"
			elseif (eval.value ~ "%%!+") then
				value := "%%!+"
			elseif (eval.value ~ "/0%%!+") then
				value := "/0%%!+"
			else
				value := (-1 * eval.value.to_integer_64).out
			end
		ensure then
			correct_value: value.is_integer_64 or else (value ~ "/0") or else (value ~ "%%!+") or else (value ~ "/0%%!+")
			empty_set: set.is_empty
		end

	visit_summation (e: SUMMATION)
		local
			eval: EVALUATOR
			i: INTEGER_64
		do
			is_new := False

				-- evaluate child
			create {EVALUATOR} eval.default_create
			e.child.visit (eval)

				-- evaluate current
			if eval.value.has_substring ("/0") then
				if eval.value.has_substring ("%%!+") then
					value := "/0%%!+"
				else
					value := "/0"
				end
			elseif eval.value.has_substring ("%%!+") then
				value := "%%!+"
			else
				i := 0
				across
					eval.set as cursor
				loop
					i := i + cursor.item.out.to_integer_64
				end
				value := i.out
			end
		ensure then
			correct_value: value.is_integer_64 or else (value ~ "/0") or else (value ~ "%%!+") or else (value ~ "/0%%!+")
			empty_set: set.is_empty
		end

	visit_product (e: PRODUCT)
		local
			eval: EVALUATOR
			i: INTEGER_64
		do
			is_new := False

				-- evaluate child
			create {EVALUATOR} eval.default_create
			e.child.visit (eval)

				-- evaluate current
			if eval.value.has_substring ("/0") then
				if eval.value.has_substring ("%%!+") then
					value := "/0%%!+"
				else
					value := "/0"
				end
			elseif eval.value.has_substring ("%%!+") then
				value := "%%!+"
			elseif eval.set.is_empty then
				value := "0"
			else
				i := 1
				across
					eval.set as cursor
				loop
					i := i * cursor.item.out.to_integer_64
				end
				value := i.out
			end
		ensure then
			correct_value: value.is_integer_64 or else (value ~ "/0") or else (value ~ "%%!+") or else (value ~ "/0%%!+")
			empty_set: set.is_empty
		end

feature -- Composite Expressions

	visit_set_enum (e: SET_ENUMERATION)
		local
			cea: CONST_EXPR_ACCESS
			eval: EVALUATOR
		do
			is_new := False

				-- handle empty case quickly
			if e.is_empty then
				value := "{}"
			else
					-- evaluate children
				create {EVALUATOR} eval.default_create
				across
					e as cursor
				loop
					cursor.item.visit (eval)

						-- add current element to set
					if (eval.value ~ "{}") then
						set.add (cea.empty_set)
					elseif (eval.value ~ "/0") then
						set.add (cea.div_by_zero)
					elseif (eval.value ~ "%%!+") then
						set.add (cea.mod_by_not_pos)
					elseif (eval.value ~ "/0%%!+") then
						set.add (cea.div_by_zero_and_mod_by_not_pos)
					elseif eval.value.is_boolean then
						set.add (cea.bool (eval.value.to_boolean))
					elseif eval.value.is_integer_64 then
						set.add (create {INTEGER_CONSTANT}.make_from_string (eval.value))
					else -- non-empty set
						set.add (eval.set)
					end

						-- reset evaluator
					eval.reset
				end

					-- evaluate current
				set.is_open := False
				set.remove_duplicates
				value := set.out
			end
		ensure then
			enum_empty: e.is_empty implies ((value ~ "{}") and then set.is_empty)
			enum_not_empty: (not e.is_empty) implies ((value.count > 2) and then (value [1] = '{') and then (value [value.count] = '}') and then (not set.is_empty))
			set_count_upper_bound: set.count <= e.count
		end

invariant
	value_empty_relation_to_set: (value.is_empty or else value.is_boolean or else value.is_integer_64 or else (value ~ "/0") or else (value ~ "%%!+") or else (value ~ "/0%%!+") or else (value ~ "{}")) = set.is_empty
	value_not_empty_relation_to_set: ((value.count > 2) and then (value [1] = '{') and then (value [value.count] = '}')) implies (not set.is_empty)

end

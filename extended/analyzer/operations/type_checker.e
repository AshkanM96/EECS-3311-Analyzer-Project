note
	description: "Summary description for {TYPE_CHECKER}."
	author: "Ashkan Moatamed"

frozen class
	TYPE_CHECKER

inherit

	VISITOR

feature -- Constant Type Flags

	type_invalid: INTEGER_8 = -1

	type_unknown: INTEGER_8 = 0

	type_bool: INTEGER_8 = 1

	type_int: INTEGER_8 = 2

feature -- Attributes

	type_flag: INTEGER_8

	set_depth: NATURAL_64

	division_by_zero, mod_by_not_positive: BOOLEAN

feature -- Queries

	is_type_correct: BOOLEAN
		do
			Result := (type_flag /= type_invalid)
		ensure
			correct_result: Result = (type_flag /= type_invalid)
		end

	is_bool: BOOLEAN
		do
			Result := (type_flag = type_bool) and then (set_depth = 0)
		ensure
			correct_result: Result = ((type_flag = type_bool) and then (set_depth = 0))
		end

	is_int: BOOLEAN
		do
			Result := (type_flag = type_int) and then (set_depth = 0)
		ensure
			correct_result: Result = ((type_flag = type_int) and then (set_depth = 0))
		end

	is_set_enum: BOOLEAN
		do
			Result := (set_depth /= 0)
		ensure
			correct_result: Result = (set_depth /= 0)
		end

	is_bool_set: BOOLEAN
		do
			Result := (type_flag = type_bool) and then (set_depth = 1)
		ensure
			correct_result: Result = ((type_flag = type_bool) and then (set_depth = 1))
		end

	is_int_set: BOOLEAN
		do
			Result := (type_flag = type_int) and then (set_depth = 1)
		ensure
			correct_result: Result = ((type_flag = type_int) and then (set_depth = 1))
		end

	is_empty_set: BOOLEAN
		do
			Result := (type_flag = type_unknown) and then (set_depth = 1)
		ensure
			correct_result: Result = ((type_flag = type_unknown) and then (set_depth = 1))
		end

feature -- Constructor

	default_create
		do
			is_new := True
			value := ""
			type_flag := type_invalid
			set_depth := 0
			division_by_zero := False
			mod_by_not_positive := False
		ensure then
			not_type_correct: not is_type_correct
			not_set_enum: not is_set_enum
			not_division_by_zero: not division_by_zero
			not_mod_by_not_positive: not mod_by_not_positive
		end

feature -- Constant Expressions

	visit_null_expression (e: NULL_EXPRESSION)
		do
			is_new := False
			value := e.out
		ensure then
			correct_value: ((value ~ "?") or else (value ~ "nil")) and then (value ~ e.out)
			not_type_correct: not is_type_correct
		end

	visit_boolean_constant (e: BOOLEAN_CONSTANT)
		do
			is_new := False
			value := e.out
			type_flag := type_bool
		ensure then
			correct_value: value.is_boolean and then (value ~ e.out)
			correct_type: is_bool
		end

	visit_integer_constant (e: INTEGER_CONSTANT)
		do
			is_new := False
			value := e.out
			type_flag := type_int
		ensure then
			correct_value: value.is_integer_64 and then (value ~ e.out)
			correct_type: is_int
		end

	visit_empty_set_constant (e: EMPTY_SET_CONSTANT)
		do
			is_new := False
			value := e.out
			type_flag := type_unknown
			set_depth := 1
		ensure then
			correct_value: (value ~ "{}") and then (value ~ e.out)
			correct_type: is_empty_set
		end

	visit_unevaluable_expression (e: UNEVALUABLE_EXPRESSION)
		do
			is_new := False
			value := e.out
			type_flag := type_int
			division_by_zero := value.has_substring ("/0")
			mod_by_not_positive := value.has_substring ("%%!+")
		ensure then
			correct_value: value ~ e.out
			correct_type: is_int
			division_by_zero: division_by_zero = value.has_substring ("/0")
			mod_by_not_positive: mod_by_not_positive = value.has_substring ("%%!+")
		end

feature -- Binary Op. Expressions

	visit_equality (e: EQUALITY)
		local
			left_c, right_c: TYPE_CHECKER
		do
			is_new := False

				-- type check left child
			create {TYPE_CHECKER} left_c.default_create
			e.left.visit (left_c)

				-- only proceed if left child is type correct
			if left_c.is_type_correct then

					-- type check right child
				create {TYPE_CHECKER} right_c.default_create
				e.right.visit (right_c)

					-- only proceed if right child is type correct
				if right_c.is_type_correct then

						-- only proceed if the left and the right child have the same type and depth
					if ((left_c.type_flag = right_c.type_flag) and then (left_c.set_depth = right_c.set_depth)) then

							-- set current attributes
						type_flag := type_bool
						division_by_zero := left_c.division_by_zero or else right_c.division_by_zero
						mod_by_not_positive := left_c.mod_by_not_positive or else right_c.mod_by_not_positive

							-- the only cases where the left and right children can have different types
							-- but the equality is valid, is when one is the empty set and the other is some set

							-- left child is the empty set and right child is some set
					elseif ((left_c.is_empty_set and then right_c.is_set_enum)
							-- right child is the empty set and left child is some set
						or else (right_c.is_empty_set and then left_c.is_set_enum))
					then

							-- set current attributes

							-- note: L and R are used respectively to denote the left and the right sets when they are non-empty
						if left_c.is_empty_set then
							if right_c.is_empty_set then

									-- ({} = {}) = True
								value := "True"
							else

									-- ({} = R) = False
								value := "False"
							end
						else

								-- (L = {}) = False
							value := "False"
						end
						type_flag := type_bool
						division_by_zero := left_c.division_by_zero or else right_c.division_by_zero
						mod_by_not_positive := left_c.mod_by_not_positive or else right_c.mod_by_not_positive
					end
				end
			end
		ensure then
			correct_value: value.is_empty or else value.is_boolean
			correct_type: is_bool or else (not is_type_correct)
		end

		-- Boolean

	visit_conjunction (e: CONJUNCTION) -- AND
		local
			checker: TYPE_CHECKER
		do
			is_new := False

				-- type check left child
			create {TYPE_CHECKER} checker.default_create
			e.left.visit (checker)

				-- only proceed if left child is of correct type
			if checker.is_bool then

					-- save type check results before resetting
				if checker.value.is_boolean then
					value := checker.value
				end
				division_by_zero := checker.division_by_zero
				mod_by_not_positive := checker.mod_by_not_positive

					-- type check right child
				checker.reset
				e.right.visit (checker)

					-- only proceed if right child is of correct type
				if checker.is_bool then

						-- set current attributes
					if (not value.is_empty) then
						if (value ~ "False") then
								-- LHS value is known to be False and so regardless of RHS value, the Current value is False.

								-- (False && p) = False
						elseif checker.value.is_boolean then
								-- If LHS value is known to be True while the RHS value is also known, then the Current value is also known to be the RHS value.

								-- (True && p) = p
							value := checker.value
						else
								-- value is not known at this point
							value := ""
						end
					end
					type_flag := type_bool
					division_by_zero := division_by_zero or else checker.division_by_zero
					mod_by_not_positive := mod_by_not_positive or else checker.mod_by_not_positive
				else
						-- not type_correct so empty value
					value := ""
				end
			end
		ensure then
			correct_value: value.is_empty or else value.is_boolean
			correct_type: is_bool or else (not is_type_correct)
		end

	visit_disjunction (e: DISJUNCTION) -- OR
		local
			checker: TYPE_CHECKER
		do
			is_new := False

				-- type check left child
			create {TYPE_CHECKER} checker.default_create
			e.left.visit (checker)

				-- only proceed if left child is of correct type
			if checker.is_bool then

					-- save type check results before resetting
				if checker.value.is_boolean then
					value := checker.value
				end
				division_by_zero := checker.division_by_zero
				mod_by_not_positive := checker.mod_by_not_positive

					-- type check right child
				checker.reset
				e.right.visit (checker)

					-- only proceed if right child is of correct type
				if checker.is_bool then

						-- set current attributes
					if (not value.is_empty) then
						if (value ~ "True") then
								-- LHS value is known to be True and so regardless of RHS value, the Current value is True.

								-- (True || p) = True
						elseif checker.value.is_boolean then
								-- If LHS value is known to be False while the RHS value is also known, then the Current value is also known to be the RHS value.

								-- (False || p) = p
							value := checker.value
						else
								-- value is not known at this point
							value := ""
						end
					end
					type_flag := type_bool
					division_by_zero := division_by_zero or else checker.division_by_zero
					mod_by_not_positive := mod_by_not_positive or else checker.mod_by_not_positive
				else
						-- not type_correct so empty value
					value := ""
				end
			end
		ensure then
			correct_value: value.is_empty or else value.is_boolean
			correct_type: is_bool or else (not is_type_correct)
		end

	visit_exclusive_disjunction (e: EXCLUSIVE_DISJUNCTION) -- XOR
		local
			checker: TYPE_CHECKER
		do
			is_new := False

				-- type check left child
			create {TYPE_CHECKER} checker.default_create
			e.left.visit (checker)

				-- only proceed if left child is of correct type
			if checker.is_bool then

					-- save type check results before resetting
				if checker.value.is_boolean then
					value := checker.value
				end
				division_by_zero := checker.division_by_zero
				mod_by_not_positive := checker.mod_by_not_positive

					-- type check right child
				checker.reset
				e.right.visit (checker)

					-- only proceed if right child is of correct type
				if checker.is_bool then

						-- set current attributes
					if ((not value.is_empty) and then checker.value.is_boolean) then
						if (value ~ checker.value) then
								-- True ^ True = False = False ^ False
							value := "False"
						else
								-- True ^ False = True = False ^ True
							value := "True"
						end
					else
							-- value is not known at this point
						value := ""
					end
					type_flag := type_bool
					division_by_zero := division_by_zero or else checker.division_by_zero
					mod_by_not_positive := mod_by_not_positive or else checker.mod_by_not_positive
				else
						-- not type_correct so empty value
					value := ""
				end
			end
		ensure then
			correct_value: value.is_empty or else value.is_boolean
			correct_type: is_bool or else (not is_type_correct)
		end

	visit_implication (e: IMPLICATION)
		local
			checker: TYPE_CHECKER
		do
			is_new := False

				-- type check left child
			create {TYPE_CHECKER} checker.default_create
			e.left.visit (checker)

				-- only proceed if left child is of correct type
			if checker.is_bool then

					-- save type check results before resetting
				if checker.value.is_boolean then
					value := checker.value
				end
				division_by_zero := checker.division_by_zero
				mod_by_not_positive := checker.mod_by_not_positive

					-- type check right child
				checker.reset
				e.right.visit (checker)

					-- only proceed if right child is of correct type
				if checker.is_bool then

						-- set current attributes
					if (not value.is_empty) then
						if (value ~ "False") then
								-- LHS value is known to be False and so regardless of RHS value, the Current value is True.

								-- (False => p) = True
							value := "True"
						elseif checker.value.is_boolean then
								-- If LHS value is known to be True while the RHS value is also known, then the Current value is also known to be the RHS value.

								-- (True => p) = p
							value := checker.value
						else
								-- value is not known at this point
							value := ""
						end
					end
					type_flag := type_bool
					division_by_zero := division_by_zero or else checker.division_by_zero
					mod_by_not_positive := mod_by_not_positive or else checker.mod_by_not_positive
				else
						-- not type_correct so empty value
					value := ""
				end
			end
		ensure then
			correct_value: value.is_empty or else value.is_boolean
			correct_type: is_bool or else (not is_type_correct)
		end

		-- Number

	visit_addition (e: ADDITION)
		local
			checker: TYPE_CHECKER
		do
			is_new := False

				-- type check left child
			create {TYPE_CHECKER} checker.default_create
			e.left.visit (checker)

				-- only proceed if left child is of correct type
			if checker.is_int then

					-- save type check results before resetting
				if checker.value.is_integer_64 then
					value := checker.value
				end
				division_by_zero := checker.division_by_zero
				mod_by_not_positive := checker.mod_by_not_positive

					-- type check right child
				checker.reset
				e.right.visit (checker)

					-- only proceed if right child is of correct type
				if checker.is_int then

						-- set current attributes
					if ((not value.is_empty) and then checker.value.is_integer_64) then
						value := (value.to_integer_64 + checker.value.to_integer_64).out
					else
							-- value is not known at this point
						value := ""
					end
					type_flag := type_int
					division_by_zero := division_by_zero or else checker.division_by_zero
					mod_by_not_positive := mod_by_not_positive or else checker.mod_by_not_positive
				else
						-- not type_correct so empty value
					value := ""
				end
			end
		ensure then
			correct_value: value.is_empty or else value.is_integer_64
			correct_type: is_int or else (not is_type_correct)
		end

	visit_subtraction (e: SUBTRACTION)
		local
			checker: TYPE_CHECKER
		do
			is_new := False

				-- type check left child
			create {TYPE_CHECKER} checker.default_create
			e.left.visit (checker)

				-- only proceed if left child is of correct type
			if checker.is_int then

					-- save type check results before resetting
				if checker.value.is_integer_64 then
					value := checker.value
				end
				division_by_zero := checker.division_by_zero
				mod_by_not_positive := checker.mod_by_not_positive

					-- type check right child
				checker.reset
				e.right.visit (checker)

					-- only proceed if right child is of correct type
				if checker.is_int then

						-- set current attributes
					if ((not value.is_empty) and then checker.value.is_integer_64) then
						value := (value.to_integer_64 - checker.value.to_integer_64).out
					else
							-- value is not known at this point
						value := ""
					end
					type_flag := type_int
					division_by_zero := division_by_zero or else checker.division_by_zero
					mod_by_not_positive := mod_by_not_positive or else checker.mod_by_not_positive
				else
						-- not type_correct so empty value
					value := ""
				end
			end
		ensure then
			correct_value: value.is_empty or else value.is_integer_64
			correct_type: is_int or else (not is_type_correct)
		end

	visit_multiplication (e: MULTIPLICATION)
		local
			checker: TYPE_CHECKER
		do
			is_new := False

				-- type check left child
			create {TYPE_CHECKER} checker.default_create
			e.left.visit (checker)

				-- only proceed if left child is of correct type
			if checker.is_int then

					-- save type check results before resetting
				if checker.value.is_integer_64 then
					value := checker.value
				end
				division_by_zero := checker.division_by_zero
				mod_by_not_positive := checker.mod_by_not_positive

					-- type check right child
				checker.reset
				e.right.visit (checker)

					-- only proceed if right child is of correct type
				if checker.is_int then

						-- set current attributes
					if ((not value.is_empty) and then checker.value.is_integer_64) then
						value := (value.to_integer_64 * checker.value.to_integer_64).out
					else
							-- value is not known at this point
						value := ""
					end
					type_flag := type_int
					division_by_zero := division_by_zero or else checker.division_by_zero
					mod_by_not_positive := mod_by_not_positive or else checker.mod_by_not_positive
				else
						-- not type_correct so empty value
					value := ""
				end
			end
		ensure then
			correct_value: value.is_empty or else value.is_integer_64
			correct_type: is_int or else (not is_type_correct)
		end

	visit_division (e: DIVISION)
		local
			checker: TYPE_CHECKER
			eval: EVALUATOR
		do
			is_new := False

				-- type check left child
			create {TYPE_CHECKER} checker.default_create
			e.left.visit (checker)

				-- only proceed if left child is of correct type
			if checker.is_int then

					-- save type check results before resetting
				division_by_zero := checker.division_by_zero
				mod_by_not_positive := checker.mod_by_not_positive

					-- type check right child
				checker.reset
				e.right.visit (checker)

					-- only proceed if right child is of correct type
				if checker.is_int then

						-- set current attributes
					type_flag := type_int
					division_by_zero := division_by_zero or else checker.division_by_zero or else (checker.value ~ "0")
					mod_by_not_positive := mod_by_not_positive or else checker.mod_by_not_positive
					if (not division_by_zero) then

							-- check if right child(i.e., denominator) is zero
						create {EVALUATOR} eval.default_create
						e.right.visit (eval)
						division_by_zero := (eval.value ~ "0") or else eval.value.has_substring ("/0")
					end
				end
			end
		ensure then
			empty_value: value.is_empty
			correct_type: is_int or else (not is_type_correct)
		end

	visit_mod (e: MOD)
		local
			checker: TYPE_CHECKER
			eval: EVALUATOR
		do
			is_new := False

				-- type check left child
			create {TYPE_CHECKER} checker.default_create
			e.left.visit (checker)

				-- only proceed if left child is of correct type
			if checker.is_int then

					-- save type check results before resetting
				division_by_zero := checker.division_by_zero
				mod_by_not_positive := checker.mod_by_not_positive

					-- type check right child
				checker.reset
				e.right.visit (checker)

					-- only proceed if right child is of correct type
				if checker.is_int then

						-- set current attributes
					type_flag := type_int
					division_by_zero := division_by_zero or else checker.division_by_zero
					mod_by_not_positive := mod_by_not_positive or else checker.mod_by_not_positive
					if (not mod_by_not_positive) then
						if checker.value.is_integer_64 then
							mod_by_not_positive := (checker.value.to_integer_64 <= 0)
						end
						if (not mod_by_not_positive) then

								-- check if right child(i.e., modulus) is non-positive
							create {EVALUATOR} eval.default_create
							e.right.visit (eval)
							mod_by_not_positive := eval.value.has_substring ("%%!+")
							if ((not mod_by_not_positive) and then eval.value.is_integer_64) then
								mod_by_not_positive := (eval.value.to_integer_64 <= 0)
							end
						end
					end
				end
			end
		ensure then
			empty_value: value.is_empty
			correct_type: is_int or else (not is_type_correct)
		end

	visit_less_than_or_equal (e: LESS_THAN_OR_EQUAL)
		local
			checker: TYPE_CHECKER
		do
			is_new := False

				-- type check left child
			create {TYPE_CHECKER} checker.default_create
			e.left.visit (checker)

				-- only proceed if left child is of correct type
			if checker.is_int then

					-- save type check results before resetting
				if checker.value.is_integer_64 then
					value := checker.value
				end
				division_by_zero := checker.division_by_zero
				mod_by_not_positive := checker.mod_by_not_positive

					-- type check right child
				checker.reset
				e.right.visit (checker)

					-- only proceed if right child is of correct type
				if checker.is_int then

						-- set current attributes
					if ((not value.is_empty) and then checker.value.is_integer_64) then
						value := (value.to_integer_64 <= checker.value.to_integer_64).out
					else
							-- value is not known at this point
						value := ""
					end
					type_flag := type_bool
					division_by_zero := division_by_zero or else checker.division_by_zero
					mod_by_not_positive := mod_by_not_positive or else checker.mod_by_not_positive
				else
						-- not type_correct so empty value
					value := ""
				end
			end
		ensure then
			correct_value: value.is_empty or else value.is_boolean
			correct_type: is_bool or else (not is_type_correct)
		end

	visit_less_than (e: LESS_THAN)
		local
			checker: TYPE_CHECKER
		do
			is_new := False

				-- type check left child
			create {TYPE_CHECKER} checker.default_create
			e.left.visit (checker)

				-- only proceed if left child is of correct type
			if checker.is_int then

					-- save type check results before resetting
				if checker.value.is_integer_64 then
					value := checker.value
				end
				division_by_zero := checker.division_by_zero
				mod_by_not_positive := checker.mod_by_not_positive

					-- type check right child
				checker.reset
				e.right.visit (checker)

					-- only proceed if right child is of correct type
				if checker.is_int then

						-- set current attributes
					if ((not value.is_empty) and then checker.value.is_integer_64) then
						value := (value.to_integer_64 < checker.value.to_integer_64).out
					else
							-- value is not known at this point
						value := ""
					end
					type_flag := type_bool
					division_by_zero := division_by_zero or else checker.division_by_zero
					mod_by_not_positive := mod_by_not_positive or else checker.mod_by_not_positive
				else
						-- not type_correct so empty value
					value := ""
				end
			end
		ensure then
			correct_value: value.is_empty or else value.is_boolean
			correct_type: is_bool or else (not is_type_correct)
		end

	visit_greater_than (e: GREATER_THAN)
		local
			checker: TYPE_CHECKER
		do
			is_new := False

				-- type check left child
			create {TYPE_CHECKER} checker.default_create
			e.left.visit (checker)

				-- only proceed if left child is of correct type
			if checker.is_int then

					-- save type check results before resetting
				if checker.value.is_integer_64 then
					value := checker.value
				end
				division_by_zero := checker.division_by_zero
				mod_by_not_positive := checker.mod_by_not_positive

					-- type check right child
				checker.reset
				e.right.visit (checker)

					-- only proceed if right child is of correct type
				if checker.is_int then

						-- set current attributes
					if ((not value.is_empty) and then checker.value.is_integer_64) then
						value := (value.to_integer_64 > checker.value.to_integer_64).out
					else
							-- value is not known at this point
						value := ""
					end
					type_flag := type_bool
					division_by_zero := division_by_zero or else checker.division_by_zero
					mod_by_not_positive := mod_by_not_positive or else checker.mod_by_not_positive
				else
						-- not type_correct so empty value
					value := ""
				end
			end
		ensure then
			correct_value: value.is_empty or else value.is_boolean
			correct_type: is_bool or else (not is_type_correct)
		end

	visit_greater_than_or_equal (e: GREATER_THAN_OR_EQUAL)
		local
			checker: TYPE_CHECKER
		do
			is_new := False

				-- type check left child
			create {TYPE_CHECKER} checker.default_create
			e.left.visit (checker)

				-- only proceed if left child is of correct type
			if checker.is_int then

					-- save type check results before resetting
				if checker.value.is_integer_64 then
					value := checker.value
				end
				division_by_zero := checker.division_by_zero
				mod_by_not_positive := checker.mod_by_not_positive

					-- type check right child
				checker.reset
				e.right.visit (checker)

					-- only proceed if right child is of correct type
				if checker.is_int then

						-- set current attributes
					if ((not value.is_empty) and then checker.value.is_integer_64) then
						value := (value.to_integer_64 >= checker.value.to_integer_64).out
					else
							-- value is not known at this point
						value := ""
					end
					type_flag := type_bool
					division_by_zero := division_by_zero or else checker.division_by_zero
					mod_by_not_positive := mod_by_not_positive or else checker.mod_by_not_positive
				else
						-- not type_correct so empty value
					value := ""
				end
			end
		ensure then
			correct_value: value.is_empty or else value.is_boolean
			correct_type: is_bool or else (not is_type_correct)
		end

		-- Set

	visit_union (e: UNION)
		local
			left_c, right_c: TYPE_CHECKER
		do
			is_new := False

				-- type check left child
			create {TYPE_CHECKER} left_c.default_create
			e.left.visit (left_c)

				-- only proceed if left child is type correct and of correct type
			if (left_c.is_type_correct and then left_c.is_set_enum) then

					-- type check right child
				create {TYPE_CHECKER} right_c.default_create
				e.right.visit (right_c)

					-- only proceed if right child is type correct and of correct type
				if (right_c.is_type_correct and then right_c.is_set_enum) then

						-- handle the special cases with empty sets first

						-- note: L and R are used respectively to denote the left and the right sets when they are non-empty
					if (left_c.is_empty_set or else right_c.is_empty_set) then

							-- check which set is empty
						if left_c.is_empty_set then

								-- ({} \/ R) = R
								-- ({} \/ {}) = {}
							if right_c.is_empty_set then
								value := "{}"
							end
							type_flag := right_c.type_flag
							set_depth := right_c.set_depth
							division_by_zero := left_c.division_by_zero or else right_c.division_by_zero
							mod_by_not_positive := left_c.mod_by_not_positive or else right_c.mod_by_not_positive
						else -- right_c.is_empty_set

								-- (L \/ {}) = L
							type_flag := left_c.type_flag
							set_depth := left_c.set_depth
							division_by_zero := left_c.division_by_zero or else right_c.division_by_zero
							mod_by_not_positive := left_c.mod_by_not_positive or else right_c.mod_by_not_positive
						end

							-- (L \/ R) is only valid if they both have the same type and depth
					elseif ((left_c.type_flag = right_c.type_flag) and then (left_c.set_depth = right_c.set_depth)) then

							-- set current attributes
						type_flag := left_c.type_flag
						set_depth := left_c.set_depth
						division_by_zero := left_c.division_by_zero or else right_c.division_by_zero
						mod_by_not_positive := left_c.mod_by_not_positive or else right_c.mod_by_not_positive
					end
				end
			end
		ensure then
			correct_value: value.is_empty or else (value ~ "{}")
			correct_type: is_set_enum or else (not is_type_correct)
		end

	visit_intersection (e: INTERSECTION)
		local
			left_c, right_c: TYPE_CHECKER
			eval: EVALUATOR
		do
			is_new := False

				-- type check left child
			create {TYPE_CHECKER} left_c.default_create
			e.left.visit (left_c)

				-- only proceed if left child is type correct and of correct type
			if (left_c.is_type_correct and then left_c.is_set_enum) then

					-- type check right child
				create {TYPE_CHECKER} right_c.default_create
				e.right.visit (right_c)

					-- only proceed if right child is type correct and of correct type
				if (right_c.is_type_correct and then right_c.is_set_enum) then

						-- handle the special cases with empty sets first

						-- note: L and R are used respectively to denote the left and the right sets when they are non-empty
					if (left_c.is_empty_set or else right_c.is_empty_set) then

							-- ({} /\ R) = (L /\ {}) = ({} /\ {}) = {}
						value := "{}"
						type_flag := type_unknown
						set_depth := 1
						division_by_zero := left_c.division_by_zero or else right_c.division_by_zero
						mod_by_not_positive := left_c.mod_by_not_positive or else right_c.mod_by_not_positive

							-- (L /\ R) is only valid if they both have the same type and depth
					elseif ((left_c.type_flag = right_c.type_flag) and then (left_c.set_depth = right_c.set_depth)) then

							-- set current attributes
						type_flag := left_c.type_flag
						set_depth := left_c.set_depth
						division_by_zero := left_c.division_by_zero or else right_c.division_by_zero
						mod_by_not_positive := left_c.mod_by_not_positive or else right_c.mod_by_not_positive

							-- check if the result is the empty set
						create {EVALUATOR} eval.default_create
						eval.visit_intersection (e)
						value := eval.value -- save evaluation result so that it may be used elsewhere
						if (value ~ "{}") then

								-- even though neither set is empty, the intersection of the two is empty
								-- so set the current attributes to reflect this fact
							type_flag := type_unknown
							set_depth := 1
						end

							-- update 'division_by_zero' and 'mod_by_not_positive'
						division_by_zero := division_by_zero or else value.has_substring ("/0")
						mod_by_not_positive := mod_by_not_positive or else value.has_substring ("%%!+")
					end
				end
			end
		ensure then
			correct_value: value.is_empty or else (value.starts_with ("{") and then value.ends_with ("}"))
			correct_type: is_set_enum or else (not is_type_correct)
		end

	visit_difference (e: DIFFERENCE)
		local
			left_c, right_c: TYPE_CHECKER
			eval: EVALUATOR
		do
			is_new := False

				-- type check left child
			create {TYPE_CHECKER} left_c.default_create
			e.left.visit (left_c)

				-- only proceed if left child is type correct and of correct type
			if (left_c.is_type_correct and then left_c.is_set_enum) then

					-- type check right child
				create {TYPE_CHECKER} right_c.default_create
				e.right.visit (right_c)

					-- only proceed if right child is type correct and of correct type
				if (right_c.is_type_correct and then right_c.is_set_enum) then

						-- handle the special cases with empty sets first

						-- note: L and R are used respectively to denote the left and the right sets when they are non-empty
					if left_c.is_empty_set then

							-- ({} \ R) = ({} \ {}) = {}
						value := "{}"
						type_flag := type_unknown
						set_depth := 1
						division_by_zero := left_c.division_by_zero or else right_c.division_by_zero
						mod_by_not_positive := left_c.mod_by_not_positive or else right_c.mod_by_not_positive
					elseif right_c.is_empty_set then

							-- (L \ {}) = L
						type_flag := left_c.type_flag
						set_depth := left_c.set_depth
						division_by_zero := left_c.division_by_zero or else right_c.division_by_zero
						mod_by_not_positive := left_c.mod_by_not_positive or else right_c.mod_by_not_positive

							-- (L \ R) is only valid if they both have the same type and depth
					elseif ((left_c.type_flag = right_c.type_flag) and then (left_c.set_depth = right_c.set_depth)) then

							-- set current attributes
						type_flag := left_c.type_flag
						set_depth := left_c.set_depth
						division_by_zero := left_c.division_by_zero or else right_c.division_by_zero
						mod_by_not_positive := left_c.mod_by_not_positive or else right_c.mod_by_not_positive

							-- check if the result is the empty set
						create {EVALUATOR} eval.default_create
						eval.visit_difference (e)
						value := eval.value -- save evaluation result so that it may be used elsewhere
						if (value ~ "{}") then

								-- even though neither set is empty, the difference of the two is empty
								-- so set the current attributes to reflect this fact
							type_flag := type_unknown
							set_depth := 1
						end

							-- update 'division_by_zero' and 'mod_by_not_positive'
						division_by_zero := division_by_zero or else value.has_substring ("/0")
						mod_by_not_positive := mod_by_not_positive or else value.has_substring ("%%!+")
					end
				end
			end
		ensure then
			correct_value: value.is_empty or else (value.starts_with ("{") and then value.ends_with ("}"))
			correct_type: is_set_enum or else (not is_type_correct)
		end

	visit_subset_equal (e: SUBSET_EQUAL)
		local
			left_c, right_c: TYPE_CHECKER
		do
			is_new := False

				-- type check left child
			create {TYPE_CHECKER} left_c.default_create
			e.left.visit (left_c)

				-- only proceed if left child is type correct and of correct type
			if (left_c.is_type_correct and then left_c.is_set_enum) then

					-- type check right child
				create {TYPE_CHECKER} right_c.default_create
				e.right.visit (right_c)

					-- only proceed if right child is type correct and of correct type
				if (right_c.is_type_correct and then right_c.is_set_enum) then

						-- handle the special cases with empty sets first

						-- note: L and R are used respectively to denote the left and the right sets when they are non-empty
					if (left_c.is_empty_set or else right_c.is_empty_set) then

							-- set current attributes

							-- check which set is empty
						if left_c.is_empty_set then
							if right_c.is_empty_set then
									-- ({} <= {}) = True
								value := "True"
							else
									-- ({} <= R) = True
								value := "True"
							end
						else
								-- (L <= {}) = False
							value := "False"
						end
						type_flag := type_bool
						division_by_zero := left_c.division_by_zero or else right_c.division_by_zero
						mod_by_not_positive := left_c.mod_by_not_positive or else right_c.mod_by_not_positive

							-- (L <= R) is only valid if they both have the same type and depth
					elseif ((left_c.type_flag = right_c.type_flag) and then (left_c.set_depth = right_c.set_depth)) then

							-- set current attributes
						type_flag := type_bool
						division_by_zero := left_c.division_by_zero or else right_c.division_by_zero
						mod_by_not_positive := left_c.mod_by_not_positive or else right_c.mod_by_not_positive
					end
				end
			end
		ensure then
			correct_value: value.is_empty or else value.is_boolean
			correct_type: is_bool or else (not is_type_correct)
		end

	visit_subset_proper (e: SUBSET_PROPER)
		local
			left_c, right_c: TYPE_CHECKER
		do
			is_new := False

				-- type check left child
			create {TYPE_CHECKER} left_c.default_create
			e.left.visit (left_c)

				-- only proceed if left child is type correct and of correct type
			if (left_c.is_type_correct and then left_c.is_set_enum) then

					-- type check right child
				create {TYPE_CHECKER} right_c.default_create
				e.right.visit (right_c)

					-- only proceed if right child is type correct and of correct type
				if (right_c.is_type_correct and then right_c.is_set_enum) then

						-- handle the special cases with empty sets first

						-- note: L and R are used respectively to denote the left and the right sets when they are non-empty
					if (left_c.is_empty_set or else right_c.is_empty_set) then

							-- set current attributes

							-- check which set is empty
						if left_c.is_empty_set then
							if right_c.is_empty_set then
									-- ({} < {}) = False
								value := "False"
							else
									-- ({} < R) = True
								value := "True"
							end
						else
								-- (L < {}) = False
							value := "False"
						end
						type_flag := type_bool
						division_by_zero := left_c.division_by_zero or else right_c.division_by_zero
						mod_by_not_positive := left_c.mod_by_not_positive or else right_c.mod_by_not_positive

							-- (L < R) is only valid if they both have the same type and depth
					elseif ((left_c.type_flag = right_c.type_flag) and then (left_c.set_depth = right_c.set_depth)) then

							-- set current attributes
						type_flag := type_bool
						division_by_zero := left_c.division_by_zero or else right_c.division_by_zero
						mod_by_not_positive := left_c.mod_by_not_positive or else right_c.mod_by_not_positive
					end
				end
			end
		ensure then
			correct_value: value.is_empty or else value.is_boolean
			correct_type: is_bool or else (not is_type_correct)
		end

	visit_superset_equal (e: SUPERSET_EQUAL)
		local
			left_c, right_c: TYPE_CHECKER
		do
			is_new := False

				-- type check left child
			create {TYPE_CHECKER} left_c.default_create
			e.left.visit (left_c)

				-- only proceed if left child is type correct and of correct type
			if (left_c.is_type_correct and then left_c.is_set_enum) then

					-- type check right child
				create {TYPE_CHECKER} right_c.default_create
				e.right.visit (right_c)

					-- only proceed if right child is type correct and of correct type
				if (right_c.is_type_correct and then right_c.is_set_enum) then

						-- handle the special cases with empty sets first

						-- note: L and R are used respectively to denote the left and the right sets when they are non-empty
					if (left_c.is_empty_set or else right_c.is_empty_set) then

							-- set current attributes

							-- check which set is empty
						if left_c.is_empty_set then
							if right_c.is_empty_set then
									-- ({} >= {}) = True
								value := "True"
							else
									-- ({} >= R) = False
								value := "False"
							end
						else
								-- (L >= {}) = True
							value := "True"
						end
						type_flag := type_bool
						division_by_zero := left_c.division_by_zero or else right_c.division_by_zero
						mod_by_not_positive := left_c.mod_by_not_positive or else right_c.mod_by_not_positive

							-- (L >= R) is only valid if they both have the same type and depth
					elseif ((left_c.type_flag = right_c.type_flag) and then (left_c.set_depth = right_c.set_depth)) then

							-- set current attributes
						type_flag := type_bool
						division_by_zero := left_c.division_by_zero or else right_c.division_by_zero
						mod_by_not_positive := left_c.mod_by_not_positive or else right_c.mod_by_not_positive
					end
				end
			end
		ensure then
			correct_value: value.is_empty or else value.is_boolean
			correct_type: is_bool or else (not is_type_correct)
		end

	visit_superset_proper (e: SUPERSET_PROPER)
		local
			left_c, right_c: TYPE_CHECKER
		do
			is_new := False

				-- type check left child
			create {TYPE_CHECKER} left_c.default_create
			e.left.visit (left_c)

				-- only proceed if left child is type correct and of correct type
			if (left_c.is_type_correct and then left_c.is_set_enum) then

					-- type check right child
				create {TYPE_CHECKER} right_c.default_create
				e.right.visit (right_c)

					-- only proceed if right child is type correct and of correct type
				if (right_c.is_type_correct and then right_c.is_set_enum) then

						-- handle the special cases with empty sets first

						-- note: L and R are used respectively to denote the left and the right sets when they are non-empty
					if (left_c.is_empty_set or else right_c.is_empty_set) then

							-- set current attributes

							-- check which set is empty
						if left_c.is_empty_set then
							if right_c.is_empty_set then
									-- ({} > {}) = False
								value := "False"
							else
									-- ({} > R) = False
								value := "False"
							end
						else
								-- (L > {}) = True
							value := "True"
						end
						type_flag := type_bool
						division_by_zero := left_c.division_by_zero or else right_c.division_by_zero
						mod_by_not_positive := left_c.mod_by_not_positive or else right_c.mod_by_not_positive

							-- (L > R) is only valid if they both have the same type and depth
					elseif ((left_c.type_flag = right_c.type_flag) and then (left_c.set_depth = right_c.set_depth)) then

							-- set current attributes
						type_flag := type_bool
						division_by_zero := left_c.division_by_zero or else right_c.division_by_zero
						mod_by_not_positive := left_c.mod_by_not_positive or else right_c.mod_by_not_positive
					end
				end
			end
		ensure then
			correct_value: value.is_empty or else value.is_boolean
			correct_type: is_bool or else (not is_type_correct)
		end

feature -- Unary Op. Expressions

		-- Boolean

	visit_negation (e: NEGATION)
		local
			checker: TYPE_CHECKER
		do
			is_new := False

				-- type check child
			create {TYPE_CHECKER} checker.default_create
			e.child.visit (checker)

				-- only proceed if child is of correct type
			if checker.is_bool then

					-- set current attributes
				if checker.value.is_boolean then
					value := (not checker.value.to_boolean).out
				end
				type_flag := type_bool
				division_by_zero := checker.division_by_zero
				mod_by_not_positive := checker.mod_by_not_positive
			end
		ensure then
			correct_value: value.is_empty or else value.is_boolean
			correct_type: is_bool or else (not is_type_correct)
		end

	visit_count (e: COUNT)
		local
			checker: TYPE_CHECKER
		do
			is_new := False

				-- type check child
			create {TYPE_CHECKER} checker.default_create
			e.child.visit (checker)

				-- only proceed if child is of correct type
			if (checker.is_bool_set or else checker.is_empty_set) then

					-- set current attributes
				if (checker.type_flag = type_unknown) then -- checker.is_empty_set

						-- (# {}) = 0
					value := "0"
				end
				type_flag := type_int
				division_by_zero := checker.division_by_zero
				mod_by_not_positive := checker.mod_by_not_positive
			end
		ensure then
			correct_value: value.is_empty or else (value ~ "0")
			correct_type: is_int or else (not is_type_correct)
		end

	visit_for_all (e: FOR_ALL)
		local
			checker: TYPE_CHECKER
		do
			is_new := False

				-- type check child
			create {TYPE_CHECKER} checker.default_create
			e.child.visit (checker)

				-- only proceed if child is of correct type
			if (checker.is_bool_set or else checker.is_empty_set) then

					-- set current attributes
				if (checker.type_flag = type_unknown) then -- checker.is_empty_set

						-- (&& {}) = True
					value := "True"
				end
				type_flag := type_bool
				division_by_zero := checker.division_by_zero
				mod_by_not_positive := checker.mod_by_not_positive
			end
		ensure then
			correct_value: value.is_empty or else (value ~ "True")
			correct_type: is_bool or else (not is_type_correct)
		end

	visit_there_exists (e: THERE_EXISTS)
		local
			checker: TYPE_CHECKER
		do
			is_new := False

				-- type check child
			create {TYPE_CHECKER} checker.default_create
			e.child.visit (checker)

				-- only proceed if child is of correct type
			if (checker.is_bool_set or else checker.is_empty_set) then

					-- set current attributes
				if (checker.type_flag = type_unknown) then -- checker.is_empty_set

						-- (|| {}) = False
					value := "False"
				end
				type_flag := type_bool
				division_by_zero := checker.division_by_zero
				mod_by_not_positive := checker.mod_by_not_positive
			end
		ensure then
			correct_value: value.is_empty or else (value ~ "False")
			correct_type: is_bool or else (not is_type_correct)
		end

		-- Number

	visit_negative (e: NEGATIVE)
		local
			checker: TYPE_CHECKER
		do
			is_new := False

				-- type check child
			create {TYPE_CHECKER} checker.default_create
			e.child.visit (checker)

				-- only proceed if child is of correct type
			if checker.is_int then

					-- set current attributes
				if checker.value.is_integer_64 then
					value := (-1 * checker.value.to_integer_64).out
				end
				type_flag := type_int
				division_by_zero := checker.division_by_zero
				mod_by_not_positive := checker.mod_by_not_positive
			end
		ensure then
			correct_value: value.is_empty or else value.is_integer_64
			correct_type: is_int or else (not is_type_correct)
		end

	visit_summation (e: SUMMATION)
		local
			checker: TYPE_CHECKER
		do
			is_new := False

				-- type check child
			create {TYPE_CHECKER} checker.default_create
			e.child.visit (checker)

				-- only proceed if child is of correct type
			if (checker.is_int_set or else checker.is_empty_set) then

					-- set current attributes
				if (checker.type_flag = type_unknown) then -- checker.is_empty_set

						-- (+ {}) = 0
					value := "0"
				end
				type_flag := type_int
				division_by_zero := checker.division_by_zero
				mod_by_not_positive := checker.mod_by_not_positive
			end
		ensure then
			correct_value: value.is_empty or else (value ~ "0")
			correct_type: is_int or else (not is_type_correct)
		end

	visit_product (e: PRODUCT)
		local
			checker: TYPE_CHECKER
		do
			is_new := False

				-- type check child
			create {TYPE_CHECKER} checker.default_create
			e.child.visit (checker)

				-- only proceed if child is of correct type
			if (checker.is_int_set or else checker.is_empty_set) then

					-- set current attributes
				if (checker.type_flag = type_unknown) then -- checker.is_empty_set

						-- (* {}) = 0
					value := "0"
				end
				type_flag := type_int
				division_by_zero := checker.division_by_zero
				mod_by_not_positive := checker.mod_by_not_positive
			end
		ensure then
			correct_value: value.is_empty or else (value ~ "0")
			correct_type: is_int or else (not is_type_correct)
		end

feature -- Composite Expressions

	visit_set_enum (e: SET_ENUMERATION)
		local
			checker: TYPE_CHECKER
			ic: ITERATION_CURSOR [EXPRESSION]
		do
			is_new := False

				-- handle empty case
			if e.is_empty then

					-- set current attributes
				type_flag := type_unknown
				set_depth := 1
			else

					-- type check children
				from
					ic := e.new_cursor

						-- type check first child
					create {TYPE_CHECKER} checker.default_create
					ic.item.visit (checker)

						-- initialize current attributes
					type_flag := checker.type_flag
						-- to be incremented after loop if type correct
						-- this value is the expected 'set_depth' of every child of 'e'
					set_depth := checker.set_depth
					division_by_zero := checker.division_by_zero
					mod_by_not_positive := checker.mod_by_not_positive

						-- move to the second child so that the first child is not checked again if there is a second child
					if (e.count /= 1) then
						ic.forth
					end
				until
					ic.after or else (not is_type_correct) -- not (ic.has_next and then is_type_correct)
				loop
						-- type check current child
					checker.reset
					ic.item.visit (checker)

						-- only proceed if current child is type correct
					if checker.is_type_correct then

							-- check the current child's attributes against the expected values

						if (set_depth = 0) then -- 'e' contains constants(i.e., bools or ints)
							if ((type_flag = type_bool) or else (type_flag = type_int)) then
								if ((checker.type_flag /= type_flag) or else checker.is_set_enum) then
									type_flag := type_invalid
								end
							else
								type_flag := type_invalid
							end
						else -- 'e' contains sets
							if ((type_flag = type_bool) or else (type_flag = type_int)) then
									-- the child must be the empty set
								if (not (checker.is_empty_set
										-- or it must have the same 'type_flag' and 'set_depth'
									or else ((checker.type_flag = type_flag) and then (checker.set_depth = set_depth))))
								then
										-- for the parent set to be valid
									type_flag := type_invalid
								end
							elseif (type_flag = type_unknown) then
								if (checker.is_empty_set or else (checker.set_depth = set_depth)) then

										-- assign the parent's 'type_flag' to the child's 'type_flag'
										-- since one of the following two possibilities will occur:

										-- 1. the child's 'type_flag' is not 'type_unknown': then the parent's 'type_flag' has been determined
										-- and this block of code will never be executed again

										-- 2. the child's 'type_flag' is 'type_unknown': then the parent's 'type_flag' does not actually change
										-- and this block of code will be executed until either:
										-- i) the end of 'e' is reached
										-- ii) type incorrectness is determined in some other block of code
										-- iii) the above scenario(1) occurs

									type_flag := checker.type_flag
								else

										-- the child must be the empty set or a set of the same depth for the parent set to be valid
									type_flag := type_invalid
								end
							else
									-- invalid case that cannot occur
								check
									FALSE
								end
							end
						end

							-- or 'division_by_zero' with itself so that it is not assigned to False when it is already True
						division_by_zero := division_by_zero or else checker.division_by_zero
							-- or 'mod_by_not_positive' with itself so that it is not assigned to False when it is already True
						mod_by_not_positive := mod_by_not_positive or else checker.mod_by_not_positive

							-- move to the next child
						ic.forth
					else

							-- if the child is known to be invalid then the parent set is trivially invalid
						type_flag := type_invalid
					end
				end

					-- assign the current 'set_depth'
				if is_type_correct then
					set_depth := set_depth + 1
				else
					set_depth := 0
				end
			end
		ensure then
			empty_value: value.is_empty
			correct_type: is_set_enum or else (not is_type_correct)
		end

invariant
	different_type_flag_constants: (type_invalid /= type_unknown) and then (type_invalid /= type_bool) and then (type_invalid /= type_int) and then (type_unknown /= type_bool) and then (type_unknown /= type_int) and then (type_bool /= type_int)
	correct_type_flag: (type_flag = type_invalid) or else (type_flag = type_unknown) or else (type_flag = type_bool) or else (type_flag = type_int)
		--	set_depth_non_negative: set_depth >= 0
	set_depth_zero: (set_depth = 0) implies (type_flag /= type_unknown)
	correct_type: is_bool or else is_int or else is_set_enum or else (not is_type_correct)

end

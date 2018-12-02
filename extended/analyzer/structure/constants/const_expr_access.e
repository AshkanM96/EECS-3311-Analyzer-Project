note
	description: "Summary description for {CONST_EXPR_ACCESS}."
	author: "Ashkan Moatamed"

frozen expanded class
	CONST_EXPR_ACCESS

feature -- Singleton Accessors

		-- NULL_EXPRESSION

	null_cur: NULL_EXPRESSION
		once
			create {NULL_EXPRESSION} Result.make_cur
		ensure
			correct_result: Result.out ~ "?"
		end

	null_nil: NULL_EXPRESSION
		once
			create {NULL_EXPRESSION} Result.make_nil
		ensure
			correct_result: Result.out ~ "nil"
		end

		-- BOOLEAN_CONSTANT

	bool_true: BOOLEAN_CONSTANT
		once
			create {BOOLEAN_CONSTANT} Result.make (True)
		ensure
			correct_result: Result.out ~ "True"
		end

	bool_false: BOOLEAN_CONSTANT
		once
			create {BOOLEAN_CONSTANT} Result.make (False)
		ensure
			correct_result: Result.out ~ "False"
		end

	bool (b: BOOLEAN): BOOLEAN_CONSTANT
		do
			if b then
				Result := bool_true
			else
				Result := bool_false
			end
		ensure
			correct_result_b_true: b implies (Result = bool_true)
			correct_result_b_false: (not b) implies (Result = bool_false)
		end

		-- UNEVALUABLE_EXPRESSION

	div_by_zero: UNEVALUABLE_EXPRESSION
		once
			create {UNEVALUABLE_EXPRESSION} Result.make_div_by_zero
		ensure
			correct_result: Result.out ~ "/0"
		end

	mod_by_not_pos: UNEVALUABLE_EXPRESSION
		once
			create {UNEVALUABLE_EXPRESSION} Result.make_mod_by_not_pos
		ensure
			correct_result: Result.out ~ "%%!+"
		end

	div_by_zero_and_mod_by_not_pos: UNEVALUABLE_EXPRESSION
		once
			create {UNEVALUABLE_EXPRESSION} Result.make_div_by_zero_and_mod_by_not_pos
		ensure
			correct_result: Result.out ~ "/0%%!+"
		end

		-- EMPTY_SET_CONSTANT

	empty_set: EMPTY_SET_CONSTANT
		once
			create {EMPTY_SET_CONSTANT} Result.make
		ensure
			correct_result: Result.out ~ "{}"
		end

invariant

		-- NULL_EXPRESSION

	null_cur: null_cur = null_cur
	null_nil: null_nil = null_nil

		-- BOOLEAN_CONSTANT

	bool_true: bool_true = bool_true
	bool_false: bool_false = bool_false

		-- UNEVALUABLE_EXPRESSION

	div_by_zero: div_by_zero = div_by_zero
	mod_by_not_pos: mod_by_not_pos = mod_by_not_pos
	div_by_zero_and_mod_by_not_pos: div_by_zero_and_mod_by_not_pos = div_by_zero_and_mod_by_not_pos

		-- EMPTY_SET_CONSTANT

	empty_set: empty_set = empty_set

end

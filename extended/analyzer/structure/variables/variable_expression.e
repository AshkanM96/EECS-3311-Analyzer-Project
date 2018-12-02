note
	description: "Summary description for {VARIABLE_EXPRESSION}."
	author: "Ashkan Moatamed"

deferred class
	VARIABLE_EXPRESSION

inherit

	EXPRESSION

feature {NONE} -- Constant Expression Singleton Accessor

	frozen cea: CONST_EXPR_ACCESS

feature -- Reset

	reset
		deferred
		ensure
			open: is_open
		end

feature -- Type Queries

	frozen is_null: BOOLEAN = False

	frozen is_const: BOOLEAN = False

	is_binary_op: BOOLEAN
		do
			Result := False
		end

	is_unary_op: BOOLEAN
		do
			Result := False
		end

	is_set_enum: BOOLEAN
		do
			Result := False
		end

feature -- Output

	frozen special_operator_chars: IMMUTABLE_STRING_8
		once
			Result := "+-*/%%~^&|<>=!\#"
		end

	frozen valid_operator_char (c: CHARACTER_8): BOOLEAN
		do
			if (c.is_alpha and then c.is_lower) then
				Result := True
			elseif (special_operator_chars.has (c)) then
				Result := True
			else
				Result := False
			end
		end

feature -- Duplication

	dual: like Current
		deferred
		ensure then
			result_not_same_as_current: Result /= Current
		end

	deep_dual: like Current
		deferred
		ensure then
			result_not_same_as_current: Result /= Current
		end

end

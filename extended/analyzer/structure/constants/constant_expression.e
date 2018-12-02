note
	description: "Summary description for {CONSTANT_EXPRESSION}."
	author: "Ashkan Moatamed"

deferred class
	CONSTANT_EXPRESSION

inherit

	EXPRESSION

feature -- Expression Value

	frozen value: IMMUTABLE_STRING_8

feature -- Type Queries

	is_null: BOOLEAN
		do
			Result := False
		end

	frozen is_const: BOOLEAN = True

	frozen is_binary_op: BOOLEAN = False

	frozen is_unary_op: BOOLEAN = False

	frozen is_set_enum: BOOLEAN = False

feature -- State Queries

	is_open: BOOLEAN
		do
			Result := False
		end

	frozen is_open_rec: BOOLEAN
		do
			Result := is_open
		ensure then
			correct_result: Result = is_open
		end

feature -- Adding

	frozen add (e: EXPRESSION)
			-- no need
		do
		end

feature -- Equality

	frozen is_equal (other: like Current): BOOLEAN
		do
			if (Current = other) then
				Result := True
			else
				Result := (value ~ other.value)
			end
		end

feature -- Output

	frozen out: STRING
		do
			Result := value
		ensure then
			correct_result: Result ~ value
		end

feature -- Duplication

		-- CONSTANT_EXPRESSIONs are immutable therefore returning Current pointer is safe.

	frozen dual: like Current
		do
			Result := Current
		ensure then
			result_same_as_current: Result = Current
		end

	frozen deep_dual: like Current
		do
			Result := Current
		ensure then
			result_same_as_current: Result = Current
		end

invariant
	value_not_empty: not value.is_empty

end

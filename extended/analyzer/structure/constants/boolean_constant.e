note
	description: "Summary description for {BOOLEAN_CONSTANT}."
	author: "Ashkan Moatamed"

frozen class
	BOOLEAN_CONSTANT

inherit

	CONSTANT_EXPRESSION

create {CONST_EXPR_ACCESS}
	make, make_from_string

feature {NONE} -- Constructors

	make (b: BOOLEAN)
		do
			value := b.out
		ensure
			correct_value: value ~ b.out
		end

	make_from_string (s: IMMUTABLE_STRING_8)
		require
			valid_argument: (s /= Void) and then s.is_boolean
		do
			value := s
		ensure
			correct_value: value = s
		end

feature -- Visitor Pattern

	visit (v: VISITOR)
		do
			v.visit_boolean_constant (Current)
		end

invariant
	boolean_value: value.is_boolean

end

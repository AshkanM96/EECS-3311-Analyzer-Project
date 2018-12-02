note
	description: "Summary description for {INTEGER_CONSTANT}."
	author: "Ashkan Moatamed"

frozen class
	INTEGER_CONSTANT

inherit

	CONSTANT_EXPRESSION

create
	make, make_from_string

feature {NONE} -- Constructors

	make (i: INTEGER_64)
		do
			value := i.out
		ensure
			correct_value: value ~ i.out
		end

	make_from_string (s: IMMUTABLE_STRING_8)
		require
			valid_argument: (s /= Void) and then s.is_integer_64
		do
			value := s
		ensure
			correct_value: value = s
		end

feature -- Visitor Pattern

	visit (v: VISITOR)
		do
			v.visit_integer_constant (Current)
		end

invariant
	integer_value: value.is_integer_64

end

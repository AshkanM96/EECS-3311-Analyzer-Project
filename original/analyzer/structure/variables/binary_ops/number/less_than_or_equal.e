note
	description: "Summary description for {LESS_THAN_OR_EQUAL}."
	author: "Ashkan Moatamed"

frozen class
	LESS_THAN_OR_EQUAL

inherit

	BINARY_OP

create
	default_create

feature -- Output

	operator: STRING = "<="

feature -- Visitor Pattern

	visit (v: VISITOR)
		do
			v.visit_less_than_or_equal (Current)
		end

end

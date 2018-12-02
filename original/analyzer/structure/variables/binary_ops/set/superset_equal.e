note
	description: "Summary description for {SUPERSET_EQUAL}."
	author: "Ashkan Moatamed"

frozen class
	SUPERSET_EQUAL

inherit

	BINARY_OP

create
	default_create

feature -- Output

	operator: STRING = ">="

feature -- Visitor Pattern

	visit (v: VISITOR)
		do
			v.visit_superset_equal (Current)
		end

end

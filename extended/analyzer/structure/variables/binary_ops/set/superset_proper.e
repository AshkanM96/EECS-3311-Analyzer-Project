note
	description: "Summary description for {SUPERSET_PROPER}."
	author: "Ashkan Moatamed"

frozen class
	SUPERSET_PROPER

inherit

	BINARY_OP

create
	default_create

feature -- Output

	operator: STRING = ">"

feature -- Visitor Pattern

	visit (v: VISITOR)
		do
			v.visit_superset_proper (Current)
		end

end

note
	description: "Summary description for {INTERSECTION}."
	author: "Ashkan Moatamed"

frozen class
	INTERSECTION

inherit

	BINARY_OP

create
	default_create

feature -- Output

	operator: STRING = "/\"

feature -- Visitor Pattern

	visit (v: VISITOR)
		do
			v.visit_intersection (Current)
		end

end

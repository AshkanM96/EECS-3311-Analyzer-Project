note
	description: "Summary description for {UNION}."
	author: "Ashkan Moatamed"

frozen class
	UNION

inherit

	BINARY_OP

create
	default_create

feature -- Output

	operator: STRING = "\/"

feature -- Visitor Pattern

	visit (v: VISITOR)
		do
			v.visit_union (Current)
		end

end

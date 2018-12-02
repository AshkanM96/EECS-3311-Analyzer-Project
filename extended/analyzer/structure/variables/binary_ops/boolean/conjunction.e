note
	description: "Summary description for {CONJUNCTION}."
	author: "Ashkan Moatamed"

frozen class
	CONJUNCTION -- AND

inherit

	BINARY_OP

create
	default_create

feature -- Output

	operator: STRING = "&&"

feature -- Visitor Pattern

	visit (v: VISITOR)
		do
			v.visit_conjunction (Current)
		end

end

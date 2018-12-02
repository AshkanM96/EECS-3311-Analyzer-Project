note
	description: "Summary description for {EQUALITY}."
	author: "Ashkan Moatamed"

frozen class
	EQUALITY

inherit

	BINARY_OP

create
	default_create

feature -- Output

	operator: STRING = "="

feature -- Visitor Pattern

	visit (v: VISITOR)
		do
			v.visit_equality (Current)
		end

end

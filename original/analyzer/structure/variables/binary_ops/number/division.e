note
	description: "Summary description for {DIVISION}."
	author: "Ashkan Moatamed"

frozen class
	DIVISION

inherit

	BINARY_OP

create
	default_create

feature -- Output

	operator: STRING = "/"

feature -- Visitor Pattern

	visit (v: VISITOR)
		do
			v.visit_division (Current)
		end

end

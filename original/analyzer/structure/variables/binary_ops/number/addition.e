note
	description: "Summary description for {ADDITION}."
	author: "Ashkan Moatamed"

frozen class
	ADDITION

inherit

	BINARY_OP

create
	default_create

feature -- Output

	operator: STRING = "+"

feature -- Visitor Pattern

	visit (v: VISITOR)
		do
			v.visit_addition (Current)
		end

end

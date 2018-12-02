note
	description: "Summary description for {SUBTRACTION}."
	author: "Ashkan Moatamed"

frozen class
	SUBTRACTION

inherit

	BINARY_OP

create
	default_create

feature -- Output

	operator: STRING = "-"

feature -- Visitor Pattern

	visit (v: VISITOR)
		do
			v.visit_subtraction (Current)
		end

end

note
	description: "Summary description for {MULTIPLICATION}."
	author: "Ashkan Moatamed"

frozen class
	MULTIPLICATION

inherit

	BINARY_OP

create
	default_create

feature -- Output

	operator: STRING = "*"

feature -- Visitor Pattern

	visit (v: VISITOR)
		do
			v.visit_multiplication (Current)
		end

end

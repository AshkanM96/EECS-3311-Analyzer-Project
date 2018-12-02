note
	description: "Summary description for {DISJUNCTION}."
	author: "Ashkan Moatamed"

frozen class
	DISJUNCTION -- OR

inherit

	BINARY_OP

create
	default_create

feature -- Output

	operator: STRING = "||"

feature -- Visitor Pattern

	visit (v: VISITOR)
		do
			v.visit_disjunction (Current)
		end

end

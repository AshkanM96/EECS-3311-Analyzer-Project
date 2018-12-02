note
	description: "Summary description for {THERE_EXISTS}."
	author: "Ashkan Moatamed"

frozen class
	THERE_EXISTS

inherit

	UNARY_OP

create
	default_create

feature -- Output

	operator: STRING = "||"

feature -- Visitor Pattern

	visit (v: VISITOR)
		do
			v.visit_there_exists (Current)
		end

end

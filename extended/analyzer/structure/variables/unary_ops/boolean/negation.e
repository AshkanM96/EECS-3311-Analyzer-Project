note
	description: "Summary description for {NEGATION}."
	author: "Ashkan Moatamed"

frozen class
	NEGATION

inherit

	UNARY_OP

create
	default_create

feature -- Output

	operator: STRING = "!"

feature -- Visitor Pattern

	visit (v: VISITOR)
		do
			v.visit_negation (Current)
		end

end

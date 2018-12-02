note
	description: "Summary description for {SUMMATION}."
	author: "Ashkan Moatamed"

frozen class
	SUMMATION

inherit

	UNARY_OP

create
	default_create

feature -- Output

	operator: STRING = "+"

feature -- Visitor Pattern

	visit (v: VISITOR)
		do
			v.visit_summation (Current)
		end

end

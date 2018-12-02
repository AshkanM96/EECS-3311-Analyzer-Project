note
	description: "Summary description for {NEGATIVE}."
	author: "Ashkan Moatamed"

frozen class
	NEGATIVE

inherit

	UNARY_OP

create
	default_create

feature -- Output

	operator: STRING = "-"

feature -- Visitor Pattern

	visit (v: VISITOR)
		do
			v.visit_negative (Current)
		end

end

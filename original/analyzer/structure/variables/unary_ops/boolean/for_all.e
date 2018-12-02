note
	description: "Summary description for {FOR_ALL}."
	author: "Ashkan Moatamed"

frozen class
	FOR_ALL

inherit

	UNARY_OP

create
	default_create

feature -- Output

	operator: STRING = "&&"

feature -- Visitor Pattern

	visit (v: VISITOR)
		do
			v.visit_for_all (Current)
		end

end

note
	description: "Summary description for {COUNT}."
	author: "Ashkan Moatamed"

frozen class
	COUNT

inherit

	UNARY_OP

create
	default_create

feature -- Output

	operator: STRING = "#"

feature -- Visitor Pattern

	visit (v: VISITOR)
		do
			v.visit_count (Current)
		end

end

note
	description: "Summary description for {DIFFERENCE}."
	author: "Ashkan Moatamed"

frozen class
	DIFFERENCE

inherit

	BINARY_OP

create
	default_create

feature -- Output

	operator: STRING = "\"

feature -- Visitor Pattern

	visit (v: VISITOR)
		do
			v.visit_difference (Current)
		end

end

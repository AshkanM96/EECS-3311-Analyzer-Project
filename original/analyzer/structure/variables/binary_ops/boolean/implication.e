note
	description: "Summary description for {IMPLICATION}."
	author: "Ashkan Moatamed"

frozen class
	IMPLICATION

inherit

	BINARY_OP

create
	default_create

feature -- Output

	operator: STRING = "=>"

feature -- Visitor Pattern

	visit (v: VISITOR)
		do
			v.visit_implication (Current)
		end

end

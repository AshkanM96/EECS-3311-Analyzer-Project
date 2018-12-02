note
	description: "Summary description for {MOD}."
	author: "Ashkan Moatamed"

frozen class
	MOD

inherit

	BINARY_OP

create
	default_create

feature -- Output

	operator: STRING = "mod"

feature -- Visitor Pattern

	visit (v: VISITOR)
		do
			v.visit_mod (Current)
		end

end

note
	description: "Summary description for {LESS_THAN}."
	author: "Ashkan Moatamed"

frozen class
	LESS_THAN

inherit

	BINARY_OP

create
	default_create

feature -- Output

	operator: STRING = "<"

feature -- Visitor Pattern

	visit (v: VISITOR)
		do
			v.visit_less_than (Current)
		end

end

note
	description: "Summary description for {GREATER_THAN}."
	author: "Ashkan Moatamed"

frozen class
	GREATER_THAN

inherit

	BINARY_OP

create
	default_create

feature -- Output

	operator: STRING = ">"

feature -- Visitor Pattern

	visit (v: VISITOR)
		do
			v.visit_greater_than (Current)
		end

end

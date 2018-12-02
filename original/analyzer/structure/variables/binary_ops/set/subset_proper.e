note
	description: "Summary description for {SUBSET_PROPER}."
	author: "Ashkan Moatamed"

frozen class
	SUBSET_PROPER

inherit

	BINARY_OP

create
	default_create

feature -- Output

	operator: STRING = "<"

feature -- Visitor Pattern

	visit (v: VISITOR)
		do
			v.visit_subset_proper (Current)
		end

end

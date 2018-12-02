note
	description: "Summary description for {SUBSET_EQUAL}."
	author: "Ashkan Moatamed"

frozen class
	SUBSET_EQUAL

inherit

	BINARY_OP

create
	default_create

feature -- Output

	operator: STRING = "<="

feature -- Visitor Pattern

	visit (v: VISITOR)
		do
			v.visit_subset_equal (Current)
		end

end

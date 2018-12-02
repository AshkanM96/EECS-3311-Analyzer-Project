note
	description: "Summary description for {EXCLUSIVE_DISJUNCTION}."
	author: "Ashkan Moatamed"

frozen class
	EXCLUSIVE_DISJUNCTION -- XOR

inherit

	BINARY_OP

create
	default_create

feature -- Output

	operator: STRING = "xor"

feature -- Visitor Pattern

	visit (v: VISITOR)
		do
			v.visit_exclusive_disjunction (Current)
		end

end

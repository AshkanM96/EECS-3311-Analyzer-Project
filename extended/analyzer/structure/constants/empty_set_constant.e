note
	description: "Summary description for {EMPTY_SET_CONSTANT}."
	author: "Ashkan Moatamed"

frozen class
	EMPTY_SET_CONSTANT

inherit

	CONSTANT_EXPRESSION

create {CONST_EXPR_ACCESS}
	make

feature {NONE} -- Constructor

	make
		do
			value := "{}"
		end

feature -- Visitor Pattern

	visit (v: VISITOR)
		do
			v.visit_empty_set_constant (Current)
		end

invariant
	empty_set_value: value ~ "{}"

end

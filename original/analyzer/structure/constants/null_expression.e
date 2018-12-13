note
	description: "Summary description for {NULL_EXPRESSION}."
	author: "Ashkan Moatamed"

frozen class
	NULL_EXPRESSION

inherit

	CONSTANT_EXPRESSION
		redefine
			is_null
		end

create {CONST_EXPR_ACCESS}
	make_cur, make_nil

feature {NONE} -- Constructors

	make_cur
		do
			value := "?"
		ensure
			correct_value: value ~ "?"
		end

	make_nil
		do
			value := "nil"
		ensure
			correct_value: value ~ "nil"
		end

feature -- Type Queries

	is_null: BOOLEAN = True

feature -- Visitor Pattern

	visit (v: VISITOR)
		do
			v.visit_null_expression (Current)
		end

invariant
	null_value: (value ~ "?") or else (value ~ "nil")

end

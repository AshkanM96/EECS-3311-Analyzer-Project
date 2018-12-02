note
	description: "[
		This class is used in EVALUATOR and TYPE_CHECKER in order to be able to correctly type_check expressions that need to be evaluated even though they contain at least one unevaluable expression.
		For example: Evaluating the intersection of two sets where at least one of them contains at least one unevaluable expression as an element.
	]"
	author: "Ashkan Moatamed"

frozen class
	UNEVALUABLE_EXPRESSION

inherit

	CONSTANT_EXPRESSION

create {CONST_EXPR_ACCESS}
	make_div_by_zero, make_mod_by_not_pos, make_div_by_zero_and_mod_by_not_pos

feature {NONE} -- Constructor

	make_div_by_zero
		do
			value := "/0"
		ensure
			correct_value: value ~ "/0"
		end

	make_mod_by_not_pos
		do
			value := "%%!+"
		ensure
			correct_value: value ~ "%%!+"
		end

	make_div_by_zero_and_mod_by_not_pos
		do
			value := "/0%%!+"
		ensure
			correct_value: value ~ "/0%%!+"
		end

feature -- Visitor Pattern

	visit (v: VISITOR)
		do
			v.visit_unevaluable_expression (Current)
		end

end

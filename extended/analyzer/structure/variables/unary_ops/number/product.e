note
	description: "Summary description for {PRODUCT}."
	author: "Ashkan Moatamed"

frozen class
	PRODUCT

inherit

	UNARY_OP

create
	default_create

feature -- Output

	operator: STRING = "*"

feature -- Visitor Pattern

	visit (v: VISITOR)
		do
			v.visit_product (Current)
		end

end

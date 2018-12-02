note
	description: "Summary description for {ETF_STR_PARAM}."
	author: "Jackie Wang"

frozen class
	ETF_STR_PARAM

inherit

	ETF_PRIMITIVE_PARAM_TYPE
		redefine
			out,
			eiffel_type
		end

create
	default_create

feature -- Queries

	eiffel_type: STRING
		do
			Result := out
		end

	create_clause: STRING = "create {ETF_STR_PARAM}"

	out: STRING = "STRING"

end

note
	description: "Summary description for {ETF_INT_PARAM}."
	author: "Jackie Wang"

frozen class
	ETF_INT_PARAM

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

	create_clause: STRING = "create {ETF_INT_PARAM}"

	out: STRING = "INTEGER_64"

end

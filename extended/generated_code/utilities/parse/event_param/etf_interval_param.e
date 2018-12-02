note
	description: "Summary description for {ETF_INTERVAL_PARAM}."
	author: "Jackie Wang"

frozen class
	ETF_INTERVAL_PARAM

inherit

	ETF_PRIMITIVE_PARAM_TYPE
		redefine
			out,
			eiffel_type
		end

create
	make

feature -- Attribute(s)

	lower, upper: INTEGER_64

feature -- Constructor

	make (l, u: INTEGER_64)
		do
			lower := l
			upper := u
		end

feature -- Queries

	eiffel_type: STRING = "INTEGER_64"

	create_clause: STRING
		do
			Result := "create {ETF_INTERVAL_PARAM}.make(" + lower.out + ", " + upper.out + ")"
		end

	out: STRING
		do
			Result := lower.out + " .. " + upper.out
		end

end

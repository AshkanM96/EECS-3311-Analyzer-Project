note
	description: "Summary description for {ETF_TUPLE_PARAM}."
	author: "Jackie Wang"

frozen class
	ETF_TUPLE_PARAM

inherit

	ETF_PRIMITIVE_PARAM_TYPE
		redefine
			out,
			eiffel_type
		end

create
	make

feature -- Attribute(s)

	base_types: ARRAY [ETF_PARAM_DECL]

feature -- Constructor

	make (types: ARRAY [ETF_PARAM_DECL])
		do
			base_types := types
		end

feature -- Queries

	eiffel_type: STRING
		do
			Result := out
		end

	create_clause: STRING
		local
			i: INTEGER
		do
			from
				create {STRING} Result.make_from_string ("create {ETF_TUPLE_PARAM}.make(<<")
				i := base_types.lower
			until
				i > base_types.upper
			loop
				Result.append ("create {ETF_PARAM_DECL}.make(%"" + base_types [i].name + "%", " + base_types [i].type.create_clause + ")")
				if (i < base_types.upper) then
					Result.append (", ")
				end
				i := i + 1
			end
			Result.append (">>)")
		end

	out: STRING
		local
			i: INTEGER
		do
			from
				create {STRING} Result.make_from_string ("TUPLE[")
				i := base_types.lower
			until
				i > base_types.upper
			loop
				Result.append (base_types [i].name + ": " + base_types [i].type.out)
				if (i < base_types.upper) then
					Result.append ("; ")
				end
				i := i + 1
			end
			Result.append ("]")
		end

end

note
	description: "Summary description for {ETF_ENUM_PARAM}."
	author: "Jackie Wang"

frozen class
	ETF_ENUM_PARAM

inherit

	ETF_PRIMITIVE_PARAM_TYPE
		redefine
			out,
			eiffel_type
		end

create
	make

feature -- Attribute

	items: ARRAY [STRING]

feature -- Constructor

	make (list: ARRAY [STRING])
		do
			items := list
		end

feature -- Queries

	eiffel_type: STRING = "INTEGER_64"

	create_clause: STRING
		local
			i: INTEGER
		do
			create {STRING} Result.make_from_string ("create {ETF_ENUM_PARAM}.make(<<")
			from
				i := items.lower
			until
				i > items.upper
			loop
				Result.append ("%"" + items [i] + "%"")
				if (i < items.upper) then
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
			create {STRING} Result.make_from_string ("{")
			from
				i := items.lower
			until
				i > items.upper
			loop
				Result.append (items [i])
				if (i < items.upper) then
					Result.append (", ")
				end
				i := i + 1
			end
			Result.append ("}")
		end

end

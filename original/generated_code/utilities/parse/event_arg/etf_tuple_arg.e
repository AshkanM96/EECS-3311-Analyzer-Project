note
	description: "Summary description for {ETF_TUPLE_ARG}."
	author: "Jackie Wang"

frozen class
	ETF_TUPLE_ARG

inherit

	ETF_PRIMITIVE_ARG
		redefine
			out
		end

create
	make

feature -- Queries

	value: ARRAY [ETF_EVT_ARG]

feature -- Constructor

	make (v: ARRAY [ETF_EVT_ARG])
		do
			create {STRING} src_out.make_empty
			value := v
		end

feature -- Output

	out: STRING
		local
			i: INTEGER
		do
			from
				create {STRING} Result.make_from_string ("[")
				i := value.lower
			until
				i > value.upper
			loop
				if value [i].src_out.is_empty then
					Result.append (value [i].out)
				else
					Result.append (value [i].src_out)
				end
				if (i < value.upper) then
					Result.append (", ")
				end
				i := i + 1
			end
			Result.append ("]")
		end

end

note
	description: "Summary description for {ETF_CHAR_ARG}."
	author: "Jackie Wang"

frozen class
	ETF_CHAR_ARG

inherit

	ETF_PRIMITIVE_ARG
		redefine
			out
		end

create
	make

feature -- Queries

	value: CHARACTER

feature -- Constructor

	make (c: CHARACTER)
		do
			create {STRING} src_out.make_empty
			value := c
		end

feature -- Output

	out: STRING
		do
			Result := "'" + value.out + "'"
		end

end

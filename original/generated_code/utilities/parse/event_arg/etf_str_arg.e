note
	description: "Summary description for {ETF_STR_ARG}."
	author: "Jackie Wang"

frozen class
	ETF_STR_ARG

inherit

	ETF_PRIMITIVE_ARG
		redefine
			out
		end

create
	make

feature -- Queries

	value: STRING

feature -- Constructor

	make (s: STRING)
		do
			create {STRING} src_out.make_empty
			value := s
		end

feature -- Output

	out: STRING
		do
			Result := "%"" + value.out + "%""
		end

end

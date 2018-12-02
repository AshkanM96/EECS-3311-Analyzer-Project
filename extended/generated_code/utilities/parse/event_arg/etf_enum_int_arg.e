note
	description: "Summary description for {ETF_INT_ARG}."
	author: "Jackie Wang"

frozen class
	ETF_ENUM_INT_ARG

inherit

	ETF_PRIMITIVE_ARG
		redefine
			out
		end

create
	make

feature -- Queries

	value: INTEGER_64

feature -- Constructor

	make (i: INTEGER_64)
		do
			create {STRING} src_out.make_empty
			value := i
		end

feature -- Output

	out: STRING
		do
			Result := value.out
		end

end

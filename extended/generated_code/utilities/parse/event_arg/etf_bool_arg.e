note
	description: "Summary description for {ETF_BOOL_ARG}."
	author: "Jackie Wang"

frozen class
	ETF_BOOL_ARG

inherit

	ETF_PRIMITIVE_ARG
		redefine
			out
		end

create
	make

feature -- Queries

	value: BOOLEAN

feature -- Constructor

	make (b: BOOLEAN)
		do
			create {STRING} src_out.make_empty
			value := b
		end

feature -- Output

	out: STRING
		do
			Result := value.out
		end

end

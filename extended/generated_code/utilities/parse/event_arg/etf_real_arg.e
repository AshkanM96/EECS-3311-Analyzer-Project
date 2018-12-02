note
	description: "Summary description for {ETF_REAL_ARG}."
	author: "Jackie Wang"

frozen class
	ETF_REAL_ARG

inherit

	ETF_PRIMITIVE_ARG
		redefine
			out
		end

create
	make

feature -- Queries

	value: REAL_64

feature -- Constructor

	make (r: REAL_64)
		do
			create {STRING} src_out.make_empty
			value := r
		end

feature -- Output

	out: STRING
		do
			Result := value.out
		end

end

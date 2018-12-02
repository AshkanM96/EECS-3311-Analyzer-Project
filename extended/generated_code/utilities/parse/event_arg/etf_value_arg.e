note
	description: "Summary description for {ETF_VALUE_ARG}."
	author: "Jackie Wang"

frozen class
	ETF_VALUE_ARG

inherit

	ETF_PRIMITIVE_ARG
		redefine
			out
		end

create
	make

feature -- Queries

	value: VALUE

feature -- Constructor

	make (s: STRING)
		do
			src_out := s
			create {VALUE} value.make_from_string (s)
		end

feature -- Output

	out: STRING
		do
			Result := value.precise_out
		end

end

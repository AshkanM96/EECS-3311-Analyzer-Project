note
	description: "Summary description for {ETF_PARAM_DECL}."
	author: "Jackie Wang"

frozen class
	ETF_PARAM_DECL

create
	make

feature -- Attribute(s)

	name: STRING

	type: ETF_PARAM_TYPE

feature -- Constructor

	make (n: STRING; t: ETF_PARAM_TYPE)
		do
			name := n
			type := t
		end

end

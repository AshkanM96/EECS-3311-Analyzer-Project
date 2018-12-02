note
	author: "Ashkan Moatamed"

frozen class
	ETF_INTEGER_CONSTANT

inherit

	ETF_INTEGER_CONSTANT_INTERFACE

create
	make

feature -- command

	integer_constant (c: INTEGER_64)
		do
			if model.is_complete_expression then
				model.set_report (model.emra.report_complete)
			else
				model.add_integer_constant (c)
			end
			etf_cmd_container.on_change.notify ([Current])
		end

end

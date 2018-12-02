note
	author: "Ashkan Moatamed"

frozen class
	ETF_BOOLEAN_CONSTANT

inherit

	ETF_BOOLEAN_CONSTANT_INTERFACE

create
	make

feature -- command

	boolean_constant (c: BOOLEAN)
		do
			if model.is_complete_expression then
				model.set_report (model.emra.report_complete)
			else
				model.add_boolean_constant (c)
			end
			etf_cmd_container.on_change.notify ([Current])
		end

end

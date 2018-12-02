note
	author: "Ashkan Moatamed"

frozen class
	ETF_EMPTY_SET_CONSTANT

inherit

	ETF_EMPTY_SET_CONSTANT_INTERFACE

create
	make

feature -- command

	empty_set_constant -- {}
		do
			if model.is_complete_expression then
				model.set_report (model.emra.report_complete)
			else
				model.add_empty_set_constant
			end
			etf_cmd_container.on_change.notify ([Current])
		end

end

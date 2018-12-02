note
	author: "Ashkan Moatamed"

frozen class
	ETF_SUBTRACT

inherit

	ETF_SUBTRACT_INTERFACE

create
	make

feature -- command

	subtract
		do
			if model.is_complete_expression then
				model.set_report (model.emra.report_complete)
			else
				model.add_subtraction
			end
			etf_cmd_container.on_change.notify ([Current])
		end

end

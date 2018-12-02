note
	author: "Ashkan Moatamed"

frozen class
	ETF_RESET

inherit

	ETF_RESET_INTERFACE

create
	make

feature -- command

	reset
		do
			if model.is_new_expression then
				model.set_report (model.emra.report_cannot_reset)
			else
				model.reset
			end
			etf_cmd_container.on_change.notify ([Current])
		end

end

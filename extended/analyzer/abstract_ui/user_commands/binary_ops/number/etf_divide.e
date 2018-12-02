note
	author: "Ashkan Moatamed"

frozen class
	ETF_DIVIDE

inherit

	ETF_DIVIDE_INTERFACE

create
	make

feature -- command

	divide
		do
			if model.is_complete_expression then
				model.set_report (model.emra.report_complete)
			else
				model.add_division
			end
			etf_cmd_container.on_change.notify ([Current])
		end

end

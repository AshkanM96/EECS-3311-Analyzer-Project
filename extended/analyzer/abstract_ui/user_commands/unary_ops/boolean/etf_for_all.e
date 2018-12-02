note
	author: "Ashkan Moatamed"

frozen class
	ETF_FOR_ALL

inherit

	ETF_FOR_ALL_INTERFACE

create
	make

feature -- command

	for_all
		do
			if model.is_complete_expression then
				model.set_report (model.emra.report_complete)
			else
				model.add_for_all
			end
			etf_cmd_container.on_change.notify ([Current])
		end

end

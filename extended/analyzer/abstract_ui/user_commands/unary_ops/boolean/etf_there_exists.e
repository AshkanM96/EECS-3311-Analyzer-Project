note
	author: "Ashkan Moatamed"

frozen class
	ETF_THERE_EXISTS

inherit

	ETF_THERE_EXISTS_INTERFACE

create
	make

feature -- command

	there_exists
		do
			if model.is_complete_expression then
				model.set_report (model.emra.report_complete)
			else
				model.add_there_exists
			end
			etf_cmd_container.on_change.notify ([Current])
		end

end

note
	author: "Ashkan Moatamed"

frozen class
	ETF_LESS_THAN

inherit

	ETF_LESS_THAN_INTERFACE

create
	make

feature -- command

	less_than
		do
			if model.is_complete_expression then
				model.set_report (model.emra.report_complete)
			else
				model.add_less_than
			end
			etf_cmd_container.on_change.notify ([Current])
		end

end

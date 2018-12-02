note
	author: "Ashkan Moatamed"

frozen class
	ETF_DIFFERENCE

inherit

	ETF_DIFFERENCE_INTERFACE

create
	make

feature -- command

	difference
		do
			if model.is_complete_expression then
				model.set_report (model.emra.report_complete)
			else
				model.add_difference
			end
			etf_cmd_container.on_change.notify ([Current])
		end

end

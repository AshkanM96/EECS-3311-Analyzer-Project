note
	author: "Ashkan Moatamed"

frozen class
	ETF_COUNT

inherit

	ETF_COUNT_INTERFACE

create
	make

feature -- command

	count
		do
			if model.is_complete_expression then
				model.set_report (model.emra.report_complete)
			else
				model.add_count
			end
			etf_cmd_container.on_change.notify ([Current])
		end

end

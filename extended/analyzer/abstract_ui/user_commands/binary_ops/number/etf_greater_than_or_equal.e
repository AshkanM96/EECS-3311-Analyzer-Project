note
	author: "Ashkan Moatamed"

frozen class
	ETF_GREATER_THAN_OR_EQUAL

inherit

	ETF_GREATER_THAN_OR_EQUAL_INTERFACE

create
	make

feature -- command

	greater_than_or_equal
		do
			if model.is_complete_expression then
				model.set_report (model.emra.report_complete)
			else
				model.add_greater_than_or_equal
			end
			etf_cmd_container.on_change.notify ([Current])
		end

end

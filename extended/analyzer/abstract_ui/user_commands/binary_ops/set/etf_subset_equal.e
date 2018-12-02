note
	author: "Ashkan Moatamed"

frozen class
	ETF_SUBSET_EQUAL

inherit

	ETF_SUBSET_EQUAL_INTERFACE

create
	make

feature -- command

	subset_equal
		do
			if model.is_complete_expression then
				model.set_report (model.emra.report_complete)
			else
				model.add_subset_equal
			end
			etf_cmd_container.on_change.notify ([Current])
		end

end

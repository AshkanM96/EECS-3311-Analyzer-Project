note
	author: "Ashkan Moatamed"

frozen class
	ETF_SUBSET_PROPER

inherit

	ETF_SUBSET_PROPER_INTERFACE

create
	make

feature -- command

	subset_proper
		do
			if model.is_complete_expression then
				model.set_report (model.emra.report_complete)
			else
				model.add_subset_proper
			end
			etf_cmd_container.on_change.notify ([Current])
		end

end

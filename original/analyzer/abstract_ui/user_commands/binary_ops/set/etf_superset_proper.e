note
	author: "Ashkan Moatamed"

frozen class
	ETF_SUPERSET_PROPER

inherit

	ETF_SUPERSET_PROPER_INTERFACE

create
	make

feature -- command

	superset_proper
		do
			if model.is_complete_expression then
				model.set_report (model.emra.report_complete)
			else
				model.add_superset_proper
			end
			etf_cmd_container.on_change.notify ([Current])
		end

end

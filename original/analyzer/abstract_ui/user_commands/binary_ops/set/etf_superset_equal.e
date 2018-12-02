note
	author: "Ashkan Moatamed"

frozen class
	ETF_SUPERSET_EQUAL

inherit

	ETF_SUPERSET_EQUAL_INTERFACE

create
	make

feature -- command

	superset_equal
		do
			if model.is_complete_expression then
				model.set_report (model.emra.report_complete)
			else
				model.add_superset_equal
			end
			etf_cmd_container.on_change.notify ([Current])
		end

end

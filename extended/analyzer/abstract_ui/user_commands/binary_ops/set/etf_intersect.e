note
	author: "Ashkan Moatamed"

frozen class
	ETF_INTERSECT

inherit

	ETF_INTERSECT_INTERFACE

create
	make

feature -- command

	intersect
		do
			if model.is_complete_expression then
				model.set_report (model.emra.report_complete)
			else
				model.add_intersection
			end
			etf_cmd_container.on_change.notify ([Current])
		end

end

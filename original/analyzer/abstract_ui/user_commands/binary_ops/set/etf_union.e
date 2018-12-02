note
	author: "Ashkan Moatamed"

frozen class
	ETF_UNION

inherit

	ETF_UNION_INTERFACE

create
	make

feature -- command

	union
		do
			if model.is_complete_expression then
				model.set_report (model.emra.report_complete)
			else
				model.add_union
			end
			etf_cmd_container.on_change.notify ([Current])
		end

end

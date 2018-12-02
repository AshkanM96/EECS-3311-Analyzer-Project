note
	author: "Ashkan Moatamed"

frozen class
	ETF_ADD

inherit

	ETF_ADD_INTERFACE

create
	make

feature -- command

	add
		do
			if model.is_complete_expression then
				model.set_report (model.emra.report_complete)
			else
				model.add_addition
			end
			etf_cmd_container.on_change.notify ([Current])
		end

end

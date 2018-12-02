note
	author: "Ashkan Moatamed"

frozen class
	ETF_EQUALS

inherit

	ETF_EQUALS_INTERFACE

create
	make

feature -- command

	equals
		do
			if model.is_complete_expression then
				model.set_report (model.emra.report_complete)
			else
				model.add_equality
			end
			etf_cmd_container.on_change.notify ([Current])
		end

end

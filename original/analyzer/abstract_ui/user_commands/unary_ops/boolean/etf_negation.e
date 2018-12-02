note
	author: "Ashkan Moatamed"

frozen class
	ETF_NEGATION

inherit

	ETF_NEGATION_INTERFACE

create
	make

feature -- command

	negation
		do
			if model.is_complete_expression then
				model.set_report (model.emra.report_complete)
			else
				model.add_negation
			end
			etf_cmd_container.on_change.notify ([Current])
		end

end

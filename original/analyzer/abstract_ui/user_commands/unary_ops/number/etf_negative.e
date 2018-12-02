note
	author: "Ashkan Moatamed"

frozen class
	ETF_NEGATIVE

inherit

	ETF_NEGATIVE_INTERFACE

create
	make

feature -- command

	negative
		do
			if model.is_complete_expression then
				model.set_report (model.emra.report_complete)
			else
				model.add_negative
			end
			etf_cmd_container.on_change.notify ([Current])
		end

end

note
	author: "Ashkan Moatamed"

frozen class
	ETF_MULTIPLY

inherit

	ETF_MULTIPLY_INTERFACE

create
	make

feature -- command

	multiply
		do
			if model.is_complete_expression then
				model.set_report (model.emra.report_complete)
			else
				model.add_multiplication
			end
			etf_cmd_container.on_change.notify ([Current])
		end

end

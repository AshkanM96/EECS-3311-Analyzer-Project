note
	author: "Ashkan Moatamed"

frozen class
	ETF_SUM

inherit

	ETF_SUM_INTERFACE

create
	make

feature -- command

	sum
		do
			if model.is_complete_expression then
				model.set_report (model.emra.report_complete)
			else
				model.add_summation
			end
			etf_cmd_container.on_change.notify ([Current])
		end

end

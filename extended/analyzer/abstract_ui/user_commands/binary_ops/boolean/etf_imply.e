note
	author: "Ashkan Moatamed"

frozen class
	ETF_IMPLY

inherit

	ETF_IMPLY_INTERFACE

create
	make

feature -- command

	imply
		do
			if model.is_complete_expression then
				model.set_report (model.emra.report_complete)
			else
				model.add_implication
			end
			etf_cmd_container.on_change.notify ([Current])
		end

end

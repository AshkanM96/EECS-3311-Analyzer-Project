note
	author: "Ashkan Moatamed"

frozen class
	ETF_TYPE_CHECK

inherit

	ETF_TYPE_CHECK_INTERFACE

create
	make

feature -- command

	type_check
		do
			if (not model.is_complete_expression) then
				model.set_report (model.emra.report_incomplete)
			else
				model.set_report (model.type_check)
			end
			etf_cmd_container.on_change.notify ([Current])
		end

end

note
	author: "Ashkan Moatamed"

frozen class
	ETF_CLOSE_SET_ENUMERATION

inherit

	ETF_CLOSE_SET_ENUMERATION_INTERFACE

create
	make

feature -- command

	close_set_enumeration
		do
			if model.is_complete_expression then
				model.set_report (model.emra.report_complete)
			elseif (not model.specifying_set_enum) then
				model.set_report (model.emra.report_not_set_enum)
			elseif model.is_empty_set_enum then
				model.set_report (model.emra.report_empty_set_enum)
			else
				model.close_set_enum
			end
			etf_cmd_container.on_change.notify ([Current])
		end

end

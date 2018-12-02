note
	author: "Ashkan Moatamed"

frozen class
	ETF_OPEN_SET_ENUMERATION

inherit

	ETF_OPEN_SET_ENUMERATION_INTERFACE

create
	make

feature -- command

	open_set_enumeration
		do
			if model.is_complete_expression then
				model.set_report (model.emra.report_complete)
			else
				model.add_set_enum
			end
			etf_cmd_container.on_change.notify ([Current])
		end

end

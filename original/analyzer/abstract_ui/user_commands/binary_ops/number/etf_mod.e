note
	author: "Ashkan Moatamed"

frozen class
	ETF_MOD

inherit

	ETF_MOD_INTERFACE

create
	make

feature -- command

	mod
		do
			if model.is_complete_expression then
				model.set_report (model.emra.report_complete)
			else
				model.add_mod
			end
			etf_cmd_container.on_change.notify ([Current])
		end

end

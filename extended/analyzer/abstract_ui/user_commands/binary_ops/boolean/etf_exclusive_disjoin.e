note
	author: "Ashkan Moatamed"

frozen class
	ETF_EXCLUSIVE_DISJOIN

inherit

	ETF_EXCLUSIVE_DISJOIN_INTERFACE

create
	make

feature -- command

	exclusive_disjoin -- XOR
		do
			if model.is_complete_expression then
				model.set_report (model.emra.report_complete)
			else
				model.add_exclusive_disjunction
			end
			etf_cmd_container.on_change.notify ([Current])
		end

end

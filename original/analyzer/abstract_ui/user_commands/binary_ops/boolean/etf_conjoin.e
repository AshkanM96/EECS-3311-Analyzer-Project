note
	author: "Ashkan Moatamed"

frozen class
	ETF_CONJOIN

inherit

	ETF_CONJOIN_INTERFACE

create
	make

feature -- command

	conjoin -- AND
		do
			if model.is_complete_expression then
				model.set_report (model.emra.report_complete)
			else
				model.add_conjunction
			end
			etf_cmd_container.on_change.notify ([Current])
		end

end

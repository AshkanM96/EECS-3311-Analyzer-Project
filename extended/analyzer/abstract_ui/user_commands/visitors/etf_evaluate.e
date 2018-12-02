note
	author: "Ashkan Moatamed"

frozen class
	ETF_EVALUATE

inherit

	ETF_EVALUATE_INTERFACE

create
	make

feature -- command

	evaluate
		do
			if (not model.is_complete_expression) then
				model.set_report (model.emra.report_incomplete)
			elseif (not model.is_type_correct) then
				model.set_report (model.emra.report_incorrect_evaluation)
			elseif model.division_by_zero then
				if model.mod_by_not_positive then
					model.set_report (model.emra.report_div_by_zero_and_mod_by_not_pos)
				else
					model.set_report (model.emra.report_division_by_zero)
				end
			elseif model.mod_by_not_positive then
				model.set_report (model.emra.report_modulus_not_positive)
			else
				model.set_report (model.evaluate)
			end
			etf_cmd_container.on_change.notify ([Current])
		end

end

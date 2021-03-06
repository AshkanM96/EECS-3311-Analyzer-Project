note
	author: "Ashkan Moatamed"

frozen class
	ETF_PRODUCT

inherit

	ETF_PRODUCT_INTERFACE

create
	make

feature -- command

	product
		do
			if model.is_complete_expression then
				model.set_report (model.emra.report_complete)
			else
				model.add_product
			end
			etf_cmd_container.on_change.notify ([Current])
		end

end

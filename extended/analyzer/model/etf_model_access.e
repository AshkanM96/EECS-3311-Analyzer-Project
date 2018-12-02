note
	description: "Singleton access to the system model."
	author: "Ashkan Moatamed"

frozen expanded class
	ETF_MODEL_ACCESS

feature

	model: ETF_MODEL
		once
			create {ETF_MODEL} Result.make
		end

invariant
	model = model

end

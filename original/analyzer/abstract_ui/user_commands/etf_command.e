note
	description: "The interface for an input COMMAND"
	author: "Ashkan Moatamed"

deferred class
	ETF_COMMAND

inherit

	ETF_COMMAND_INTERFACE
		redefine
			make
		end

feature {NONE} -- Model Attribute

	frozen model: ETF_MODEL

feature {NONE} -- Constructor

	make (an_etf_cmd_name: STRING; etf_cmd_args: TUPLE; an_etf_cmd_container: ETF_ABSTRACT_UI_INTERFACE)
		local
			ema: ETF_MODEL_ACCESS
		do
			Precursor {ETF_COMMAND_INTERFACE} (an_etf_cmd_name, etf_cmd_args, an_etf_cmd_container)
			model := ema.model
		end

end

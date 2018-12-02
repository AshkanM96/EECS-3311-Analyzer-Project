note
	author: "Jackie Wang"

deferred class
	ETF_OPEN_SET_ENUMERATION_INTERFACE

inherit

	ETF_COMMAND
		redefine
			make
		end

feature {NONE} -- Initialization

	frozen make (an_etf_cmd_name: STRING; etf_cmd_args: TUPLE; an_etf_cmd_container: ETF_ABSTRACT_UI_INTERFACE)
		do
			Precursor {ETF_COMMAND} (an_etf_cmd_name, etf_cmd_args, an_etf_cmd_container)
			etf_cmd_routine := agent open_set_enumeration
			etf_cmd_routine.set_operands (etf_cmd_args)
			out := "open_set_enumeration"
				--			if TRUE then
				--				out := "open_set_enumeration"
				--			else
				--				etf_cmd_error := True
				--			end
		end

feature -- command

	open_set_enumeration
		deferred
		end

end

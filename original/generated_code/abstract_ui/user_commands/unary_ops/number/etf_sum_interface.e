note
	author: "Jackie Wang"

deferred class
	ETF_SUM_INTERFACE

inherit

	ETF_COMMAND
		redefine
			make
		end

feature {NONE} -- Initialization

	frozen make (an_etf_cmd_name: STRING; etf_cmd_args: TUPLE; an_etf_cmd_container: ETF_ABSTRACT_UI_INTERFACE)
		do
			Precursor {ETF_COMMAND} (an_etf_cmd_name, etf_cmd_args, an_etf_cmd_container)
			etf_cmd_routine := agent sum
			etf_cmd_routine.set_operands (etf_cmd_args)
			out := "sum"
				--			if TRUE then
				--				out := "sum"
				--			else
				--				etf_cmd_error := True
				--			end
		end

feature -- command

	sum
		deferred
		end

end

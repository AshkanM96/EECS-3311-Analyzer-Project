note
	author: "Jackie Wang"

deferred class
	ETF_INTEGER_CONSTANT_INTERFACE

inherit

	ETF_COMMAND
		redefine
			make
		end

feature {NONE} -- Initialization

	frozen make (an_etf_cmd_name: STRING; etf_cmd_args: TUPLE; an_etf_cmd_container: ETF_ABSTRACT_UI_INTERFACE)
		do
			Precursor {ETF_COMMAND} (an_etf_cmd_name, etf_cmd_args, an_etf_cmd_container)
			etf_cmd_routine := agent integer_constant(?)
			etf_cmd_routine.set_operands (etf_cmd_args)
			if (attached {INTEGER_64} etf_cmd_args [1] as c) then
				out := "integer_constant(" + etf_event_argument_out ("integer_constant", "c", c) + ")"
			else
				etf_cmd_error := True
			end
		end

feature -- command

	integer_constant (c: INTEGER_64)
		deferred
		end

end

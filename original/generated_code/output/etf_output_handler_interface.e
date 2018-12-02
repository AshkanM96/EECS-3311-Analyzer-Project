note
	description: "Output handler for triggered events via an observer."
	author: "Jackie Wang"

deferred class
	ETF_OUTPUT_HANDLER_INTERFACE

feature -- Queries

	frozen output, frozen error_message: STRING

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			create {STRING} output.make_empty
			create {STRING} error_message.make_empty
		end

feature -- Log to 'output'

	log_model_state
		deferred
		end

	frozen log_empty (a_cmd: ETF_COMMAND)
		do
			output := output
		end

	log_command (a_cmd: ETF_COMMAND)
			-- Log the normal effect of 'a_cmd' to 'output'
		local
			l_command_name: STRING
		do
			l_command_name := "->" + a_cmd.out + "%N"
			if (a_cmd.etf_cmd_message.count = 0) then
				output.append (l_command_name)
					-- 'output' may also be accumulated with the model state
			else
				output.append (l_command_name + "  Error: " + a_cmd.etf_cmd_message)
			end
		end

	frozen log_error (a_error: STRING)
			-- Log 'a_error' to 'error_message'
		do
			error_message := a_error
		end

end

note
	description: "Operate abstract user interface"
	author: "Jackie Wang"

deferred class
	ETF_SOFTWARE_OPERATION_INTERFACE

feature -- Attributes

	frozen ui: ETF_ABSTRACT_UI

	frozen input: ETF_INPUT_HANDLER

	frozen output: ETF_CMD_LINE_OUTPUT_HANDLER

	frozen dummy_command: STRING = ""

	frozen error: BOOLEAN

feature {NONE} -- Constructors

	frozen make
			-- initialize input, output, ui
		do
			initialize_attributes
		end

	frozen initialize_attributes
			-- initialize attributes
			-- and attach output handlers
		do
			create {ETF_CMD_LINE_OUTPUT_HANDLER} output.make
				-- create user interface and attach command output handlers
			create {ETF_ABSTRACT_UI} ui.make -- user interface
				-- create empty default input handler
			create {ETF_INPUT_HANDLER} input.make_without_running (dummy_command, ui)
		end

feature -- Commands

	frozen execute (cmds: STRING; is_init: BOOLEAN)
			-- Parse input string `cmds' as a list of commands
			-- If no input errors,
			-- 		then execute commands and log to 'output'
			-- 		note. when 'is_init', log the initial state
			-- If errors,
			-- 		then report errors to 'output'
		do
			initialize_attributes

				-- attach output handler log
			ui.on_change.attach (agent output.log_command)

				-- create an input parser and attach error output handler
			create {ETF_INPUT_HANDLER} input.make_without_running (cmds, ui)
			input.on_error.attach (agent output.log_error)

				-- parse and validate input
			input.parse_and_validate_input_string
			if (not input.etf_error) then
				if is_init then
					output.log_model_state
				end
				ui.run_input_commands
			else
				error := input.etf_error
			end
		end

	frozen execute_without_log (cmds: STRING)
			-- Parse input string `cmds' as a list of commands
			-- If no input errors,
			-- 		then execute commands without writing to a log
			-- If errors,
			-- 		then report errors to 'output'
		do
			initialize_attributes

				-- attach output handler log
			ui.on_change.attach (agent output.log_empty)

				-- create an input parser and attach error output handler
			create {ETF_INPUT_HANDLER} input.make_without_running (cmds, ui)
			input.on_error.attach (agent output.log_error)

				-- parse and validate input
			input.parse_and_validate_input_string
			if (not input.etf_error) then
				ui.run_input_commands
			else
				error := input.etf_error
			end
		end

end

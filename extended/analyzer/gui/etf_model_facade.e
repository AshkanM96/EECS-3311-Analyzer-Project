note
	description: "A facade class for easy manipulation of the model objects."
	author: "Jackie Wang"

frozen class
	ETF_MODEL_FACADE

create
	make

feature -- Public Attributes

	model: ETF_MODEL

	error: BOOLEAN

	status_message, output_message: STRING

	history: LIST [STRING]
			-- Return the trace of events executed so far.

feature {NONE} -- Private Attributes

	sys: ETF_SOFTWARE_OPERATION

	input: ETF_INPUT_HANDLER

	output: ETF_GUI_OUTPUT_HANDLER

	ui: ETF_ABSTRACT_UI

feature -- Constructor

	make
			-- Initialize.
		local
			model_access: ETF_MODEL_ACCESS
		do
			model := model_access.model

				-- 'ETF_SOFTWARE_OPERATION'
			create {ETF_SOFTWARE_OPERATION} sys.make

				-- 'ETF_ABSTRACT_UI'
			create {ETF_ABSTRACT_UI} ui.make
				-- 'ETF_INPUT_HANDLER'
			create {ETF_INPUT_HANDLER} input.make_without_running ("dummy", ui)
				-- 'ETF_GUI_OUTPUT_HANDLER'
			create {ETF_GUI_OUTPUT_HANDLER} output.make
			if (not output.model.is_new_expression) then
				output.model.reset
			end
			input.on_error.attach (agent output.log_error)

				-- history
			create {LINKED_LIST [STRING]} history.make
			error := FALSE

				-- messages
			create {STRING} status_message.make_from_string (man_page)
			create {STRING} output_message.make_empty
		end

feature -- Reset

	reset
		do
			make
		end

feature -- Execute Command Function

	execute_cmd (cmd: STRING)
			-- Execute 'cmd'.
			-- Set 'error_message' or 'output_message', but not both.
		do
			if (cmd ~ "man") then
				error := FALSE
				create {STRING} status_message.make_from_string (man_page)
				create {STRING} output_message.make_empty
			else
				create {ETF_INPUT_HANDLER} input.make_without_running (cmd, ui)
				input.on_error.attach (agent output.log_error)
				input.parse_and_validate_input_string
				if input.etf_error then
					error := TRUE
					create {STRING} status_message.make_from_string (output.error_message)
					status_message.prepend ("Command entered: " + cmd + "%N")
						-- 'output_message' is retained
				else
					history.extend (cmd)
					sys.execute_without_log (cmd)
					error := FALSE
					create {STRING} status_message.make_empty
					create {STRING} output_message.make_from_string (output.model_state)
				end
			end
		end

feature -- Man Page

	man_page: STRING = "[
			type_check
			evaluate
			reset
			boolean_constant(c: BOOLEAN), bool(c: BOOLEAN)
			integer_constant(c: INTEGER_64), int(c: INTEGER_64)
			empty_set_constant, empty_set
			add
			subtract
			multiply
			divide
			mod
			conjoin, and
			disjoin, or
			exclusive_disjoin, xor
			imply
			equals
			less_than_or_equal, le
			less_than, lt
			greater_than, gt
			greater_than_or_equal, ge
			union
			intersect
			difference
			subset_equal
			subset_proper
			superset_equal
			superset_proper
			negative
			negation, not
			sum
			product
			count
			for_all, all
			there_exists, exists
			open_set_enumeration, open_set
			close_set_enumeration, close_set
		]"

		-- invariant
		--	 err_msg_set: error implies (not status_message.is_empty)

end

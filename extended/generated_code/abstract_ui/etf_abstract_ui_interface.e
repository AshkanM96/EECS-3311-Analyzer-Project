note
	description: "Abstract user interface"
	author: "Jackie Wang"

deferred class
	ETF_ABSTRACT_UI_INTERFACE

feature -- Attributes

	frozen commands: ARRAY [ETF_COMMAND_INTERFACE]

	frozen on_change: ETF_EVENT [TUPLE [ETF_COMMAND_INTERFACE]]

feature {NONE} -- Constructor

	frozen make
		do
			create {ARRAY [ETF_COMMAND_INTERFACE]} commands.make_empty
			create {ETF_EVENT [TUPLE [ETF_COMMAND_INTERFACE]]} on_change.default_create
		end

feature -- Insert Command

	frozen put (a_command: ETF_COMMAND_INTERFACE)
		do
			commands.force (a_command, commands.count + 1)
				--		ensure
				--			commands.count = (old commands.count) + 1
				--			commands [commands.count] = a_command
		end

feature -- Execute Command

	frozen run_input_commands
			-- execute each command in `commands'
		do
			across
				commands as cmd
			loop
				cmd.item.etf_cmd_routine.apply
			end
		end

end

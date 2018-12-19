note
	description: "Central control for running an ETF project."
	author: "Jackie Wang"

frozen class
	ROOT

inherit

	ES_SUITE

	ETF_CMD_LINE_ROOT_INTERFACE
		rename
			make as make_from_cl_root
		end

	EXCEPTIONS

create
	make

feature -- Constants

	unit_test: INTEGER = 1

		-- GUI Modes

	etf_gui_show_history: INTEGER = 2

	etf_gui_hide_history: INTEGER = 3

		-- Command Line Modes

	etf_cl_show_history: INTEGER = 4
			-- show history if '-g' option is specified

	etf_cl_hide_history: INTEGER = 5
			-- hide history if '-g' option is specified

feature -- Mode Attribute

	switch: INTEGER
			-- Running mode of ETF application.
		do
			Result := etf_cl_show_history
		end

feature -- Constructor

	make
			-- Initialize ETF application.
		local
			operating_signal: BOOLEAN
		do
			initialize_attributes
			if operating_signal then
					-- quit and do nothing else
			else
				if (switch = etf_gui_show_history) or else (switch = etf_cl_show_history) then
					show_history
				elseif (switch = etf_gui_hide_history) or else (switch = etf_cl_hide_history) then
					hide_history
				else
						-- do nothing
				end
				inspect switch
				when unit_test then
					if (argument_count = 0) then
						add_tests
						show_browser
						run_espec
					else
						io.put_string ("Error: current mode is ESpec test (no command line arguments).")
					end
				when etf_gui_show_history, etf_gui_hide_history then
					if (argument_count = 0) then
						make_from_gui_root
					else
						io.put_string ("Error: current mode is ETF GUI (no command line arguments).")
					end
				when etf_cl_show_history, etf_cl_hide_history then
					make_from_cl_root
				else
						-- invalid switch
					check
						FALSE
					end
				end
			end
		rescue
			if is_signal and then (attached meaning (exception) as s) then
				print ("%N" + s + "%NQuit...%N")
				operating_signal := True
				retry
			end
		end

feature -- Test(s)

	add_tests
			-- add test classes to be run in unit_test mode
		require
			unit_test_mode: switch = unit_test
		do
				-- add your tests here
				-- add cluster for tests
				-- add_test (create {MY_TEST}.make)
		end

invariant
	different_switch_constants: (unit_test /= etf_gui_show_history) and then (unit_test /= etf_gui_hide_history) and then (unit_test /= etf_cl_show_history) and then (unit_test /= etf_cl_hide_history) and then (etf_gui_show_history /= etf_gui_hide_history) and then (etf_gui_show_history /= etf_cl_show_history) and then (etf_gui_show_history /= etf_cl_hide_history) and then (etf_gui_hide_history /= etf_cl_show_history) and then (etf_gui_hide_history /= etf_cl_hide_history) and then (etf_cl_show_history /= etf_cl_hide_history)
	correct_switch: (switch = unit_test) or else (switch = etf_gui_show_history) or else (switch = etf_gui_hide_history) or else (switch = etf_cl_show_history) or else (switch = etf_cl_hide_history)

end

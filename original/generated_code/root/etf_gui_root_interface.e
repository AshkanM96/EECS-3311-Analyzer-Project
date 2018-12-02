note
	description: "Summary description for {ROOT}."
	author: "Jackie Wang"

deferred class
	ETF_GUI_ROOT_INTERFACE

feature {NONE} -- Attributes

	frozen gui: detachable ETF_GUI

	frozen is_history_shown: BOOLEAN

feature {NONE} -- Initialization

	frozen make
			-- Initialization for `Current'.
		do
			create {ETF_GUI} gui.default_create
			check (attached gui as g) then
				if is_history_shown then
					g.main_window.history.show
				else
					g.main_window.history.hide
				end
				g.launch
			end
		end

feature -- History Commands

	frozen show_history
			-- When the GUI is launched, show the history panel
			-- which displays the trace of events.
		do
			is_history_shown := TRUE
		end

	frozen hide_history
			-- When the GUI is launch, do not show the history panel.
		do
			is_history_shown := FALSE
		end

end

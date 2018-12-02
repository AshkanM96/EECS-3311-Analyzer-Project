note
	description: "Objects that represent an EV_TITLED_WINDOW."
	generator: "EiffelBuild"
	date: "$Date: 2014-01-22 11:12:21 -0800 (Wed, 22 Jan 2014) $"
	revision: "$Revision: 94077 $"

deferred class
	ETF_MAIN_WINDOW_IMP

inherit

	EV_TITLED_WINDOW
		redefine
			create_interface_objects,
			initialize,
			is_in_default_state
		end

feature -- Access

	frozen hbox_main, frozen hbox_buttons: EV_HORIZONTAL_BOX

	frozen cell: EV_CELL

	frozen vbox: EV_VERTICAL_BOX

	frozen command_label, frozen status_label: EV_LABEL

	frozen command: EV_TEXT_FIELD

	frozen execute, frozen reset, frozen load: EV_BUTTON

	frozen output, frozen status, frozen history: EV_RICH_TEXT

feature {NONE} -- Implementation

	frozen l_ev_horizontal_separator_1: EV_HORIZONTAL_SEPARATOR

feature {NONE} -- Initialization

	frozen initialize
			-- Initialize `Current'.
		do
			Precursor {EV_TITLED_WINDOW}

				-- Build widget structure.
			extend (hbox_main)
			hbox_main.extend (cell)
			cell.extend (vbox)
			vbox.extend (command_label)
			vbox.extend (command)
			vbox.extend (hbox_buttons)
			hbox_buttons.extend (execute)
			hbox_buttons.extend (reset)
			hbox_buttons.extend (load)
			vbox.extend (output)
			vbox.extend (l_ev_horizontal_separator_1)
			vbox.extend (status_label)
			vbox.extend (status)
			hbox_main.extend (history)
			hbox_main.enable_homogeneous
			vbox.disable_item_expand (command_label)
			vbox.disable_item_expand (command)
			vbox.disable_item_expand (hbox_buttons)
			vbox.disable_item_expand (l_ev_horizontal_separator_1)
			vbox.disable_item_expand (status_label)
			command_label.set_text ("Enter Command (%"man%" for options)")
			hbox_buttons.enable_homogeneous
				-- execute.set_background_color (create {EV_COLOR}.make_with_8_bit_rgb (0, 0, 0))
				-- execute.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (255, 255, 255))
			execute.set_text ("Execute")
				-- reset.set_background_color (create {EV_COLOR}.make_with_8_bit_rgb (0, 0, 0))
				-- reset.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (255, 255, 255))
			reset.set_text ("Reset")
				-- load.set_background_color (create {EV_COLOR}.make_with_8_bit_rgb (0, 0, 0))
				-- load.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (255, 255, 255))
			load.set_text ("Load")
			output.disable_edit
			status_label.set_background_color (create {EV_COLOR}.make_with_8_bit_rgb (0, 0, 0))
			status_label.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (255, 255, 255))
			status_label.set_text ("Status")
			status_label.align_text_left
			status.disable_edit
			history.set_minimum_width (200)
			history.set_minimum_height (100)
			history.disable_edit
			set_minimum_width (700)
			set_minimum_height (500)
			set_title ("System ETF_Template GUI")
			set_all_attributes_using_constants

				-- Connect events.
			command.return_actions.extend (agent command_return_key_pressed)
			execute.select_actions.extend (agent execute_pressed)
			reset.select_actions.extend (agent reset_pressed)
			load.select_actions.extend (agent load_pressed)
				-- Close the application when an interface close
				-- request is received on `Current'. i.e. the cross is clicked.
			close_request_actions.extend (agent destroy_and_exit_if_last)

				-- Call `user_initialization'.
			user_initialization
		end

	frozen create_interface_objects
			-- Create all widgets.
		do
				-- 'EV_HORIZONTAL_BOX'
			create {EV_HORIZONTAL_BOX} hbox_main
			create {EV_HORIZONTAL_BOX} hbox_buttons

				-- 'EV_CELL'
			create {EV_CELL} cell

				-- 'EV_VERTICAL_BOX'
			create {EV_VERTICAL_BOX} vbox

				-- 'EV_LABEL'
			create {EV_LABEL} command_label
			create {EV_LABEL} status_label

				-- 'EV_TEXT_FIELD'
			create {EV_TEXT_FIELD} command

				-- 'EV_BUTTON'
			create {EV_BUTTON} execute
			create {EV_BUTTON} reset
			create {EV_BUTTON} load

				-- 'EV_RICH_TEXT'
			create {EV_RICH_TEXT} output
			create {EV_RICH_TEXT} status
			create {EV_RICH_TEXT} history

				-- 'EV_HORIZONTAL_SEPARATOR'
			create {EV_HORIZONTAL_SEPARATOR} l_ev_horizontal_separator_1

				-- 'ARRAYED_LIST [PROCEDURE [READABLE_STRING_GENERAL]]'
			create {ARRAYED_LIST [PROCEDURE [READABLE_STRING_GENERAL]]} string_constant_set_procedures.make (10)
				-- 'ARRAYED_LIST [FUNCTION [STRING_32]]'
			create {ARRAYED_LIST [FUNCTION [STRING_32]]} string_constant_retrieval_functions.make (10)

				-- 'ARRAYED_LIST [PROCEDURE [INTEGER]]'
			create {ARRAYED_LIST [PROCEDURE [INTEGER]]} integer_constant_set_procedures.make (10)
				-- 'ARRAYED_LIST [FUNCTION [INTEGER]]'
			create {ARRAYED_LIST [FUNCTION [INTEGER]]} integer_constant_retrieval_functions.make (10)

				-- 'ARRAYED_LIST [PROCEDURE [EV_PIXMAP]]'
			create {ARRAYED_LIST [PROCEDURE [EV_PIXMAP]]} pixmap_constant_set_procedures.make (10)
				-- 'ARRAYED_LIST [FUNCTION [EV_PIXMAP]]'
			create {ARRAYED_LIST [FUNCTION [EV_PIXMAP]]} pixmap_constant_retrieval_functions.make (10)

				-- 'ARRAYED_LIST [PROCEDURE [INTEGER_INTERVAL]]'
			create {ARRAYED_LIST [PROCEDURE [INTEGER_INTERVAL]]} integer_interval_constant_set_procedures.make (10)
				-- 'ARRAYED_LIST [FUNCTION [INTEGER]]'
			create {ARRAYED_LIST [FUNCTION [INTEGER]]} integer_interval_constant_retrieval_functions.make (10)

				-- 'ARRAYED_LIST [PROCEDURE [EV_FONT]]'
			create {ARRAYED_LIST [PROCEDURE [EV_FONT]]} font_constant_set_procedures.make (10)
				-- 'ARRAYED_LIST [FUNCTION [EV_FONT]]'
			create {ARRAYED_LIST [FUNCTION [EV_FONT]]} font_constant_retrieval_functions.make (10)

				-- 'ARRAYED_LIST [PROCEDURE [EV_COLOR]]'
			create {ARRAYED_LIST [PROCEDURE [EV_COLOR]]} color_constant_set_procedures.make (10)
				-- 'ARRAYED_LIST [FUNCTION [EV_COLOR]]'
			create {ARRAYED_LIST [FUNCTION [EV_COLOR]]} color_constant_retrieval_functions.make (10)

				-- interface objects
			user_create_interface_objects
		end

feature {NONE} -- Constant Setting

	frozen set_attributes_using_string_constants
			-- Set all attributes relying on string constants to the current
			-- value of the associated constant.
		local
			s: detachable STRING_32
		do
			from
				string_constant_set_procedures.start
			until
				string_constant_set_procedures.off
			loop
				string_constant_retrieval_functions.i_th (string_constant_set_procedures.index).call (Void)
				s := string_constant_retrieval_functions.i_th (string_constant_set_procedures.index).last_result
				if (s /= Void) then
					string_constant_set_procedures.item.call ([s])
				end
				string_constant_set_procedures.forth
			end
		end

	frozen set_attributes_using_integer_constants
			-- Set all attributes relying on integer constants to the current
			-- value of the associated constant.
		local
			i: INTEGER
			arg1, arg2: INTEGER
			int: INTEGER_INTERVAL
		do
			from
				integer_constant_set_procedures.start
			until
				integer_constant_set_procedures.off
			loop
				integer_constant_retrieval_functions.i_th (integer_constant_set_procedures.index).call (Void)
				i := integer_constant_retrieval_functions.i_th (integer_constant_set_procedures.index).last_result
				integer_constant_set_procedures.item.call ([i])
				integer_constant_set_procedures.forth
			end
			from
				integer_interval_constant_retrieval_functions.start
				integer_interval_constant_set_procedures.start
			until
				integer_interval_constant_retrieval_functions.off
			loop
				integer_interval_constant_retrieval_functions.item.call (Void)
				arg1 := integer_interval_constant_retrieval_functions.item.last_result
				integer_interval_constant_retrieval_functions.forth
				integer_interval_constant_retrieval_functions.item.call (Void)
				arg2 := integer_interval_constant_retrieval_functions.item.last_result
				create {INTEGER_INTERVAL} int.make (arg1, arg2)
				integer_interval_constant_set_procedures.item.call ([int])
				integer_interval_constant_retrieval_functions.forth
				integer_interval_constant_set_procedures.forth
			end
		end

	frozen set_attributes_using_pixmap_constants
			-- Set all attributes relying on pixmap constants to the current
			-- value of the associated constant.
		local
			p: detachable EV_PIXMAP
		do
			from
				pixmap_constant_set_procedures.start
			until
				pixmap_constant_set_procedures.off
			loop
				pixmap_constant_retrieval_functions.i_th (pixmap_constant_set_procedures.index).call (Void)
				p := pixmap_constant_retrieval_functions.i_th (pixmap_constant_set_procedures.index).last_result
				if (p /= Void) then
					pixmap_constant_set_procedures.item.call ([p])
				end
				pixmap_constant_set_procedures.forth
			end
		end

	frozen set_attributes_using_font_constants
			-- Set all attributes relying on font constants to the current
			-- value of the associated constant.
		local
			f: detachable EV_FONT
		do
			from
				font_constant_set_procedures.start
			until
				font_constant_set_procedures.off
			loop
				font_constant_retrieval_functions.i_th (font_constant_set_procedures.index).call (Void)
				f := font_constant_retrieval_functions.i_th (font_constant_set_procedures.index).last_result
				if (f /= Void) then
					font_constant_set_procedures.item.call ([f])
				end
				font_constant_set_procedures.forth
			end
		end

	frozen set_attributes_using_color_constants
			-- Set all attributes relying on color constants to the current
			-- value of the associated constant.
		local
			c: detachable EV_COLOR
		do
			from
				color_constant_set_procedures.start
			until
				color_constant_set_procedures.off
			loop
				color_constant_retrieval_functions.i_th (color_constant_set_procedures.index).call (Void)
				c := color_constant_retrieval_functions.i_th (color_constant_set_procedures.index).last_result
				if (c /= Void) then
					color_constant_set_procedures.item.call ([c])
				end
				color_constant_set_procedures.forth
			end
		end

	frozen set_all_attributes_using_constants
			-- Set all attributes relying on constants to the current
			-- calue of the associated constant.
		do
			set_attributes_using_string_constants
			set_attributes_using_integer_constants
			set_attributes_using_pixmap_constants
			set_attributes_using_font_constants
			set_attributes_using_color_constants
		end

	frozen string_constant_set_procedures: ARRAYED_LIST [PROCEDURE [READABLE_STRING_GENERAL]]

	frozen string_constant_retrieval_functions: ARRAYED_LIST [FUNCTION [STRING_32]]

	frozen integer_constant_set_procedures: ARRAYED_LIST [PROCEDURE [INTEGER]]

	frozen integer_constant_retrieval_functions: ARRAYED_LIST [FUNCTION [INTEGER]]

	frozen pixmap_constant_set_procedures: ARRAYED_LIST [PROCEDURE [EV_PIXMAP]]

	frozen pixmap_constant_retrieval_functions: ARRAYED_LIST [FUNCTION [EV_PIXMAP]]

	frozen integer_interval_constant_retrieval_functions: ARRAYED_LIST [FUNCTION [INTEGER]]

	frozen integer_interval_constant_set_procedures: ARRAYED_LIST [PROCEDURE [INTEGER_INTERVAL]]

	frozen font_constant_set_procedures: ARRAYED_LIST [PROCEDURE [EV_FONT]]

	frozen font_constant_retrieval_functions: ARRAYED_LIST [FUNCTION [EV_FONT]]

	frozen color_constant_set_procedures: ARRAYED_LIST [PROCEDURE [EV_COLOR]]

	frozen color_constant_retrieval_functions: ARRAYED_LIST [FUNCTION [EV_COLOR]]

	frozen integer_from_integer (an_integer: INTEGER): INTEGER
			-- Return `an_integer', used for creation of
			-- an agent that returns a fixed integer value.
		do
			Result := an_integer
		end

feature {NONE} -- Implementation

	frozen is_in_default_state: BOOLEAN = True
			-- Is `Current' in its default state?

	user_create_interface_objects
			-- Feature for custom user interface object creation, called at end of `create_interface_objects'.
		deferred
		end

	user_initialization
			-- Feature for custom initialization, called at end of `initialize'.
		deferred
		end

	command_return_key_pressed
			-- Called by `return_actions' of `command'.
		deferred
		end

	execute_pressed
			-- Called by `select_actions' of `execute'.
		deferred
		end

	reset_pressed
			-- Called by `select_actions' of `reset'.
		deferred
		end

	load_pressed
			-- Called by `select_actions' of `load'.
		deferred
		end

end

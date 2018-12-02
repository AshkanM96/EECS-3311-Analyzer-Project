note
	description: "The internal model of the analyzer."
	author: "Ashkan Moatamed"

frozen class
	ETF_MODEL

inherit

	ANY
		redefine
			out
		end

create {ETF_MODEL_ACCESS}
	make

feature -- Report Singleton Accessor

	emra: ETF_MODEL_REPORT_ACCESS

feature {NONE} -- Report String Attribute

	report: IMMUTABLE_STRING_8

feature -- Report String Query and Command

	is_valid_report (s: IMMUTABLE_STRING_8): BOOLEAN
		require
			argument_not_void: s /= Void
			not_print_changed: not is_print_changed
		do
			Result := emra.is_valid_report (s)

				-- only check for type (in)correct status messages if Result is currently False and the type_check result is known
			if ((not Result) and then (not is_type_check_changed)) then
				Result := (s ~ type_check)
			end

				-- only check for evaluation result if Result is currently False and the evaluation result is known
			if ((not Result) and then (not is_evaluate_changed)) then
				Result := (s ~ evaluator_value)
			end
		end

	set_report (s: IMMUTABLE_STRING_8)
		require
			valid_report: is_valid_report (s)
		do
			report := s
		ensure
			correct_report: report = s
		end

feature {NONE} -- Constant Expression Singleton Accessor

	cea: CONST_EXPR_ACCESS

feature {NONE} -- Expression Tree Attribute

	expr_tree: EXPRESSION_TREE

feature -- Expression Tree Status Queries

	is_new_expression: BOOLEAN
		do
			Result := expr_tree.is_new_tree
		ensure
			correct_result: Result = expr_tree.is_new_tree
		end

	is_complete_expression: BOOLEAN
		do
			Result := (not expr_tree.is_open)
		ensure
			correct_result: Result = (not expr_tree.is_open)
		end

	specifying_set_enum: BOOLEAN
		do
			Result := expr_tree.specifying_set_enum
		ensure
			correct_result: Result = expr_tree.specifying_set_enum
		end

	is_open_set_enum: BOOLEAN
		require
			specifying_set_enum: specifying_set_enum
		do
			Result := expr_tree.is_open_set_enum
		ensure
			correct_result: Result = expr_tree.is_open_set_enum
		end

	is_empty_set_enum: BOOLEAN
		require
			specifying_set_enum: specifying_set_enum
		do
			Result := expr_tree.is_empty_set_enum
		ensure
			correct_result: Result = expr_tree.is_empty_set_enum
		end

feature -- Visitation Boolean Flags

	is_print_changed, is_type_check_changed, is_evaluate_changed: BOOLEAN

	division_by_zero, mod_by_not_positive: BOOLEAN

feature {NONE} -- Visitor Pattern Attributes

	type_correct: BOOLEAN

	printer_value, evaluator_value: IMMUTABLE_STRING_8

feature -- Type Checker Queries

	is_type_correct: BOOLEAN
		require
			complete_expression: is_complete_expression
		local
			type_checker: TYPE_CHECKER
		do
			if is_type_check_changed then
				create {TYPE_CHECKER} type_checker.default_create
				expr_tree.visit (type_checker)
				is_type_check_changed := False

					-- set type check flags
				type_correct := type_checker.is_type_correct
				division_by_zero := type_checker.division_by_zero
				mod_by_not_positive := type_checker.mod_by_not_positive

					-- check if expression has already been evaluated during type checking
				if (not type_checker.value.is_empty) then

						-- set evaluation flags
					is_evaluate_changed := False
					evaluator_value := type_checker.value
				end
			end

				-- set 'Result'
			Result := type_correct
		ensure
			not_type_check_changed: not is_type_check_changed
			correct_result: Result = type_correct
		end

	type_check: IMMUTABLE_STRING_8
		require
			complete_expression: is_complete_expression
			not_print_changed: not is_print_changed
		do
			if is_type_correct then
				Result := printer_value + emra.report_type_correct
			else
				Result := printer_value + emra.report_not_type_correct
			end
		ensure
			not_type_check_changed: not is_type_check_changed
			type_correct: is_type_correct implies (Result ~ (printer_value + emra.report_type_correct))
			not_type_correct: (not is_type_correct) implies (Result ~ (printer_value + emra.report_not_type_correct))
		end

feature -- Evaluation Query

	evaluate: IMMUTABLE_STRING_8
		require
			complete_expression: is_complete_expression
			type_correct: is_type_correct
			not_division_by_zero: not division_by_zero
			not_mod_by_not_positive: not mod_by_not_positive
		local
			evaluator: EVALUATOR
		do
			if is_evaluate_changed then
				create {EVALUATOR} evaluator.default_create
				expr_tree.visit (evaluator)

					-- set evaluation flags
				is_evaluate_changed := False
				evaluator_value := evaluator.value
			end

				-- set 'Result'
			Result := evaluator_value
		ensure
			not_evaluate_changed: not is_evaluate_changed
			correct_result: Result ~ evaluator_value
		end

feature {ETF_MODEL_ACCESS} -- Constructor

	make
			-- Initialization for `Current'.
		do
				-- Initialize Expression Tree Attribute
			create {EXPRESSION_TREE} expr_tree.make

				-- Initialize Visitor Pattern Attributes

				-- 'PRINTER'
			printer_value := ""
			is_print_changed := True

				-- 'TYPE_CHECKER'
			type_correct := False
			is_type_check_changed := True
			division_by_zero := False
			mod_by_not_positive := False

				-- 'EVALUATOR'
			evaluator_value := ""
			is_evaluate_changed := True

				-- Initialize Report String Attribute
			report := emra.report_initialized
		ensure
			new_expression: is_new_expression
			incomplete_expression: not is_complete_expression
			empty_printer_value: printer_value.is_empty
			print_changed: is_print_changed
			not_type_correct: not type_correct
			type_check_changed: is_type_check_changed
			not_division_by_zero: not division_by_zero
			not_mod_by_not_positive: not mod_by_not_positive
			empty_evaluator_value: evaluator_value.is_empty
			evaluate_changed: is_evaluate_changed
			correct_report: report = emra.report_initialized
		end

feature -- Reset

	reset
		require
			not_new_expression: not is_new_expression
		do
			make
			report := emra.report_ok
		ensure
			new_expression: is_new_expression
			correct_report: report = emra.report_ok
		end

feature -- Adding Constant Expressions

	add_boolean_constant (b: BOOLEAN)
		require
			incomplete_expression: not is_complete_expression
		do
			add (cea.bool (b))
		ensure
			not_new_expression: not is_new_expression
			print_changed: is_print_changed
			type_check_changed: is_type_check_changed
			evaluate_changed: is_evaluate_changed
			correct_report: report = emra.report_ok
		end

	add_integer_constant (i: INTEGER_64)
		require
			incomplete_expression: not is_complete_expression
		do
			add (create {INTEGER_CONSTANT}.make (i))
		ensure
			not_new_expression: not is_new_expression
			print_changed: is_print_changed
			type_check_changed: is_type_check_changed
			evaluate_changed: is_evaluate_changed
			correct_report: report = emra.report_ok
		end

	add_empty_set_constant -- {}
		require
			incomplete_expression: not is_complete_expression
		do
			add (cea.empty_set)
		ensure
			not_new_expression: not is_new_expression
			print_changed: is_print_changed
			type_check_changed: is_type_check_changed
			evaluate_changed: is_evaluate_changed
			correct_report: report = emra.report_ok
		end

feature -- Adding Binary Op. Expressions

	add_equality
		require
			incomplete_expression: not is_complete_expression
		do
			add (create {EQUALITY}.default_create)
		ensure
			not_new_expression: not is_new_expression
			print_changed: is_print_changed
			type_check_changed: is_type_check_changed
			evaluate_changed: is_evaluate_changed
			correct_report: report = emra.report_ok
		end

		-- Boolean

	add_conjunction -- AND
		require
			incomplete_expression: not is_complete_expression
		do
			add (create {CONJUNCTION}.default_create)
		ensure
			not_new_expression: not is_new_expression
			print_changed: is_print_changed
			type_check_changed: is_type_check_changed
			evaluate_changed: is_evaluate_changed
			correct_report: report = emra.report_ok
		end

	add_disjunction -- OR
		require
			incomplete_expression: not is_complete_expression
		do
			add (create {DISJUNCTION}.default_create)
		ensure
			not_new_expression: not is_new_expression
			print_changed: is_print_changed
			type_check_changed: is_type_check_changed
			evaluate_changed: is_evaluate_changed
			correct_report: report = emra.report_ok
		end

	add_exclusive_disjunction -- XOR
		require
			incomplete_expression: not is_complete_expression
		do
			add (create {EXCLUSIVE_DISJUNCTION}.default_create)
		ensure
			not_new_expression: not is_new_expression
			print_changed: is_print_changed
			type_check_changed: is_type_check_changed
			evaluate_changed: is_evaluate_changed
			correct_report: report = emra.report_ok
		end

	add_implication
		require
			incomplete_expression: not is_complete_expression
		do
			add (create {IMPLICATION}.default_create)
		ensure
			not_new_expression: not is_new_expression
			print_changed: is_print_changed
			type_check_changed: is_type_check_changed
			evaluate_changed: is_evaluate_changed
			correct_report: report = emra.report_ok
		end

		-- Number

	add_addition
		require
			incomplete_expression: not is_complete_expression
		do
			add (create {ADDITION}.default_create)
		ensure
			not_new_expression: not is_new_expression
			print_changed: is_print_changed
			type_check_changed: is_type_check_changed
			evaluate_changed: is_evaluate_changed
			correct_report: report = emra.report_ok
		end

	add_subtraction
		require
			incomplete_expression: not is_complete_expression
		do
			add (create {SUBTRACTION}.default_create)
		ensure
			not_new_expression: not is_new_expression
			print_changed: is_print_changed
			type_check_changed: is_type_check_changed
			evaluate_changed: is_evaluate_changed
			correct_report: report = emra.report_ok
		end

	add_multiplication
		require
			incomplete_expression: not is_complete_expression
		do
			add (create {MULTIPLICATION}.default_create)
		ensure
			not_new_expression: not is_new_expression
			print_changed: is_print_changed
			type_check_changed: is_type_check_changed
			evaluate_changed: is_evaluate_changed
			correct_report: report = emra.report_ok
		end

	add_division
		require
			incomplete_expression: not is_complete_expression
		do
			add (create {DIVISION}.default_create)
		ensure
			not_new_expression: not is_new_expression
			print_changed: is_print_changed
			type_check_changed: is_type_check_changed
			evaluate_changed: is_evaluate_changed
			correct_report: report = emra.report_ok
		end

	add_mod
		require
			incomplete_expression: not is_complete_expression
		do
			add (create {MOD}.default_create)
		ensure
			not_new_expression: not is_new_expression
			print_changed: is_print_changed
			type_check_changed: is_type_check_changed
			evaluate_changed: is_evaluate_changed
			correct_report: report = emra.report_ok
		end

	add_less_than_or_equal
		require
			incomplete_expression: not is_complete_expression
		do
			add (create {LESS_THAN_OR_EQUAL}.default_create)
		ensure
			not_new_expression: not is_new_expression
			print_changed: is_print_changed
			type_check_changed: is_type_check_changed
			evaluate_changed: is_evaluate_changed
			correct_report: report = emra.report_ok
		end

	add_less_than
		require
			incomplete_expression: not is_complete_expression
		do
			add (create {LESS_THAN}.default_create)
		ensure
			not_new_expression: not is_new_expression
			print_changed: is_print_changed
			type_check_changed: is_type_check_changed
			evaluate_changed: is_evaluate_changed
			correct_report: report = emra.report_ok
		end

	add_greater_than
		require
			incomplete_expression: not is_complete_expression
		do
			add (create {GREATER_THAN}.default_create)
		ensure
			not_new_expression: not is_new_expression
			print_changed: is_print_changed
			type_check_changed: is_type_check_changed
			evaluate_changed: is_evaluate_changed
			correct_report: report = emra.report_ok
		end

	add_greater_than_or_equal
		require
			incomplete_expression: not is_complete_expression
		do
			add (create {GREATER_THAN_OR_EQUAL}.default_create)
		ensure
			not_new_expression: not is_new_expression
			print_changed: is_print_changed
			type_check_changed: is_type_check_changed
			evaluate_changed: is_evaluate_changed
			correct_report: report = emra.report_ok
		end

		-- Set

	add_union
		require
			incomplete_expression: not is_complete_expression
		do
			add (create {UNION}.default_create)
		ensure
			not_new_expression: not is_new_expression
			print_changed: is_print_changed
			type_check_changed: is_type_check_changed
			evaluate_changed: is_evaluate_changed
			correct_report: report = emra.report_ok
		end

	add_intersection
		require
			incomplete_expression: not is_complete_expression
		do
			add (create {INTERSECTION}.default_create)
		ensure
			not_new_expression: not is_new_expression
			print_changed: is_print_changed
			type_check_changed: is_type_check_changed
			evaluate_changed: is_evaluate_changed
			correct_report: report = emra.report_ok
		end

	add_difference
		require
			incomplete_expression: not is_complete_expression
		do
			add (create {DIFFERENCE}.default_create)
		ensure
			not_new_expression: not is_new_expression
			print_changed: is_print_changed
			type_check_changed: is_type_check_changed
			evaluate_changed: is_evaluate_changed
			correct_report: report = emra.report_ok
		end

	add_subset_equal
		require
			incomplete_expression: not is_complete_expression
		do
			add (create {SUBSET_EQUAL}.default_create)
		ensure
			not_new_expression: not is_new_expression
			print_changed: is_print_changed
			type_check_changed: is_type_check_changed
			evaluate_changed: is_evaluate_changed
			correct_report: report = emra.report_ok
		end

	add_subset_proper
		require
			incomplete_expression: not is_complete_expression
		do
			add (create {SUBSET_PROPER}.default_create)
		ensure
			not_new_expression: not is_new_expression
			print_changed: is_print_changed
			type_check_changed: is_type_check_changed
			evaluate_changed: is_evaluate_changed
			correct_report: report = emra.report_ok
		end

	add_superset_equal
		require
			incomplete_expression: not is_complete_expression
		do
			add (create {SUPERSET_EQUAL}.default_create)
		ensure
			not_new_expression: not is_new_expression
			print_changed: is_print_changed
			type_check_changed: is_type_check_changed
			evaluate_changed: is_evaluate_changed
			correct_report: report = emra.report_ok
		end

	add_superset_proper
		require
			incomplete_expression: not is_complete_expression
		do
			add (create {SUPERSET_PROPER}.default_create)
		ensure
			not_new_expression: not is_new_expression
			print_changed: is_print_changed
			type_check_changed: is_type_check_changed
			evaluate_changed: is_evaluate_changed
			correct_report: report = emra.report_ok
		end

feature -- Adding Unary Op. Expressions

		-- Boolean

	add_negation
		require
			incomplete_expression: not is_complete_expression
		do
			add (create {NEGATION}.default_create)
		ensure
			not_new_expression: not is_new_expression
			print_changed: is_print_changed
			type_check_changed: is_type_check_changed
			evaluate_changed: is_evaluate_changed
			correct_report: report = emra.report_ok
		end

	add_count
		require
			incomplete_expression: not is_complete_expression
		do
			add (create {COUNT}.default_create)
		ensure
			not_new_expression: not is_new_expression
			print_changed: is_print_changed
			type_check_changed: is_type_check_changed
			evaluate_changed: is_evaluate_changed
			correct_report: report = emra.report_ok
		end

	add_for_all
		require
			incomplete_expression: not is_complete_expression
		do
			add (create {FOR_ALL}.default_create)
		ensure
			not_new_expression: not is_new_expression
			print_changed: is_print_changed
			type_check_changed: is_type_check_changed
			evaluate_changed: is_evaluate_changed
			correct_report: report = emra.report_ok
		end

	add_there_exists
		require
			incomplete_expression: not is_complete_expression
		do
			add (create {THERE_EXISTS}.default_create)
		ensure
			not_new_expression: not is_new_expression
			print_changed: is_print_changed
			type_check_changed: is_type_check_changed
			evaluate_changed: is_evaluate_changed
			correct_report: report = emra.report_ok
		end

		-- Number

	add_negative
		require
			incomplete_expression: not is_complete_expression
		do
			add (create {NEGATIVE}.default_create)
		ensure
			not_new_expression: not is_new_expression
			print_changed: is_print_changed
			type_check_changed: is_type_check_changed
			evaluate_changed: is_evaluate_changed
			correct_report: report = emra.report_ok
		end

	add_summation
		require
			incomplete_expression: not is_complete_expression
		do
			add (create {SUMMATION}.default_create)
		ensure
			not_new_expression: not is_new_expression
			print_changed: is_print_changed
			type_check_changed: is_type_check_changed
			evaluate_changed: is_evaluate_changed
			correct_report: report = emra.report_ok
		end

	add_product
		require
			incomplete_expression: not is_complete_expression
		do
			add (create {PRODUCT}.default_create)
		ensure
			not_new_expression: not is_new_expression
			print_changed: is_print_changed
			type_check_changed: is_type_check_changed
			evaluate_changed: is_evaluate_changed
			correct_report: report = emra.report_ok
		end

feature -- Adding Composite Expressions

	add_set_enum
		require
			incomplete_expression: not is_complete_expression
		do
			add (create {SET_ENUMERATION}.make_empty)
		ensure
			not_new_expression: not is_new_expression
			print_changed: is_print_changed
			type_check_changed: is_type_check_changed
			evaluate_changed: is_evaluate_changed
			correct_report: report = emra.report_ok
		end

feature {NONE} -- General Adding

	add (e: EXPRESSION)
		require
			valid_argument: (e /= Void) and then (not e.is_null)
			incomplete_expression: not is_complete_expression
		do
			expr_tree.add (e)

				-- Update 'is_print_changed' flag.
			is_print_changed := True
				-- No need to update the other two visitation boolean flags since they are initialized
				-- in the constructor and the (in)complete_expression preconditions prevent any overlap.

				-- set 'report'
			report := emra.report_ok
		ensure
			not_new_expression: not is_new_expression
			print_changed: is_print_changed
			type_check_changed: is_type_check_changed
			evaluate_changed: is_evaluate_changed
			correct_report: report = emra.report_ok
		end

feature -- Set Closure Command

	close_set_enum
		require
			incomplete_expression: not is_complete_expression
			specifying_set_enum: specifying_set_enum
			not_empty_set_enum: not is_empty_set_enum
		do
			expr_tree.close_set_enum

				-- Update 'is_print_changed' flag.
			is_print_changed := True
				-- No need to update the other two visitation boolean flags since they are initialized
				-- in the constructor and the (in)complete_expression preconditions prevent any overlap.

				-- set 'report'
			report := emra.report_ok
		ensure
			not_new_expression: not is_new_expression
			print_changed: is_print_changed
			type_check_changed: is_type_check_changed
			evaluate_changed: is_evaluate_changed
			correct_report: report = emra.report_ok
		end

feature -- Output

	out: STRING
		do
			if is_print_changed then
				printer_value := expr_tree.out
				is_print_changed := False
			end

				-- set 'Result'
			Result := "  Expression currently specified: " + printer_value + "%N  Report: " + report
		ensure then
			report_unchanged: report ~ (old report.deep_twin)
			not_print_changed: not is_print_changed
			correct_printer_value: printer_value ~ expr_tree.out
			print_changed_and_printer_value_relation: (is_print_changed = (old is_print_changed)) = (printer_value ~ (old printer_value.deep_twin))
			result_not_empty: not Result.is_empty
			correct_result: Result ~ ("  Expression currently specified: " + printer_value + "%N  Report: " + report)
			complete_expression_null_cursor_relation: is_complete_expression = (null_cursor_count = 0)
			incomplete_expression_null_cursor_relation: (not is_complete_expression) = (null_cursor_count = 1)
		end

feature -- Null Cursor Count

	null_cursor_count: INTEGER
		require
			not_print_changed: not is_print_changed
		local
			s: IMMUTABLE_STRING_8
			i: INTEGER
		do
			from
				Result := 0
				s := printer_value
				i := s.lower
			until
				i > s.count -- not (i <= s.count)
			loop
				if (s [i] = '?') then
					Result := Result + 1
				end
				i := i + 1
			end
		end

end

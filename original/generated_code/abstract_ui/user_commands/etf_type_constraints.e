class
	ETF_TYPE_CONSTRAINTS

feature -- List of Enumeratd Constants

	frozen enum_items: HASH_TABLE [INTEGER, STRING]
		do
			create {HASH_TABLE [INTEGER, STRING]} Result.make (10)
			Result.compare_objects
		end

	frozen enum_items_inverse: HASH_TABLE [STRING, INTEGER_64]
		do
			create {HASH_TABLE [STRING, INTEGER_64]} Result.make (10)
			Result.compare_objects
		end

feature -- Query on Declarations of Event Parameters

	frozen evt_param_types_table: HASH_TABLE [HASH_TABLE [ETF_PARAM_TYPE, STRING], STRING]
		local
			type_check_param_types, evaluate_param_types, reset_param_types, boolean_constant_param_types, integer_constant_param_types, empty_set_constant_param_types, add_param_types, subtract_param_types, multiply_param_types, divide_param_types, mod_param_types, conjoin_param_types, disjoin_param_types, exclusive_disjoin_param_types, imply_param_types, equals_param_types, less_than_or_equal_param_types, less_than_param_types, greater_than_param_types, greater_than_or_equal_param_types, union_param_types, intersect_param_types, difference_param_types, subset_equal_param_types, subset_proper_param_types, superset_equal_param_types, superset_proper_param_types, negative_param_types, negation_param_types, sum_param_types, product_param_types, count_param_types, for_all_param_types, there_exists_param_types, open_set_enumeration_param_types, close_set_enumeration_param_types: HASH_TABLE [ETF_PARAM_TYPE, STRING]
		do
				-- 'Result'
			create {HASH_TABLE [HASH_TABLE [ETF_PARAM_TYPE, STRING], STRING]} Result.make (10)
			Result.compare_objects

				-- 'type_check_param_types'
			create {HASH_TABLE [ETF_PARAM_TYPE, STRING]} type_check_param_types.make (10)
			type_check_param_types.compare_objects
			Result.extend (type_check_param_types, "type_check")

				-- 'evaluate_param_types'
			create {HASH_TABLE [ETF_PARAM_TYPE, STRING]} evaluate_param_types.make (10)
			evaluate_param_types.compare_objects
			Result.extend (evaluate_param_types, "evaluate")

				-- 'reset_param_types'
			create {HASH_TABLE [ETF_PARAM_TYPE, STRING]} reset_param_types.make (10)
			reset_param_types.compare_objects
			Result.extend (reset_param_types, "reset")

				-- 'boolean_constant_param_types'
			create {HASH_TABLE [ETF_PARAM_TYPE, STRING]} boolean_constant_param_types.make (10)
			boolean_constant_param_types.compare_objects
			boolean_constant_param_types.extend (create {ETF_BOOL_PARAM}.default_create, "c")
			Result.extend (boolean_constant_param_types, "boolean_constant")

				-- 'integer_constant_param_types'
			create {HASH_TABLE [ETF_PARAM_TYPE, STRING]} integer_constant_param_types.make (10)
			integer_constant_param_types.compare_objects
			integer_constant_param_types.extend (create {ETF_INT_PARAM}.default_create, "c")
			Result.extend (integer_constant_param_types, "integer_constant")

				-- 'empty_set_constant_param_types'
			create {HASH_TABLE [ETF_PARAM_TYPE, STRING]} empty_set_constant_param_types.make (10)
			empty_set_constant_param_types.compare_objects
			Result.extend (empty_set_constant_param_types, "empty_set_constant")

				-- 'add_param_types'
			create {HASH_TABLE [ETF_PARAM_TYPE, STRING]} add_param_types.make (10)
			add_param_types.compare_objects
			Result.extend (add_param_types, "add")

				-- 'subtract_param_types'
			create {HASH_TABLE [ETF_PARAM_TYPE, STRING]} subtract_param_types.make (10)
			subtract_param_types.compare_objects
			Result.extend (subtract_param_types, "subtract")

				-- 'multiply_param_types'
			create {HASH_TABLE [ETF_PARAM_TYPE, STRING]} multiply_param_types.make (10)
			multiply_param_types.compare_objects
			Result.extend (multiply_param_types, "multiply")

				-- 'divide_param_types'
			create {HASH_TABLE [ETF_PARAM_TYPE, STRING]} divide_param_types.make (10)
			divide_param_types.compare_objects
			Result.extend (divide_param_types, "divide")

				-- 'mod_param_types'
			create {HASH_TABLE [ETF_PARAM_TYPE, STRING]} mod_param_types.make (10)
			mod_param_types.compare_objects
			Result.extend (mod_param_types, "mod")

				-- 'conjoin_param_types'
			create {HASH_TABLE [ETF_PARAM_TYPE, STRING]} conjoin_param_types.make (10)
			conjoin_param_types.compare_objects
			Result.extend (conjoin_param_types, "conjoin")

				-- 'disjoin_param_types'
			create {HASH_TABLE [ETF_PARAM_TYPE, STRING]} disjoin_param_types.make (10)
			disjoin_param_types.compare_objects
			Result.extend (disjoin_param_types, "disjoin")

				-- 'exclusive_disjoin_param_types'
			create {HASH_TABLE [ETF_PARAM_TYPE, STRING]} exclusive_disjoin_param_types.make (10)
			exclusive_disjoin_param_types.compare_objects
			Result.extend (exclusive_disjoin_param_types, "exclusive_disjoin")

				-- 'imply_param_types'
			create {HASH_TABLE [ETF_PARAM_TYPE, STRING]} imply_param_types.make (10)
			imply_param_types.compare_objects
			Result.extend (imply_param_types, "imply")

				-- 'equals_param_types'
			create {HASH_TABLE [ETF_PARAM_TYPE, STRING]} equals_param_types.make (10)
			equals_param_types.compare_objects
			Result.extend (equals_param_types, "equals")

				-- 'less_than_or_equal_param_types'
			create {HASH_TABLE [ETF_PARAM_TYPE, STRING]} less_than_or_equal_param_types.make (10)
			less_than_or_equal_param_types.compare_objects
			Result.extend (less_than_or_equal_param_types, "less_than_or_equal")

				-- 'less_than_param_types'
			create {HASH_TABLE [ETF_PARAM_TYPE, STRING]} less_than_param_types.make (10)
			less_than_param_types.compare_objects
			Result.extend (less_than_param_types, "less_than")

				-- 'greater_than_param_types'
			create {HASH_TABLE [ETF_PARAM_TYPE, STRING]} greater_than_param_types.make (10)
			greater_than_param_types.compare_objects
			Result.extend (greater_than_param_types, "greater_than")

				-- 'greater_than_or_equal_param_types'
			create {HASH_TABLE [ETF_PARAM_TYPE, STRING]} greater_than_or_equal_param_types.make (10)
			greater_than_or_equal_param_types.compare_objects
			Result.extend (greater_than_or_equal_param_types, "greater_than_or_equal")

				-- 'union_param_types'
			create {HASH_TABLE [ETF_PARAM_TYPE, STRING]} union_param_types.make (10)
			union_param_types.compare_objects
			Result.extend (union_param_types, "union")

				-- 'intersect_param_types'
			create {HASH_TABLE [ETF_PARAM_TYPE, STRING]} intersect_param_types.make (10)
			intersect_param_types.compare_objects
			Result.extend (intersect_param_types, "intersect")

				-- 'difference_param_types'
			create {HASH_TABLE [ETF_PARAM_TYPE, STRING]} difference_param_types.make (10)
			difference_param_types.compare_objects
			Result.extend (difference_param_types, "difference")

				-- 'subset_equal_param_types'
			create {HASH_TABLE [ETF_PARAM_TYPE, STRING]} subset_equal_param_types.make (10)
			subset_equal_param_types.compare_objects
			Result.extend (subset_equal_param_types, "subset_equal")

				-- 'subset_proper_param_types'
			create {HASH_TABLE [ETF_PARAM_TYPE, STRING]} subset_proper_param_types.make (10)
			subset_proper_param_types.compare_objects
			Result.extend (subset_proper_param_types, "subset_proper")

				-- 'superset_equal_param_types'
			create {HASH_TABLE [ETF_PARAM_TYPE, STRING]} superset_equal_param_types.make (10)
			superset_equal_param_types.compare_objects
			Result.extend (superset_equal_param_types, "superset_equal")

				-- 'superset_proper_param_types'
			create {HASH_TABLE [ETF_PARAM_TYPE, STRING]} superset_proper_param_types.make (10)
			superset_proper_param_types.compare_objects
			Result.extend (superset_proper_param_types, "superset_proper")

				-- 'negative_param_types'
			create {HASH_TABLE [ETF_PARAM_TYPE, STRING]} negative_param_types.make (10)
			negative_param_types.compare_objects
			Result.extend (negative_param_types, "negative")

				-- 'negation_param_types'
			create {HASH_TABLE [ETF_PARAM_TYPE, STRING]} negation_param_types.make (10)
			negation_param_types.compare_objects
			Result.extend (negation_param_types, "negation")

				-- 'sum_param_types'
			create {HASH_TABLE [ETF_PARAM_TYPE, STRING]} sum_param_types.make (10)
			sum_param_types.compare_objects
			Result.extend (sum_param_types, "sum")

				-- 'product_param_types'
			create {HASH_TABLE [ETF_PARAM_TYPE, STRING]} product_param_types.make (10)
			product_param_types.compare_objects
			Result.extend (product_param_types, "product")

				-- 'count_param_types'
			create {HASH_TABLE [ETF_PARAM_TYPE, STRING]} count_param_types.make (10)
			count_param_types.compare_objects
			Result.extend (count_param_types, "count")

				-- 'for_all_param_types'
			create {HASH_TABLE [ETF_PARAM_TYPE, STRING]} for_all_param_types.make (10)
			for_all_param_types.compare_objects
			Result.extend (for_all_param_types, "for_all")

				-- 'there_exists_param_types'
			create {HASH_TABLE [ETF_PARAM_TYPE, STRING]} there_exists_param_types.make (10)
			there_exists_param_types.compare_objects
			Result.extend (there_exists_param_types, "there_exists")

				-- 'open_set_enumeration_param_types'
			create {HASH_TABLE [ETF_PARAM_TYPE, STRING]} open_set_enumeration_param_types.make (10)
			open_set_enumeration_param_types.compare_objects
			Result.extend (open_set_enumeration_param_types, "open_set_enumeration")

				-- 'close_set_enumeration_param_types'
			create {HASH_TABLE [ETF_PARAM_TYPE, STRING]} close_set_enumeration_param_types.make (10)
			close_set_enumeration_param_types.compare_objects
			Result.extend (close_set_enumeration_param_types, "close_set_enumeration")
		end

	frozen evt_param_types_list: HASH_TABLE [LINKED_LIST [ETF_PARAM_TYPE], STRING]
		local
			type_check_param_types, evaluate_param_types, reset_param_types, boolean_constant_param_types, integer_constant_param_types, empty_set_constant_param_types, add_param_types, subtract_param_types, multiply_param_types, divide_param_types, mod_param_types, conjoin_param_types, disjoin_param_types, exclusive_disjoin_param_types, imply_param_types, equals_param_types, less_than_or_equal_param_types, less_than_param_types, greater_than_param_types, greater_than_or_equal_param_types, union_param_types, intersect_param_types, difference_param_types, subset_equal_param_types, subset_proper_param_types, superset_equal_param_types, superset_proper_param_types, negative_param_types, negation_param_types, sum_param_types, product_param_types, count_param_types, for_all_param_types, there_exists_param_types, open_set_enumeration_param_types, close_set_enumeration_param_types: LINKED_LIST [ETF_PARAM_TYPE]
		do
				-- 'Result'
			create {HASH_TABLE [LINKED_LIST [ETF_PARAM_TYPE], STRING]} Result.make (10)
			Result.compare_objects

				-- 'type_check_param_types'
			create {LINKED_LIST [ETF_PARAM_TYPE]} type_check_param_types.make
			type_check_param_types.compare_objects
			Result.extend (type_check_param_types, "type_check")

				-- 'evaluate_param_types'
			create {LINKED_LIST [ETF_PARAM_TYPE]} evaluate_param_types.make
			evaluate_param_types.compare_objects
			Result.extend (evaluate_param_types, "evaluate")

				-- 'reset_param_types'
			create {LINKED_LIST [ETF_PARAM_TYPE]} reset_param_types.make
			reset_param_types.compare_objects
			Result.extend (reset_param_types, "reset")

				-- 'boolean_constant_param_types'
			create {LINKED_LIST [ETF_PARAM_TYPE]} boolean_constant_param_types.make
			boolean_constant_param_types.compare_objects
			boolean_constant_param_types.extend (create {ETF_BOOL_PARAM}.default_create)
			Result.extend (boolean_constant_param_types, "boolean_constant")

				-- 'integer_constant_param_types'
			create {LINKED_LIST [ETF_PARAM_TYPE]} integer_constant_param_types.make
			integer_constant_param_types.compare_objects
			integer_constant_param_types.extend (create {ETF_INT_PARAM}.default_create)
			Result.extend (integer_constant_param_types, "integer_constant")

				-- 'empty_set_constant_param_types'
			create {LINKED_LIST [ETF_PARAM_TYPE]} empty_set_constant_param_types.make
			empty_set_constant_param_types.compare_objects
			Result.extend (empty_set_constant_param_types, "empty_set_constant")

				-- 'add_param_types'
			create {LINKED_LIST [ETF_PARAM_TYPE]} add_param_types.make
			add_param_types.compare_objects
			Result.extend (add_param_types, "add")

				-- 'subtract_param_types'
			create {LINKED_LIST [ETF_PARAM_TYPE]} subtract_param_types.make
			subtract_param_types.compare_objects
			Result.extend (subtract_param_types, "subtract")

				-- 'multiply_param_types'
			create {LINKED_LIST [ETF_PARAM_TYPE]} multiply_param_types.make
			multiply_param_types.compare_objects
			Result.extend (multiply_param_types, "multiply")

				-- 'divide_param_types'
			create {LINKED_LIST [ETF_PARAM_TYPE]} divide_param_types.make
			divide_param_types.compare_objects
			Result.extend (divide_param_types, "divide")

				-- 'mod_param_types'
			create {LINKED_LIST [ETF_PARAM_TYPE]} mod_param_types.make
			mod_param_types.compare_objects
			Result.extend (mod_param_types, "mod")

				-- 'conjoin_param_types'
			create {LINKED_LIST [ETF_PARAM_TYPE]} conjoin_param_types.make
			conjoin_param_types.compare_objects
			Result.extend (conjoin_param_types, "conjoin")

				-- 'disjoin_param_types'
			create {LINKED_LIST [ETF_PARAM_TYPE]} disjoin_param_types.make
			disjoin_param_types.compare_objects
			Result.extend (disjoin_param_types, "disjoin")

				-- 'exclusive_disjoin_param_types'
			create {LINKED_LIST [ETF_PARAM_TYPE]} exclusive_disjoin_param_types.make
			exclusive_disjoin_param_types.compare_objects
			Result.extend (exclusive_disjoin_param_types, "exclusive_disjoin")

				-- 'imply_param_types'
			create {LINKED_LIST [ETF_PARAM_TYPE]} imply_param_types.make
			imply_param_types.compare_objects
			Result.extend (imply_param_types, "imply")

				-- 'equals_param_types'
			create {LINKED_LIST [ETF_PARAM_TYPE]} equals_param_types.make
			equals_param_types.compare_objects
			Result.extend (equals_param_types, "equals")

				-- 'less_than_or_equal_param_types'
			create {LINKED_LIST [ETF_PARAM_TYPE]} less_than_or_equal_param_types.make
			less_than_or_equal_param_types.compare_objects
			Result.extend (less_than_or_equal_param_types, "less_than_or_equal")

				-- 'less_than_param_types'
			create {LINKED_LIST [ETF_PARAM_TYPE]} less_than_param_types.make
			less_than_param_types.compare_objects
			Result.extend (less_than_param_types, "less_than")

				-- 'greater_than_param_types'
			create {LINKED_LIST [ETF_PARAM_TYPE]} greater_than_param_types.make
			greater_than_param_types.compare_objects
			Result.extend (greater_than_param_types, "greater_than")

				-- 'greater_than_or_equal_param_types'
			create {LINKED_LIST [ETF_PARAM_TYPE]} greater_than_or_equal_param_types.make
			greater_than_or_equal_param_types.compare_objects
			Result.extend (greater_than_or_equal_param_types, "greater_than_or_equal")

				-- 'union_param_types'
			create {LINKED_LIST [ETF_PARAM_TYPE]} union_param_types.make
			union_param_types.compare_objects
			Result.extend (union_param_types, "union")

				-- 'intersect_param_types'
			create {LINKED_LIST [ETF_PARAM_TYPE]} intersect_param_types.make
			intersect_param_types.compare_objects
			Result.extend (intersect_param_types, "intersect")

				-- 'difference_param_types'
			create {LINKED_LIST [ETF_PARAM_TYPE]} difference_param_types.make
			difference_param_types.compare_objects
			Result.extend (difference_param_types, "difference")

				-- 'subset_equal_param_types'
			create {LINKED_LIST [ETF_PARAM_TYPE]} subset_equal_param_types.make
			subset_equal_param_types.compare_objects
			Result.extend (subset_equal_param_types, "subset_equal")

				-- 'subset_proper_param_types'
			create {LINKED_LIST [ETF_PARAM_TYPE]} subset_proper_param_types.make
			subset_proper_param_types.compare_objects
			Result.extend (subset_proper_param_types, "subset_proper")

				-- 'superset_equal_param_types'
			create {LINKED_LIST [ETF_PARAM_TYPE]} superset_equal_param_types.make
			superset_equal_param_types.compare_objects
			Result.extend (superset_equal_param_types, "superset_equal")

				-- 'superset_proper_param_types'
			create {LINKED_LIST [ETF_PARAM_TYPE]} superset_proper_param_types.make
			superset_proper_param_types.compare_objects
			Result.extend (superset_proper_param_types, "superset_proper")

				-- 'negative_param_types'
			create {LINKED_LIST [ETF_PARAM_TYPE]} negative_param_types.make
			negative_param_types.compare_objects
			Result.extend (negative_param_types, "negative")

				-- 'negation_param_types'
			create {LINKED_LIST [ETF_PARAM_TYPE]} negation_param_types.make
			negation_param_types.compare_objects
			Result.extend (negation_param_types, "negation")

				-- 'sum_param_types'
			create {LINKED_LIST [ETF_PARAM_TYPE]} sum_param_types.make
			sum_param_types.compare_objects
			Result.extend (sum_param_types, "sum")

				-- 'product_param_types'
			create {LINKED_LIST [ETF_PARAM_TYPE]} product_param_types.make
			product_param_types.compare_objects
			Result.extend (product_param_types, "product")

				-- 'count_param_types'
			create {LINKED_LIST [ETF_PARAM_TYPE]} count_param_types.make
			count_param_types.compare_objects
			Result.extend (count_param_types, "count")

				-- 'for_all_param_types'
			create {LINKED_LIST [ETF_PARAM_TYPE]} for_all_param_types.make
			for_all_param_types.compare_objects
			Result.extend (for_all_param_types, "for_all")

				-- 'there_exists_param_types'
			create {LINKED_LIST [ETF_PARAM_TYPE]} there_exists_param_types.make
			there_exists_param_types.compare_objects
			Result.extend (there_exists_param_types, "there_exists")

				-- 'open_set_enumeration_param_types'
			create {LINKED_LIST [ETF_PARAM_TYPE]} open_set_enumeration_param_types.make
			open_set_enumeration_param_types.compare_objects
			Result.extend (open_set_enumeration_param_types, "open_set_enumeration")

				-- 'close_set_enumeration_param_types'
			create {LINKED_LIST [ETF_PARAM_TYPE]} close_set_enumeration_param_types.make
			close_set_enumeration_param_types.compare_objects
			Result.extend (close_set_enumeration_param_types, "close_set_enumeration")
		end

feature -- Comments for Contracts

	frozen comment (etf_s: STRING): BOOLEAN
		do
			Result := TRUE
		end

end

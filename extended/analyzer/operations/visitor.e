note
	description: "Summary description for {VISITOR}."
	author: "Ashkan Moatamed"

deferred class
	VISITOR

inherit

	ANY
		undefine
			default_create
		end

feature -- New Visitor Attribute

	frozen is_new: BOOLEAN

feature -- Visitation Resulting Value Attribute

	frozen value: IMMUTABLE_STRING_8

feature -- Constructor

	default_create
		deferred
		ensure then
			new_visitor: is_new
			empty_value: value.is_empty
		end

feature -- Reset

	frozen reset
		do
			default_create
		ensure
			new_visitor: is_new
			empty_value: value.is_empty
		end

feature -- Constant Expressions

	visit_null_expression (e: NULL_EXPRESSION)
		require
			new_visitor: is_new
		deferred
		ensure
			not_new_visitor: not is_new
		end

	visit_boolean_constant (e: BOOLEAN_CONSTANT)
		require
			new_visitor: is_new
		deferred
		ensure
			not_new_visitor: not is_new
		end

	visit_integer_constant (e: INTEGER_CONSTANT)
		require
			new_visitor: is_new
		deferred
		ensure
			not_new_visitor: not is_new
		end

	visit_empty_set_constant (e: EMPTY_SET_CONSTANT)
		require
			new_visitor: is_new
		deferred
		ensure
			not_new_visitor: not is_new
		end

	visit_unevaluable_expression (e: UNEVALUABLE_EXPRESSION)
		require
			new_visitor: is_new
		deferred
		ensure
			not_new_visitor: not is_new
		end

feature -- Binary Op. Expressions

	visit_equality (e: EQUALITY)
		require
			new_visitor: is_new
		deferred
		ensure
			not_new_visitor: not is_new
		end

		-- Boolean

	visit_conjunction (e: CONJUNCTION) -- AND
		require
			new_visitor: is_new
		deferred
		ensure
			not_new_visitor: not is_new
		end

	visit_disjunction (e: DISJUNCTION) -- OR
		require
			new_visitor: is_new
		deferred
		ensure
			not_new_visitor: not is_new
		end

	visit_exclusive_disjunction (e: EXCLUSIVE_DISJUNCTION) -- XOR
		require
			new_visitor: is_new
		deferred
		ensure
			not_new_visitor: not is_new
		end

	visit_implication (e: IMPLICATION)
		require
			new_visitor: is_new
		deferred
		ensure
			not_new_visitor: not is_new
		end

		-- Number

	visit_addition (e: ADDITION)
		require
			new_visitor: is_new
		deferred
		ensure
			not_new_visitor: not is_new
		end

	visit_subtraction (e: SUBTRACTION)
		require
			new_visitor: is_new
		deferred
		ensure
			not_new_visitor: not is_new
		end

	visit_multiplication (e: MULTIPLICATION)
		require
			new_visitor: is_new
		deferred
		ensure
			not_new_visitor: not is_new
		end

	visit_division (e: DIVISION)
		require
			new_visitor: is_new
		deferred
		ensure
			not_new_visitor: not is_new
		end

	visit_mod (e: MOD)
		require
			new_visitor: is_new
		deferred
		ensure
			not_new_visitor: not is_new
		end

	visit_less_than_or_equal (e: LESS_THAN_OR_EQUAL)
		require
			new_visitor: is_new
		deferred
		ensure
			not_new_visitor: not is_new
		end

	visit_less_than (e: LESS_THAN)
		require
			new_visitor: is_new
		deferred
		ensure
			not_new_visitor: not is_new
		end

	visit_greater_than (e: GREATER_THAN)
		require
			new_visitor: is_new
		deferred
		ensure
			not_new_visitor: not is_new
		end

	visit_greater_than_or_equal (e: GREATER_THAN_OR_EQUAL)
		require
			new_visitor: is_new
		deferred
		ensure
			not_new_visitor: not is_new
		end

		-- Set

	visit_union (e: UNION)
		require
			new_visitor: is_new
		deferred
		ensure
			not_new_visitor: not is_new
		end

	visit_intersection (e: INTERSECTION)
		require
			new_visitor: is_new
		deferred
		ensure
			not_new_visitor: not is_new
		end

	visit_difference (e: DIFFERENCE)
		require
			new_visitor: is_new
		deferred
		ensure
			not_new_visitor: not is_new
		end

	visit_subset_equal (e: SUBSET_EQUAL)
		require
			new_visitor: is_new
		deferred
		ensure
			not_new_visitor: not is_new
		end

	visit_subset_proper (e: SUBSET_PROPER)
		require
			new_visitor: is_new
		deferred
		ensure
			not_new_visitor: not is_new
		end

	visit_superset_equal (e: SUPERSET_EQUAL)
		require
			new_visitor: is_new
		deferred
		ensure
			not_new_visitor: not is_new
		end

	visit_superset_proper (e: SUPERSET_PROPER)
		require
			new_visitor: is_new
		deferred
		ensure
			not_new_visitor: not is_new
		end

feature -- Unary Op. Expressions

		-- Boolean

	visit_negation (e: NEGATION)
		require
			new_visitor: is_new
		deferred
		ensure
			not_new_visitor: not is_new
		end

	visit_count (e: COUNT)
		require
			new_visitor: is_new
		deferred
		ensure
			not_new_visitor: not is_new
		end

	visit_for_all (e: FOR_ALL)
		require
			new_visitor: is_new
		deferred
		ensure
			not_new_visitor: not is_new
		end

	visit_there_exists (e: THERE_EXISTS)
		require
			new_visitor: is_new
		deferred
		ensure
			not_new_visitor: not is_new
		end

		-- Number

	visit_negative (e: NEGATIVE)
		require
			new_visitor: is_new
		deferred
		ensure
			not_new_visitor: not is_new
		end

	visit_summation (e: SUMMATION)
		require
			new_visitor: is_new
		deferred
		ensure
			not_new_visitor: not is_new
		end

	visit_product (e: PRODUCT)
		require
			new_visitor: is_new
		deferred
		ensure
			not_new_visitor: not is_new
		end

feature -- Composite Expressions

	visit_set_enum (e: SET_ENUMERATION)
		require
			new_visitor: is_new
		deferred
		ensure
			not_new_visitor: not is_new
		end

end

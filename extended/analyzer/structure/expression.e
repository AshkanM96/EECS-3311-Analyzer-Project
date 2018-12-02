note
	description: "Summary description for {EXPRESSION}."
	author: "Ashkan Moatamed"

deferred class
	EXPRESSION

inherit

	ANY
		undefine
			is_equal,
			out
		end

feature -- Type Queries

	is_null: BOOLEAN
		deferred
		ensure
			correct_result: Result = (attached {NULL_EXPRESSION} Current)
			null_is_const: Result implies is_const
		end

	is_const: BOOLEAN
		deferred
		ensure
			correct_result: Result = (attached {CONSTANT_EXPRESSION} Current)
		end

	is_binary_op: BOOLEAN
		deferred
		ensure
			correct_result: Result = (attached {BINARY_OP} Current)
			binary_op_not_const: Result implies (not is_const)
		end

	is_unary_op: BOOLEAN
		deferred
		ensure
			correct_result: Result = (attached {UNARY_OP} Current)
			unary_op_not_const: Result implies (not is_const)
		end

	is_set_enum: BOOLEAN
		deferred
		ensure
			correct_result: Result = (attached {SET_ENUMERATION} Current)
			set_enum_not_const: Result implies (not is_const)
		end

feature -- State Queries

	is_open: BOOLEAN
		deferred
		end

	is_open_rec: BOOLEAN
		deferred
		ensure
			open_implies_open_rec: is_open implies Result
		end

feature -- Adding

	add (e: EXPRESSION)
		require
			valid_argument: (e /= Void) and then (not e.is_null)
			valid_current: is_open and then (not is_const)
		deferred
		end

feature -- Output

	out: STRING
		deferred
		ensure then
			result_not_empty: not Result.is_empty
		end

feature -- Duplication

	dual: like Current
		deferred
		ensure
			result_not_void: Result /= Void
			result_equal_to_current: Result ~ Current
		end

	deep_dual: like Current
		deferred
		ensure
			result_not_void: Result /= Void
			result_equal_to_current: Result ~ Current
		end

feature -- Visitor Pattern

	visit (v: VISITOR)
		require
			new_visitor: v.is_new
		deferred
		ensure
			not_new_visitor: not v.is_new
		end

end

note
	description: "Summary description for {UNARY_OP}."
	author: "Ashkan Moatamed"

deferred class
	UNARY_OP

inherit

	VARIABLE_EXPRESSION
		redefine
			default_create,
			is_unary_op
		end

feature -- Children

	frozen child: EXPRESSION

feature {UNARY_OP} -- Children Setter

	frozen set_child (e: EXPRESSION)
		require
			valid_argument: e /= Void
		do
			child := e
		ensure
			correct_child: child = e
		end

feature -- Constructor

	frozen default_create
		do
			child := cea.null_cur
		ensure then
			new: is_new
			correct_child: child = cea.null_cur
		end

feature -- Reset

	frozen reset
		do
			default_create
		ensure then
			correct_child: child = cea.null_cur
		end

feature -- Type Queries

	frozen is_unary_op: BOOLEAN = True

feature -- State Queries

	frozen is_new: BOOLEAN
		do
			Result := (child = cea.null_cur)
		ensure then
			correct_result: Result = (child = cea.null_cur)
		end

	frozen is_open: BOOLEAN
		do
			Result := child.is_null
		ensure then
			correct_result: Result = child.is_null
		end

	frozen is_open_rec: BOOLEAN
		do
			Result := is_open or else child.is_open_rec
		ensure then
			correct_result: Result = (is_open or else child.is_open_rec)
		end

feature -- Adding

	frozen add (e: EXPRESSION)
		do
			child := e
		ensure then
			correct_child: child = e
			not_open: not is_open
		end

feature -- Equality

	frozen is_equal (other: like Current): BOOLEAN
		do
			if (Current = other) then
				Result := True
			else
				Result := (child ~ other.child)
			end
		end

feature -- Output

	operator: STRING
		deferred
		ensure
			result_not_void: Result /= Void
			correct_result_count: (1 <= Result.count) or else (Result.count <= 3)
			correct_result_content: across Result as cursor all valid_operator_char (cursor.item) end
		end

	frozen out: STRING
		do
			Result := "(" + operator + " " + child.out + ")"
		end

feature -- Duplication

	frozen dual: like Current
		do
			Result := twin
				-- don't need to set child since twin just copies that pointer
		ensure then
			result_child_same_as_current_child: Result.child = child
		end

	frozen deep_dual: like Current
		do
			Result := twin
			Result.set_child (child.deep_dual)
		ensure then
			result_child_equal_to_current_child: Result.child ~ child
			result_child_diff_from_current_child: same_obj_diff_ptr (child, Result.child)
		end

invariant
	child_null: child.is_null implies (child = cea.null_cur)
	child_not_null: (not child.is_null) implies (not is_open)

end

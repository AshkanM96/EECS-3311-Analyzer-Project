note
	description: "Summary description for {BINARY_OP}."
	author: "Ashkan Moatamed"

deferred class
	BINARY_OP

inherit

	VARIABLE_EXPRESSION
		redefine
			default_create,
			is_binary_op
		end

feature -- Children

	frozen left, frozen right: EXPRESSION

feature {BINARY_OP} -- Children Setter

	frozen set_left (e: EXPRESSION)
		require
			valid_argument: e /= Void
		do
			left := e
		ensure
			correct_left: left = e
			correct_right: right ~ (old right.deep_dual)
		end

	frozen set_right (e: EXPRESSION)
		require
			valid_argument: e /= Void
		do
			right := e
		ensure
			correct_left: left ~ (old left.deep_dual)
			correct_right: right = e
		end

feature -- Constructor

	frozen default_create
		do
			left := cea.null_cur
			right := cea.null_nil
		ensure then
			correct_left: left = cea.null_cur
			correct_right: right = cea.null_nil
		end

feature -- Reset

	frozen reset
		do
			default_create
		ensure then
			correct_left: left = cea.null_cur
			correct_right: right = cea.null_nil
		end

feature -- Type Queries

	frozen is_binary_op: BOOLEAN = True

feature -- State Queries

	frozen is_open: BOOLEAN
		do
			Result := left.is_null or else right.is_null
		ensure then
			correct_result: Result = (left.is_null or else right.is_null)
		end

	frozen is_open_rec: BOOLEAN
		do
			Result := is_open or else left.is_open_rec or else right.is_open_rec
		ensure then
			correct_result: Result = (is_open or else left.is_open_rec or else right.is_open_rec)
		end

feature -- Adding

	frozen open_right
		require
			left_not_null: not left.is_null
			right_null: right.is_null
			left_not_open: not left.is_open
		do
			right := cea.null_cur
		ensure
			correct_right: right = cea.null_cur
		end

	frozen add (e: EXPRESSION)
		do
			if left.is_null then
				left := e
				if (not left.is_open) then
					open_right
				end
			else -- right.is_null
				right := e
			end
		ensure then
			right_null: right.is_null implies (left = e)
			right_not_null: (not right.is_null) implies ((right = e) and then (not is_open))
		end

feature -- Equality

	frozen is_equal (other: like Current): BOOLEAN
		do
			if (Current = other) then
				Result := True
			else
				Result := (left ~ other.left) and then (right ~ other.right)
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
			Result := "(" + left.out + " " + operator + " " + right.out + ")"
		end

feature -- Duplication

	frozen dual: like Current
		do
			Result := twin
				-- don't need to set left and right since twin just copies those pointers
		ensure then
			result_left_same_as_current_left: Result.left = left
			result_right_same_as_current_right: Result.right = right
		end

	frozen deep_dual: like Current
		do
			Result := twin
			Result.set_left (left.deep_dual)
			Result.set_right (right.deep_dual)
		ensure then
			result_left_not_same_as_current_left: Result.left /= left
			result_left_equal_to_current_left: Result.left ~ left
			result_right_not_same_as_current_right: Result.right /= right
			result_right_equal_to_current_right: Result.right ~ right
		end

invariant
	left_null: left.is_null implies ((left = cea.null_cur) and then (right = cea.null_nil))
	left_not_null_right_not_null: ((not left.is_null) and then (not right.is_null)) implies (not is_open)

end

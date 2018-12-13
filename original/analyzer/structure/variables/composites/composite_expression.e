note
	description: "Summary description for {COMPOSITE_EXPRESSION}."
	author: "Ashkan Moatamed"

deferred class
	COMPOSITE_EXPRESSION

inherit

	VARIABLE_EXPRESSION
		redefine
			default_create,
			is_equal
		end

	ITERABLE [EXPRESSION]
		redefine
			default_create,
			is_equal
		end

feature {COMPOSITE_EXPRESSION} -- Children

	frozen children: ARRAYED_LIST [EXPRESSION]

feature -- Children Queries

	frozen count: INTEGER
		do
			Result := children.count
		ensure
			correct_result: Result = children.count
		end

	frozen lower: INTEGER
		do
			Result := children.lower
		ensure
			correct_result: Result = children.lower
		end

	frozen upper: INTEGER
		do
			Result := children.upper
		ensure
			correct_result: Result = children.upper
		end

	frozen is_empty: BOOLEAN
		do
			Result := children.is_empty
		ensure
			correct_result: Result = children.is_empty
		end

	frozen first: EXPRESSION
		require
			not_empty: not is_empty
		do
			Result := children.first
		ensure
			correct_result: Result ~ children.first
		end

	frozen last: EXPRESSION
		require
			not_empty: not is_empty
		do
			Result := children.last
		ensure
			correct_result: Result ~ children.last
		end

	frozen valid_index (i: INTEGER): BOOLEAN
		do
			Result := (children.lower <= i) and then (i <= children.count)
		ensure
			correct_result: Result = ((children.lower <= i) and then (i <= children.count))
		end

	frozen get (i: INTEGER): EXPRESSION
		require
			valid_index: valid_index (i)
		do
			Result := children [i]
		ensure
			correct_result: Result ~ children [i]
		end

	has (e: EXPRESSION): BOOLEAN
		require
			argument_not_void: e /= Void
		deferred
		ensure
			correct_result: Result = children.has (e)
		end

feature -- Children Commands

	frozen wipe_out
		do
			children.wipe_out
		ensure
			empty: children.is_empty
		end

feature {COMPOSITE_EXPRESSION} -- Duplicate Flag

	frozen may_have_duplicate: BOOLEAN assign set_may_have_duplicate

feature {COMPOSITE_EXPRESSION} -- Duplicate Fag Setter

	frozen set_may_have_duplicate (b: BOOLEAN)
		do
			may_have_duplicate := b
		ensure
			argument_unchanged: b = (old b)
			set: may_have_duplicate = b
		end

feature -- Constructor

	frozen default_create
		do
			create {ARRAYED_LIST [EXPRESSION]} children.make (10)
			children.compare_objects

				-- set duplicate flag
			may_have_duplicate := False
		ensure then
			new: is_new
			open: is_open
			empty: children.is_empty
			has_no_duplicates: not may_have_duplicate
		end

feature -- Reset

	reset
		deferred
		ensure then
			empty: children.is_empty
			has_no_duplicates: not may_have_duplicate
		end

feature -- State Queries

	frozen is_new: BOOLEAN
		do
			Result := children.is_empty
		ensure then
			correct_result: Result = children.is_empty
		end

feature -- Adding

	add (e: EXPRESSION)
		deferred
		ensure then
			not_empty: not children.is_empty
			may_have_duplicate: may_have_duplicate
		end

	add_all (it: ITERABLE [EXPRESSION])
		require
			argument_not_void: it /= Void
			valid_arguments: across it as cursor all (cursor.item /= Void) and then (not cursor.item.is_null) end
			valid_current: is_open
		deferred
		ensure
			may_have_duplicate: may_have_duplicate
		end

feature -- Iteration Cursor

	frozen new_cursor: ARRAYED_LIST_ITERATION_CURSOR [EXPRESSION]
		do
			Result := children.new_cursor
		end

feature -- Equality

	is_equal (other: like Current): BOOLEAN
		local
			i: INTEGER
		do
			if (Current = other) then
				Result := True
			elseif (children.count /= other.children.count) then
				Result := False
			else
				from
					Result := True -- assume equality
					i := children.lower
				until
					(i > children.count) or else (not Result) -- not ((i <= children.count) and then Result)
				loop
					Result := (children [i] ~ other.children [i])
					i := i + 1
				end
			end
		end

feature -- Duplication

	dual: like Current
		deferred
		ensure then
			result_may_have_duplicate_same_as_current_may_have_duplicate: Result.may_have_duplicate = may_have_duplicate
			result_children_same_as_current_children: Result.children = children
		end

	deep_dual: like Current
		deferred
		ensure then
			result_may_have_duplicate_same_as_current_may_have_duplicate: Result.may_have_duplicate = may_have_duplicate
			result_children_not_same_as_current_children: Result.children /= children
			result_children_equal_to_current_children: Result.children ~ children
			result_children_elements_diff_from_current_children_elements: across children.lower |..| children.count as i all (same_obj_diff_ptr (children [i.item], Result.children [i.item])) end
		end

invariant
	children_object_comparison: children.object_comparison
	all_not_null: across children as cursor all (not cursor.item.is_null) end

end

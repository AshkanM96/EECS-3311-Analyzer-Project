note
	description: "Summary description for {SET_ENUMERATION}."
	author: "Ashkan Moatamed"

frozen class
	SET_ENUMERATION

inherit

	COMPOSITE_EXPRESSION
		redefine
			is_set_enum,
			is_open,
			is_equal,
			out
		end

create
	make_empty, make_from_iterable

feature -- Children Queries

	has (e: EXPRESSION): BOOLEAN
		local
			i: INTEGER
		do
			if (e.is_null or else children.is_empty) then
				Result := False
			else
				from
					Result := False -- assume non-existence
					i := children.lower
				until
					(i > children.count) or else Result -- not ((i <= children.count) and then (not Result))
				loop
					Result := (children [i] ~ e)
					i := i + 1
				end
			end
		ensure then
			argument_unchanged: e ~ (old e.deep_dual)
			current_unchanged: Current ~ (old deep_dual)
			simple_case: (e.is_null or else children.is_empty) implies (not Result)
		end

feature -- Duplicate Elements Removal

	remove_duplicates
		local
			new_children: ARRAYED_LIST [EXPRESSION]
		do
			if (may_have_duplicate and then (children.count > 1)) then
					-- create 'new_children'
				create {ARRAYED_LIST [EXPRESSION]} new_children.make (children.count.min (10))
				new_children.compare_objects

					-- fill 'new_children'
				across
					children as cursor
				loop
					if (not new_children.has (cursor.item)) then
						new_children.extend (cursor.item)
					end
				end

					-- set 'children'
				children := new_children
			end

				-- set duplicate flag
			may_have_duplicate := False
		ensure
			has_no_duplicates: not may_have_duplicate
			current_empty_vs_old_empty: children.is_empty = (old children.is_empty)
			current_count_upper_bound: children.count <= (old children.count)
		end

	removed_duplicates: like Current
		do
			Result := Current.dual
			Result.remove_duplicates
		ensure
			current_unchanged: Current ~ (old deep_dual)
			result_has_no_duplicates: not Result.may_have_duplicate
			result_empty_vs_current_empty: Result.children.is_empty = children.is_empty
			result_count_upper_bound: Result.children.count <= children.count
		end

feature -- Constructors

	make_empty
		do
			is_open := True
			default_create
		ensure
			open: is_open
			empty: children.is_empty
			has_no_duplicates: not may_have_duplicate
		end

	make_from_iterable (it: ITERABLE [EXPRESSION])
		require
			argument_not_void: it /= Void
		do
			is_open := True
			default_create
			add_all (it)
		ensure
			open: is_open
			may_have_duplicate: may_have_duplicate
		end

feature -- Reset

	reset
		do
			is_open := True
			children.wipe_out
			may_have_duplicate := False
		end

feature -- Type Queries

	is_set_enum: BOOLEAN = True

feature -- State Queries

	is_open: BOOLEAN assign set_open

	frozen is_open_rec: BOOLEAN
		local
			i: INTEGER
		do
			if is_open then
				Result := True
			else
				from
					Result := False -- assume Current is not recursively open
					i := children.lower
				until
					(i > children.count) or else Result -- not ((i <= children.count) and then (not Result))
				loop
					Result := children [i].is_open_rec
					i := i + 1
				end
			end
		end

feature -- State Command

	set_open (b: BOOLEAN)
		do
			is_open := b
		ensure
			argument_unchanged: b = (old b)
			set_is_open: is_open = b
			count_unchanged: children.count = (old children.count)
		end

feature -- Adding

	add (e: EXPRESSION)
		do
			children.extend (e)
			may_have_duplicate := True
		ensure then
			open: is_open
			correct_count: children.count = (old children.count) + 1
		end

	add_all (it: ITERABLE [EXPRESSION])
		do
			across
				it as cursor
			loop
				children.extend (cursor.item)
			end
			may_have_duplicate := True
		ensure then
			open: is_open
			current_count_lower_bound: (old children.count) <= children.count
		end

feature -- Set Enumeration Queries

	subset_equal (other: like Current): BOOLEAN
		require
			argument_not_void: other /= Void
		local
			i: INTEGER
		do
			if children.is_empty then
				Result := True
			elseif other.children.is_empty then
				Result := False
			else
				from
					Result := True -- assume Current is subset of other
					i := children.lower
				until
					(i > children.count) or else (not Result) -- not ((i <= children.count) and then Result)
				loop
					Result := other.children.has (children [i])
					i := i + 1
				end
			end
		ensure
			other_unchanged: other ~ (old other.deep_dual)
			current_unchanged: Current ~ (old deep_dual)
			current_empty: children.is_empty implies Result
			current_not_empty_other_empty: ((not children.is_empty) and then other.children.is_empty) implies (not Result)
		end

	subset_proper (other: like Current): BOOLEAN
		require
			argument_not_void: other /= Void
		local
			i: INTEGER
		do
			if children.is_empty then
				Result := not other.children.is_empty
			elseif other.children.is_empty then
				Result := False
			else
				if (subset_equal (other)) then
					from
						Result := False -- assume Current equals other
						i := children.lower
					until
						(i > other.children.count) or else Result -- not ((i <= other.children.count) and then (not Result))
					loop
						Result := (not children.has (other.children [i]))
						i := i + 1
					end
				else
						-- cannot be a proper subset if not a subset
					Result := False
				end
			end
		ensure
			other_unchanged: other ~ (old other.deep_dual)
			current_unchanged: Current ~ (old deep_dual)
			current_empty: children.is_empty implies (Result = (not other.children.is_empty))
			current_not_empty_other_empty: ((not children.is_empty) and then other.children.is_empty) implies (not Result)
		end

	superset_equal (other: like Current): BOOLEAN
		require
			argument_not_void: other /= Void
		do
			Result := other.subset_equal (Current)
		ensure
			other_unchanged: other ~ (old other.deep_dual)
			current_unchanged: Current ~ (old deep_dual)
			other_empty: other.children.is_empty implies Result
			other_not_empty_current_empty: ((not other.children.is_empty) and then children.is_empty) implies (not Result)
		end

	superset_proper (other: like Current): BOOLEAN
		require
			argument_not_void: other /= Void
		do
			Result := other.subset_proper (Current)
		ensure
			other_unchanged: other ~ (old other.deep_dual)
			current_unchanged: Current ~ (old deep_dual)
			other_empty: other.children.is_empty implies (Result = (not children.is_empty))
			other_not_empty_current_empty: ((not other.children.is_empty) and then children.is_empty) implies (not Result)
		end

feature -- Set Enumeration Commands

	union (other: like Current)
		local
			old_is_open: BOOLEAN
		do
			old_is_open := is_open
			is_open := True
			add_all (other.children)
			is_open := old_is_open
		ensure
			other_unchanged: other ~ (old other.deep_dual)
			empty_relation: children.is_empty = ((old children.is_empty) and then other.children.is_empty)
			count_relation: children.count = ((old children.count) + other.children.count)
			open_unchanged: is_open = (old is_open)
			may_have_duplicate: may_have_duplicate
		end

	intersect (other: like Current)
		local
			new_children: ARRAYED_LIST [EXPRESSION]
		do
				-- handle empty case quickly
			if (children.is_empty or else other.children.is_empty) then
				children.wipe_out
			else

					-- create 'new_children'
				create {ARRAYED_LIST [EXPRESSION]} new_children.make (children.count.min (10))
				new_children.compare_objects

					-- fill 'new_children'
				across
					children as cursor
				loop
					if other.children.has (cursor.item) then
						new_children.extend (cursor.item)
					end
				end

					-- set 'children'
				children := new_children
			end
		ensure
			other_unchanged: other ~ (old other.deep_dual)
			simple_empty_case: ((old children.is_empty) or else other.is_empty) implies children.is_empty
			count_relation: children.count <= (old children.count).min (other.children.count)
		end

	difference (other: like Current)
		local
			new_children: ARRAYED_LIST [EXPRESSION]
		do
			if (not children.is_empty) then
				if (not other.children.is_empty) then

						-- create 'new_children'
					create {ARRAYED_LIST [EXPRESSION]} new_children.make (children.count.min (10))
					new_children.compare_objects

						-- fill 'new_children'
					across
						children as cursor
					loop
						if (not other.children.has (cursor.item)) then
							new_children.extend (cursor.item)
						end
					end

						-- set 'children'
					children := new_children
				end
			end
		ensure
			other_unchanged: other ~ (old other.deep_dual)
			old_empty: (old children.is_empty) implies children.is_empty
			current_count_upper_bound: children.count <= (old children.count)
			old_not_empty_other_empty: ((not (old children.is_empty)) and then other.children.is_empty) implies (Current ~ (old Current.deep_dual))
		end

feature -- Equality

	is_equal (other: like Current): BOOLEAN
		do
			if (Current = other) then
				Result := True
			elseif (children.is_empty or else other.children.is_empty) then
				Result := children.is_empty and then other.children.is_empty
			elseif ((children.count = 1) and then (other.children.count = 1)) then
					-- quickly evaluate this simple case without possible recursion
				Result := children.first ~ other.children.first
			elseif (may_have_duplicate or else other.may_have_duplicate) then
					-- recursively calls itself with distinct SET_ENUMERATIONs
				Result := removed_duplicates ~ other.removed_duplicates
					-- note: this block of code will execute at most once
			else
				Result := subset_equal (other) and then other.subset_equal (Current)
			end
		end

feature -- Output

	out: STRING
		local
			i: INTEGER
		do
			if children.is_empty then
				if is_open then
					Result := "{?}"
				else
					Result := "{}"
				end
			else
				from
					Result := "{" + children.first.out
					i := children.lower + 1 -- 2nd index
				until
					(i > children.count) -- not (i <= children.count)
				loop
					Result.append (", " + children [i].out)
					i := i + 1
				end

					-- add the closing right brace (and a cursor if needed)
				if (is_open and then (not Result.has ('?'))) then
						-- the second condition is needed to handle nested variable expressions which may be open as well
					Result.append (", ?}")
				else
					Result.append ("}")
				end
			end
		ensure then
			empty_open: (children.is_empty and then is_open) implies (Result ~ "{?}")
			empty_not_open: (children.is_empty and then (not is_open)) implies (Result ~ "{}")
		end

feature -- Duplication

	dual: like Current
		do
			Result := twin
				-- don't need to set children since twin just copies that pointer
		ensure then
			result_open_same_as_current_open: Result.is_open = is_open
		end

	deep_dual: like Current
		local
			new_children: ARRAYED_LIST [EXPRESSION]
		do
				-- create 'new_children'
			create {ARRAYED_LIST [EXPRESSION]} new_children.make (children.count)
			new_children.compare_objects

				-- fill 'new_children'
			across
				children as cursor
			loop
				new_children.extend (cursor.item.deep_dual)
			end

				-- create and fill 'Result'
			create {SET_ENUMERATION} Result.make_from_iterable (new_children)

				-- make 'Result' have the same 'is_open' as 'Current'
				-- since by this point, 'Result' will always have an 'is_open' of 'True'
			Result.is_open := is_open

				-- make 'Result' have the same 'may_have_duplicate' as 'Current'
				-- since by this point, 'Result' will always have a 'may_have_duplicate' of 'True'
			Result.may_have_duplicate := may_have_duplicate
		ensure then
			result_open_same_as_current_open: Result.is_open = is_open
		end

feature -- Visitor Pattern

	visit (v: VISITOR)
		do
			v.visit_set_enum (Current)
		end

invariant
	all_not_null: across children as cursor all (not cursor.item.is_null) end

end

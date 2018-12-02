note
	description: "Summary description for {EXPRESSION_TREE}."
	author: "Ashkan Moatamed"

frozen class
	EXPRESSION_TREE

inherit

	ANY
		redefine
			out
		end

create
	make

feature {NONE} -- Constant Expression Singleton Accessor

	cea: CONST_EXPR_ACCESS

feature -- New Expression Tree Attribute

	is_new_tree: BOOLEAN

feature {NONE} -- ET_NODE Position Pointer Attributes

	root, curr: ET_NODE

feature -- Constructor

	make
		do
			is_new_tree := True
			create {ET_NODE} root.make_root (cea.null_cur)
			create {ET_NODE} curr.make_root (cea.null_cur)
		ensure
			new_tree: is_new_tree
		end

feature -- Reset

	frozen reset
		do
			make
		ensure
			new_tree: is_new_tree
		end

feature -- State Query

	is_open: BOOLEAN
		do
			Result := curr.is_null
		ensure
			correct_result: Result = curr.is_null
		end

feature {NONE} -- Tree Forward Traversal

	next
		require
			not_open: not is_open
		do
				-- find the next open node
			from
			until
				curr.parent.is_open or else (curr.parent = root)
			loop
				curr := curr.parent
			end

				-- check which one of the two exit conditions was satisfied
			if curr.parent.is_open then
				curr.make (cea.null_cur, curr.parent)

					-- check for binary operations
				if curr.parent.is_binary_op then
					check (attached {BINARY_OP} curr.parent.node as binary_op) then
						binary_op.open_right
					end
				end
			else -- (curr.parent = root)
				curr := root
			end
		end

feature -- Adding

	add (e: EXPRESSION)
		require
			valid_argument: (e /= Void) and then (not e.is_null)
			valid_state: is_open or else (not e.is_const)
		do
			if is_open then
				if is_new_tree then
					is_new_tree := False

						-- update 'root'
					root.node := e

						-- update 'curr'
					if root.is_open then
						curr.make (cea.null_cur, root)
					else
						curr := root
					end
				else
						-- add the new expression
					curr.parent.add (e)

						-- update 'curr'
					curr.node := e

						-- curr.is_open = e.is_open
					if curr.is_open then
						create {ET_NODE} curr.make (cea.null_cur, curr)
					else
							-- is_open = curr.is_null = e.is_null
							-- and we know: not e.is_null
						next
					end
				end
			else
					-- at this point, we know that: (not is_open) and then (not e.is_const)

					-- add the old root expression to the given expression
					-- (i.e., make the given expression the root expression)
					-- and then update 'root'
				e.add (root.node)
				root.node := e

					-- update 'curr'
				if root.is_open then
					create {ET_NODE} curr.make (cea.null_cur, root)
				else
					curr := root
				end
			end
		end

feature -- Set Enumeration Queries

	specifying_set_enum: BOOLEAN
		do
			Result := is_open and then curr.parent.is_set_enum
		ensure
			correct_result: Result = (is_open and then curr.parent.is_set_enum)
		end

	is_open_set_enum: BOOLEAN
		require
			specifying_set_enum: specifying_set_enum
		do
			Result := curr.parent.is_open
		ensure
			correct_result: Result = curr.parent.is_open
		end

	is_empty_set_enum: BOOLEAN
		require
			specifying_set_enum: specifying_set_enum
		do
			check (attached {SET_ENUMERATION} curr.parent.node as set_enum) then
				Result := set_enum.is_empty
			end
		end

feature -- Set Enumeration Closure Command

	close_set_enum
		require
			specifying_set_enum: specifying_set_enum
		do
			check (attached {SET_ENUMERATION} curr.parent.node as set_enum) then
					-- close the current set enum
				set_enum.is_open := False

					-- update 'curr'
				curr.make (set_enum, curr.parent.parent)

					-- is_open = curr.is_null = set_enum.is_null
					-- and we know: not set_enum.is_null
				next
			end
		end

feature -- Output

	out: STRING
		do
			Result := root.out
		end

feature -- Visitor Pattern

	visit (v: VISITOR)
		require
			new_visitor: v.is_new
		do
			root.visit (v)
		ensure
			not_new_visitor: not v.is_new
		end

invariant
	open_vs_root_open_rec: is_open = root.is_open_rec
	new_tree_implies_open_and_diff_ptr_and_same_obj: is_new_tree implies (is_open and then (curr /= root) and then (curr ~ root))
	not_new_tree_implies_not_open_vs_same_ptr: (not is_new_tree) implies ((not is_open) = (curr = root))

end

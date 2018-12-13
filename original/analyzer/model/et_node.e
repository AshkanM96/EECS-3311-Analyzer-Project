note
	description: "Summary description for {ET_NODE}."
	author: "Ashkan Moatamed"

frozen class
	ET_NODE

inherit

	ANY
		redefine
			is_equal,
			out
		end

create {EXPRESSION_TREE}
	make_root, make

feature {ET_NODE, EXPRESSION_TREE} -- Pointer Attributes

	node: EXPRESSION assign set_node

	parent: ET_NODE

feature {EXPRESSION_TREE} -- Pointer Commands

	set_node (new_node: like node)
		require
			valid_node: new_node /= Void
		do
			node := new_node
		ensure
			correct_node: node = new_node
		end

feature -- Type Query

	is_root: BOOLEAN

feature {NONE} -- Root Constructor

	make_root (e: EXPRESSION)
		require
			valid_argument: e /= Void
		do
			node := e
			parent := Current
			is_root := True
		ensure
			correct_node: node = e
			root: is_root
		end

feature {EXPRESSION_TREE} -- Non-Root Constructor

	make (n: EXPRESSION; p: ET_NODE)
		require
			valid_node: n /= Void
			valid_parent: (p /= Void) and then (not p.is_null)
		do
			node := n
			parent := p
			is_root := False
		ensure
			correct_node: node = n
			correct_parent: parent = p
			not_root: not is_root
		end

feature -- Expression Type Queries

	is_null: BOOLEAN
		do
			Result := node.is_null
		ensure
			correct_result: Result = node.is_null
		end

	is_const: BOOLEAN
		do
			Result := node.is_const
		ensure
			correct_result: Result = node.is_const
		end

	is_binary_op: BOOLEAN
		do
			Result := node.is_binary_op
		ensure
			correct_result: Result = node.is_binary_op
		end

	is_unary_op: BOOLEAN
		do
			Result := node.is_unary_op
		ensure
			correct_result: Result = node.is_unary_op
		end

	is_set_enum: BOOLEAN
		do
			Result := node.is_set_enum
		ensure
			correct_result: Result = node.is_set_enum
		end

feature -- Expression State Queries

	is_new: BOOLEAN
		do
			Result := node.is_new
		ensure
			correct_result: Result = node.is_new
		end

	is_open: BOOLEAN
		do
			Result := node.is_open
		ensure
			correct_result: Result = node.is_open
		end

	is_open_rec: BOOLEAN
		do
			Result := node.is_open_rec
		ensure
			correct_result: Result = node.is_open_rec
		end

feature {EXPRESSION_TREE} -- Expression Adding

	add (e: EXPRESSION)
		require
			valid_argument: (e /= Void) and then (not e.is_null)
			open: is_open
		do
			node.add (e)
		end

feature -- Equality

	is_equal (other: like Current): BOOLEAN
		do
			if (Current = other) then
				Result := True
			elseif (is_root and then other.is_root) then
					-- two roots are equal if and only if their nodes are
				Result := (node ~ other.node)
			elseif (is_root or else other.is_root) then
					-- one root and one non-root can never be equal
				Result := False
			else
					-- a potential recursive call with parent ET_NODEs
				Result := (node ~ other.node) and then (parent ~ other.parent)
			end
		end

feature -- Output

	out: STRING
		do
			Result := node.out
		end

feature -- Expression Visitor Pattern

	visit (v: VISITOR)
		require
			new_visitor: v.is_new
		do
			node.visit (v)
		ensure
			not_new_visitor: not v.is_new
		end

invariant
	root_parent_relation: is_root = (parent = Current)

end

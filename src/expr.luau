local types = require("./types")
local expr = {}

export type Expression = types.Expression

function expr.ident(id: string): Expression
	return {
		type = "Identifier",
		value = id,
	}
end

function expr.index(value: Expression, index: Expression): Expression
	return {
		type = "Index",
		value = value,
		index = index,
	}
end

function expr.call(value: Expression, ...: Expression): Expression
	return {
		type = "Call",
		value = value,
		args = { ... },
	}
end

function expr.string(value: string): Expression
	return {
		type = "String",
		value = value,
	}
end

function expr.number(value: number): Expression
	return {
		type = "Number",
		value = value,
	}
end

function expr.binOp(lh: Expression, op: string, rh: Expression): Expression
	return {
		type = "BinOp",
		lh = lh,
		op = op,
		rh = rh,
	}
end

function expr.array(...: Expression): Expression
	return {
		type = "Array",
		values = { ... },
	}
end

function expr.dict(luaDict: { [Expression]: Expression }): Expression
	return {
		type = "Dictionary",
		pairs = luaDict,
	}
end

function expr.scope()
	local builder = {}
	local nodes: { types.Node } = {}

	function builder:expr(expr: Expression): typeof(builder)
		table.insert(nodes, {
			kind = "Expression",
			value = expr,
		})

		return builder
	end

	function builder:stmt(stmt: types.Statement): typeof(builder)
		table.insert(nodes, {
			kind = "Statement",
			value = stmt,
		})

		return builder
	end

	function builder:finish(): Expression
		return {
			type = "Scope",
			nodes = nodes,
		}
	end

	return builder
end

return expr

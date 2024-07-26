local types = require("./types")
local expr = {}

function expr.ident(id: string): types.EIdentifier
	return {
		type = "Identifier",
		value = id,
	}
end

function expr.index(value: types.Expression, index: types.Expression): types.EIndex
	return {
		type = "Index",
		value = value,
		index = index,
	}
end

function expr.call(value: types.Expression, ...: types.Expression): types.ECall
	return {
		type = "Call",
		value = value,
		args = { ... },
	}
end

function expr.string(value: string): types.EString
	return {
		type = "String",
		value = value,
	}
end

function expr.number(value: number): types.ENumber
	return {
		type = "Number",
		value = value,
	}
end

function expr.binOp(lh: types.Expression, op: string, rh: types.Expression): types.BinOp
	return {
		type = "BinOp",
		lh = lh,
		op = op,
		rh = rh,
	}
end

function expr.array(...: types.Expression): types.EArray
	return {
		type = "Array",
		values = { ... },
	}
end

function expr.dict(luaDict: { [types.Expression]: types.Expression }): types.EDictionary
	return {
		type = "Dictionary",
		pairs = luaDict,
	}
end

function expr.scope(): types.ScopeBuilder
	local builder = {}
	local nodes: { types.Node } = {}

	function builder:expr(expr: types.Expression): types.ScopeBuilder
		table.insert(nodes, {
			kind = "Expression",
			value = expr,
		})

		return builder
	end

	function builder:stmt(stmt: types.Statement): types.ScopeBuilder
		table.insert(nodes, {
			kind = "Statement",
			value = stmt,
		})

		return builder
	end

	function builder:finish(): types.EScope
		return {
			type = "Scope",
			nodes = nodes,
		}
	end

	return builder
end

function expr.funct(params: { types.Expression }, scope: types.EScope): types.EFunction
	return {
		type = "Function",
		params = params,
		scope = scope,
	}
end

return expr

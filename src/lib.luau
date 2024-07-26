local js = require("./init")
local types = require("./types")

export type Variable = {
	ident: types.EIdentifier | types.EIndex | types.ECall,
}

export type SupportedType = Variable | string | number | boolean | (inner: CodeBuilder) -> ()

local privateNodes: { [CodeBuilder]: { js.Node } } = {}
local lib = {}

local function expressionFromLuau(value: SupportedType): js.Expression
	if typeof(value) == "function" then
		local inner = lib.new()

		value(inner)

		return {
			type = "Function",
			scope = {
				type = "Scope",
				nodes = privateNodes[inner],
			},
			params = {
				"...",
			},
		}
	else
		local valueExpr = if typeof(value) == "table"
			then value.ident
			elseif typeof(value) == "string" then js.expr.string(value)
			elseif typeof(value) == "number" then js.expr.number(value)
			elseif typeof(value) == "boolean" then js.expr.bool(value)
			else nil

		assert(valueExpr)

		return valueExpr
	end
end

export type CodeBuilder = {
	var: (self: CodeBuilder, value: SupportedType) -> Variable,
	get: (self: CodeBuilder, path: string) -> Variable,
	callFunction: (self: CodeBuilder, var: Variable, ...SupportedType) -> Variable,
	setIndex: (self: CodeBuilder, var: Variable, path: string, value: SupportedType) -> (),
	build: (self: CodeBuilder) -> string,
}

function lib.new(): CodeBuilder
	local builder = {}
	local nodes: { js.Node } = {}
	local id = 0

	function builder:var(value: SupportedType): Variable
		local name = `var_{id}`
		id += 1

		local ident = js.expr.ident(name)
		local valueExpr = expressionFromLuau(value)

		table.insert(nodes, {
			kind = "Statement",
			value = js.stmt.declaration("let", js.expr.ident(name), valueExpr),
		})

		return {
			ident = ident,
		}
	end

	function builder:get(path: string): Variable
		local components = path:split(".")
		local ident: types.EIdentifier | types.EIndex = js.expr.ident(components[1])

		for i, component in components do
			if i == 1 then
				continue
			end

			ident = js.expr.index(ident, js.expr.string(component))
		end

		return {
			ident = ident,
		}
	end

	function builder:callFunction(var: Variable, ...: SupportedType): Variable
		local args = {}

		for _, value in { ... } do
			table.insert(args, expressionFromLuau(value))
		end

		local value = js.expr.call(var.ident, table.unpack(args))

		return {
			ident = value,
		}
	end

	function builder:setIndex(var: Variable, path: string, value: SupportedType)
		local index = builder:get(js.cgen.fromExpression(var.ident) .. "." .. path)

		table.insert(nodes, {
			kind = "Statement",
			value = js.stmt.assign(index.ident, expressionFromLuau(value)),
		})
	end

	function builder:build(): string
		return js.stringify(nodes)
	end

	privateNodes[builder] = nodes

	return builder
end

return lib

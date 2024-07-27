local js = require("../codegen/init")
local types = require("../codegen/types")

export type Ident = types.EIdentifier | types.EIndex | types.ECall

export type Variable = typeof(setmetatable(
	{} :: {
		_builder: CodeBuilder,
		ident: Ident,
		setMember: (self: Variable, path: string, value: SupportedType) -> (),
		getMember: (self: Variable, path: string) -> Variable,
	},
	{} :: {
		__call: (self: Variable, ...SupportedType) -> Variable,
	}
))

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

function lib._variable(builder, ident: Ident): Variable
	local variable = setmetatable({
		_builder = builder,
		ident = ident,
	}, lib._variableMT)

	function variable:setMember(path: string, value: SupportedType): ()
		local index = builder:get(js.cgen.fromExpression(variable.ident) .. "." .. path)

		table.insert(privateNodes[variable._builder], {
			kind = "Statement",
			value = js.stmt.assign(index.ident, expressionFromLuau(value)),
		})
	end

	function variable:getMember(path: string): Variable
		local index = builder:get(js.cgen.fromExpression(variable.ident) .. "." .. path)
		return variable._builder:var(index)
	end

	return variable
end

lib._variableMT = {
	__call = function(self: Variable, ...: SupportedType): Variable
		local args = {}

		for _, value in { ... } do
			table.insert(args, expressionFromLuau(value))
		end

		local value = js.expr.call(self.ident, table.unpack(args))

		return self._builder:var(lib._variable(self._builder, value))
	end,
}

export type CodeBuilder = {
	var: (self: CodeBuilder, value: SupportedType) -> Variable,
	get: (self: CodeBuilder, path: string) -> Variable,
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

		return lib._variable(builder, ident)
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

		return lib._variable(builder, ident)
	end

	function builder:build(): string
		return js.stringify(nodes)
	end

	privateNodes[builder] = nodes

	return builder
end

return lib

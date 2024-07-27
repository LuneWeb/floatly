local expr = require("./expr")
local stmt = require("./stmt")
local cgen = require("./codegen")
local types = require("./types")

export type Expression = types.Expression
export type Statement = types.Statement
export type Node = types.Node
export type ScopeBuilder = types.ScopeBuilder

return {
	expr = expr,
	stmt = stmt,
	cgen = cgen,
	stringify = function(nodes: { Node }): string
		local str = ""

		for _, node in nodes do
			if node.kind == "Expression" then
				str ..= cgen.fromExpression(node.value) .. "\n"
			elseif node.kind == "Statement" then
				str ..= cgen.fromStatement(node.value) .. "\n"
			end
		end

		return str
	end,
}

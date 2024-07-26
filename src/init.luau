local expr = require("./expr")
local stmt = require("./stmt")
local cgen = require("./codegen")

export type Expression = expr.Expression
export type Statement = stmt.Statement
export type Node = {
	kind: "Expression",
	value: Expression,
} | {
	kind: "Statement",
	value: Statement,
}

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

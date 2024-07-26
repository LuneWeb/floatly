local types = require("./types")
local cgen = {}

local function createBuffer()
	local buffer = {
		str = "",
		tabs = 0,
	}

	function buffer:append(str: string)
		buffer.str = buffer.str .. string.gsub(str, "\n", "\n" .. string.rep("\t", buffer.tabs))
	end

	return buffer
end

function cgen.fromStatement(stmt: types.Statement): string
	local buffer = createBuffer()

	if stmt.type == "Assign" then
		local assigning = cgen.fromExpression(stmt.assigning)
		local to = cgen.fromExpression(stmt.to)
		buffer:append(`{assigning} = {to}`)
	elseif stmt.type == "Declaration" then
		local ident = cgen.fromExpression(stmt.ident)
		local value = cgen.fromExpression(stmt.value)
		buffer:append(`{stmt.const and "const" or "let"} {ident} = {value}`)
	elseif stmt.type == "If" then
		for _, clause in stmt.clauses do
			if clause.type == "Else" then
				buffer:append(`else`)
				buffer:append(cgen.fromExpression(clause.scope))
			else
				buffer:append(
					`\n{clause.type == "If" and "if" or clause.type == "ElseIf" and "else if"} ({cgen.fromExpression(
						clause.condition
					)})`
				)
				buffer:append(cgen.fromExpression(clause.scope))
			end
		end
	end

	return buffer.str
end

function cgen.fromExpression(expr: types.Expression): string
	local buffer = createBuffer()

	if expr.type == "String" then
		buffer:append(`'{expr.value}'`)
	elseif expr.type == "Number" then
		buffer:append(`{expr.value}`)
	elseif expr.type == "Bool" then
		buffer:append(`{expr.value}`)
	elseif expr.type == "Identifier" then
		buffer:append(`{expr.value}`)
	elseif expr.type == "Index" then
		local value = cgen.fromExpression(expr.value)
		local index = cgen.fromExpression(expr.index)

		if expr.index.type == "Identifier" then
			buffer:append(`{value}.{index}`)
		else
			buffer:append(`{value}[{index}]`)
		end
	elseif expr.type == "Call" then
		local value = cgen.fromExpression(expr.value)

		buffer:append(`{value}(`)
		buffer.tabs += 1

		for _, arg in expr.args do
			buffer:append(`\n{cgen.fromExpression(arg)},`)
		end

		buffer.tabs -= 1
		buffer:append(`\n)`)
	elseif expr.type == "BinOp" then
		local lh = cgen.fromExpression(expr.lh)
		local rh = cgen.fromExpression(expr.rh)
		buffer:append(`{lh} {expr.op} {rh}`)
	elseif expr.type == "Array" then
		local nl = false

		if #expr.values > 3 then
			nl = true
		end

		buffer:append("{")

		for _, valueExpr in expr.values do
			local value = cgen.fromExpression(valueExpr)

			if nl then
				buffer:append(`\n\t{value},`)
			else
				buffer:append(`{value},`)
			end
		end

		if nl then
			buffer:append("\n}")
		else
			buffer:append("}")
		end
	elseif expr.type == "Dictionary" then
		buffer:append("{")

		for keyExpr, valueExpr in expr.pairs do
			local key = cgen.fromExpression(keyExpr)
			local value = cgen.fromExpression(valueExpr)

			buffer:append(`\n\t[{key}]: {value},`)
		end

		buffer:append("\n}")
	elseif expr.type == "Scope" then
		buffer:append("{")
		buffer.tabs += 1

		buffer:append("\n")

		for _, node in expr.nodes do
			if node.kind == "Expression" then
				buffer:append(cgen.fromExpression(node.value))
			elseif node.kind == "Statement" then
				buffer:append(cgen.fromStatement(node.value))
			end

			buffer:append(`\n`)
		end

		buffer.tabs -= 1
		buffer:append("\n}")
	elseif expr.type == "Function" then
		buffer:append("function(")

		for i, paramExpr: "..." | types.Expression in expr.params do
			local param

			if paramExpr == "..." then
				param = "...args"
			else
				param = cgen.fromExpression(paramExpr)
			end

			if i == #expr.params then
				buffer:append(`{param}`)
			else
				buffer:append(`{param}, `)
			end
		end

		buffer:append(")")
		buffer:append(cgen.fromExpression(expr.scope))
	end

	return buffer.str
end

return cgen

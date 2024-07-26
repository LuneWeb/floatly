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

function cgen.fromStatement(expr: types.Statement): string
	local buffer = createBuffer()

	if expr.type == "Assign" then
		local assigning = cgen.fromExpression(expr.assign)
		local to = cgen.fromExpression(expr.value)
		buffer:append(`{assigning} = {to}`)
	elseif expr.type == "Declaration" then
		local ident = cgen.fromExpression(expr.ident)
		local value = cgen.fromExpression(expr.value)
		buffer:append(`{expr.const and "const" or "let"} {ident} = {value}`)
	end

	return buffer.str
end

function cgen.fromExpression(expr: types.Expression): string
	local buffer = createBuffer()

	if expr.type == "String" then
		buffer:append(`'{expr.value}'`)
	elseif expr.type == "Number" then
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
	end

	return buffer.str
end

return cgen

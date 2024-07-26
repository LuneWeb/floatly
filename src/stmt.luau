local types = require("./types")
local stmt = {}

type Statement = types.Statement
type Expression = types.Expression

function stmt.assign(assigning: Expression, to: Expression): Statement
	return {
		type = "Assign",
		assigning = assigning,
		to = to,
	}
end

function stmt.declaration(type: "let" | "const", ident: Expression, value: Expression): Statement
	return {
		type = "Declaration",
		ident = ident,
		value = value,
		const = type == "const",
	}
end

return stmt

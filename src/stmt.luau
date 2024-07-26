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

function stmt.ifStmt(condition: Expression, scope: types.EScope): types.IfStmtBuilder
	local builder = {}
	local clauses: { types.IfStatementClause } = {
		{
			type = "If",
			condition = condition,
			scope = scope,
		},
	}

	function builder:elseIf(condition: Expression, scope: types.EScope): types.IfStmtBuilder
		table.insert(clauses, {
			type = "ElseIf",
			condition = condition,
			scope = scope,
		})

		return builder
	end

	function builder:else_(scope: types.EScope): types.IfStmtBuilder
		table.insert(clauses, {
			type = "Else",
			scope = scope,
		})

		return builder
	end

	function builder:finish(): types.Statement
		return {
			type = "If",
			clauses = clauses,
		}
	end

	return builder
end

return stmt

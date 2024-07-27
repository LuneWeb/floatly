local js = require("@codegen/init")
local expr = js.expr
local stmt = js.stmt

local printFunction = expr.index(expr.ident("console"), expr.ident("log"))
local printInfo = expr
	.scope()
	-- printing
	:expr(expr.call(
		printFunction,
		expr.string("Ashley"),
		expr.number(999),
		expr.dict({
			[expr.string("abc")] = expr.number(50),
			[expr.string("def")] = expr.number(-50),
		})
	))
	-- creating function
	:stmt(
		stmt.declaration(
			"const",
			expr.ident("testFunc"),
			expr.funct(
				{ expr.ident("arg1"), expr.ident("arg2") },
				expr.scope():expr(expr.call(printFunction, expr.ident("arg1"), expr.ident("arg2"))):finish()
			)
		)
	)
	-- if statement
	:stmt(
		stmt.ifStmt(
			expr.binOp(expr.ident("testFunc"), "!==", expr.ident("undefined")),
			expr.scope():expr(expr.call(expr.ident("testFunc"), expr.number(1), expr.number(2))):finish()
		)
			:else_(expr.scope():finish())
			:finish()
	)
	:finish()

print(js.stringify(printInfo.nodes))

local js = require("../src/init")
local expr = js.expr
local stmt = js.stmt

local printFunction = expr.index(expr.ident("console"), expr.ident("log"))
local printInfo = expr.scope()
	:expr(expr.call(
		printFunction,
		expr.string("Ashley"),
		expr.number(999),
		expr.dict({
			[expr.string("abc")] = expr.number(50),
			[expr.string("def")] = expr.number(-50),
		})
	))
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
	:finish()

print(js.stringify({
	{
		kind = "Expression",
		value = printInfo,
	},
}))

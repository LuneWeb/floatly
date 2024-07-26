local js = require("../src/init")
local expr = js.expr

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
	:finish()

print(js.stringify({
	{
		kind = "Expression",
		value = printInfo,
	},
}))

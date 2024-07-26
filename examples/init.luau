local js = require("../src/init")
local expr = js.expr

local printFunction = expr.index(expr.ident("console"), expr.ident("log"))
local printInfo = expr.call(printFunction, expr.string("Ashley"), expr.number(999), expr.number(-999))

print(js.stringify({
	{
		kind = "Expression",
		value = printInfo,
	},
}))

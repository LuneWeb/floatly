local js = require("../src/init")
local expr = js.expr
local stmt = js.stmt

local nodes: { js.Node } = {}
local createElement = expr.index(expr.ident("document"), expr.ident("createElement"))

table.insert(nodes, {
	kind = "Expression",
	value = expr.scope()
		:stmt(stmt.declaration("const", expr.ident("h1"), expr.call(createElement, expr.string("h1"))))
		:stmt(stmt.assign(expr.index(expr.ident("h1"), expr.ident("innerHTML")), expr.string("Hello, World!")))
		:finish(),
})

print(js.stringify(nodes))

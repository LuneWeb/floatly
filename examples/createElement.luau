local js = require("../src/init")
local expr = js.expr
local stmt = js.stmt

local nodes: { js.Node } = {}
local createElement = expr.index(expr.ident("document"), expr.ident("createElement"))

table.insert(nodes, {
	kind = "Statement",
	value = stmt.declaration("const", expr.ident("h1"), expr.call(createElement, expr.string("h1"))),
})

table.insert(nodes, {
	kind = "Statement",
	value = stmt.assign(expr.index(expr.ident("h1"), expr.ident("innerHTML")), expr.string("Hello, World!")),
})

print(js.stringify(nodes))

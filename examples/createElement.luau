local js = require("@codegen/init")
local expr = js.expr
local stmt = js.stmt

local nodes: { js.Node } = {}
local createElement = expr.index(expr.ident("document"), expr.ident("createElement"))
local body = expr.index(expr.ident("document"), expr.ident("body"))
local appendChild = expr.index(body, expr.ident("appendChild"))

table.insert(nodes, {
	kind = "Expression",
	value = expr.scope()
		:stmt(stmt.declaration("const", expr.ident("h1"), expr.call(createElement, expr.string("h1"))))
		:stmt(stmt.assign(expr.index(expr.ident("h1"), expr.ident("innerHTML")), expr.string("Hello, World!")))
		:expr(expr.call(appendChild, expr.ident("h1")))
		:finish(),
})

local window = WindowBuilder.new("Example", "about:blank")

window.message:listen(function(message)
	if message == "loaded" then
		window.webview:eval(js.stringify(nodes))
	end
end)

local floatly = require("../src/lib")

local code = floatly.new()
local name = code:var("name", "ashley")
local age = code:var("age", 17)
local log = code:get("console.log")

local printStuff = code:var("printStuff", function(inner)
	inner:callFunction(log, name, age)
end)

code:callFunction(printStuff)

print(code:build())

local floatly = require("../src/lib")

local code = floatly.new()
local createElement = code:get("document.createElement")
local title = code:var(code:callFunction(createElement, "h1"))

code:setIndex(title, "innerHTML", "Hello, World!")

print(code:build())

local floatly = require("../src/lib")

local code = floatly.new()

local createElement = code:get("document.createElement")
local body = code:get("document.body")
local title = createElement("h1")

title:setMember("innerHTML", "Hello, World!")
body:getMember("appendChild")(title)

print(code:build())

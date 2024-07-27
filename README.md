# FloatlyCodegen

This repo contains 2 libraries

## Codegen

```luau
require("./codegen/init.luau")
```

<ul>

Fully typed library for generating javascript code from AST nodes

This library is not recommended for writing javascript code manually
(e.g. using it to write more than 1 line of javascript code)

### Example

```luau
local createElement = expr.index(expr.ident("document"), expr.ident("createElement"))
stmt.declaration("const", expr.ident("h1"), expr.call(createElement, expr.string("h1")))
```

</ul>

## Floatly

```luau
require("./src/init.luau")
```

<ul>

This library abstracts away the complexity of the Codegen library, so it can be used
to write JavaScript code easily

### Example

```luau
local createElement = code:get("document.createElement")
local title = createElement("h1")
```

</ul>

## Features

- ⌨️ Fully typed in strict mode
- 🆓 Doesn't have any dependencies

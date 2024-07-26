export type Expression = {
	type: "Identifier",
	value: string,
} | {
	type: "Index",
	value: Expression,
	index: Expression,
} | {
	type: "Call",
	value: Expression,
	args: { Expression },
} | {
	type: "String",
	value: string,
} | {
	type: "Number",
	value: number,
} | {
	type: "BinOp",
	lh: Expression,
	op: string,
	rh: Expression,
} | {
	type: "Array",
	values: { Expression },
} | {
	type: "Dictionary",
	pairs: { [Expression]: Expression },
} | {
	type: "Scope",
	nodes: { Node },
} | {
	type: "Function",
	params: { Expression },
	scope: Expression,
}

export type Statement = {
	type: "Assign",
	assigning: Expression,
	to: Expression,
} | {
	type: "Declaration",
	const: boolean,
	ident: Expression,
	value: Expression,
}

export type Node = {
	kind: "Expression",
	value: Expression,
} | {
	kind: "Statement",
	value: Statement,
}

export type ScopeBuilder = {
	stmt: (self: ScopeBuilder, stmt: Statement) -> ScopeBuilder,
	expr: (self: ScopeBuilder, expr: Expression) -> ScopeBuilder,
	finish: (self: ScopeBuilder) -> Expression,
}

return {}

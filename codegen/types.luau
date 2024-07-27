export type EIdentifier = {
	type: "Identifier",
	value: string,
}

export type EIndex = {
	type: "Index",
	value: Expression,
	index: Expression,
}

export type ECall = {
	type: "Call",
	value: Expression,
	args: { Expression },
}

export type EString = {
	type: "String",
	value: string,
}

export type ENumber = {
	type: "Number",
	value: number,
}

export type EBool = {
	type: "Bool",
	value: boolean,
}

export type BinOp = {
	type: "BinOp",
	lh: Expression,
	op: string,
	rh: Expression,
}

export type EArray = {
	type: "Array",
	values: { Expression },
}

export type EDictionary = {
	type: "Dictionary",
	pairs: { [Expression]: Expression },
}

export type EScope = {
	type: "Scope",
	nodes: { Node },
}

export type EFunction = {
	type: "Function",
	params: { Expression | "..." },
	scope: Expression,
}

export type Expression =
	EIdentifier
	| EIndex
	| ECall
	| EString
	| ENumber
	| EBool
	| BinOp
	| EArray
	| EDictionary
	| EScope
	| EFunction

export type IfStatementClause =
	{ type: "If", condition: Expression, scope: EScope }
	| { type: "ElseIf", condition: Expression, scope: EScope }
	| { type: "Else", scope: EScope }

export type Statement = {
	type: "Assign",
	assigning: Expression,
	to: Expression,
} | {
	type: "Declaration",
	const: boolean,
	ident: Expression,
	value: Expression,
} | {
	type: "If",
	clauses: { IfStatementClause },
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
	finish: (self: ScopeBuilder) -> EScope,
}

export type IfStmtBuilder = {
	elseIf: (self: IfStmtBuilder, condition: Expression, scope: EScope) -> IfStmtBuilder,
	else_: (self: IfStmtBuilder, scope: EScope) -> IfStmtBuilder,
	finish: (self: IfStmtBuilder) -> Statement,
}

return {}

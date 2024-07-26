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
}

export type Statement = {
	type: "Assign",
	value: Expression,
	assign: Expression,
} | {
	type: "Declaration",
	const: boolean,
	ident: Expression,
	value: Expression,
}

return {}

{
	const defaultTarget = {
		type: "target",
		mod: "=",
		value: {
			type: "number",
			value: 1,
		},
	}

	const defaultExpression = {
		type: "number",
		value: 1,
	}
}

start = expr:Expression label:(.*) {
	expr.root = true;

	if (label) {
		expr.label = label.join("");
	}

	return expr;
}

InlineExpression = "[[" expr:Expression "]]" {
	return {
		type: "inline",
		expr,
	}
}

AnyRoll = roll:(ModGroupedRoll / FullRoll / Integer) _ label:Label? {
	if (label) {
		roll.label = label;
	}

	return roll;
}

ModGroupedRoll = group:GroupedRoll mods:(KeepMod / DropMod / SuccessMod / FailureMod)* _ label:Label? {
	if (mods.length > 0) {
		group.mods = (group.mods || []).concat(mods);
	}

	if (label) {
		group.label = label;
	}

	return group;
}

SuccessMod = mod:(">"/"<"/"=") expr:RollExpr {
	return {
		type: "success",
		mod,
		expr,
	}
}

FailureMod = ("f" / "п") mod:(">"/"<"/"=")? expr:RollExpr {
	return {
		type: "failure",
		mod,
		expr,
	}
}

CriticalSuccessMod = ("cs" / "ку") mod:(">"/"<"/"=")? expr:RollExpr {
	return {
		type: "crit",
		mod,
		expr,
	}
}

CriticalFailureMod = ("cf" / "кп") mod:(">"/"<"/"=")? expr:RollExpr {
	return {
		type: "critfail",
		mod,
		expr,
	}
}

MatchTarget = mod:(">"/"<"/"=") expr:RollExpr {
	return {
		mod,
		expr,
	}
}

MatchMod = op:("mt" / "m" / "совпк" / "совп") min:Integer? target: MatchTarget? {
	const isCount = op === "mt" || op === "совпк";
	const match = {
		type: "match",
		min: min || { type: "number", value: 2 },
		count: isCount,
	}

	if (target) {
		match.mod = target.mod;
		match.expr = target.expr;
	}

	return match;
}

KeepMod = ("k" / "в") highlow:("l" / "h" / "л" / "х")? expr:RollExpr? {
    let normalizedHighLow = highlow;
    if (highlow === "л") normalizedHighLow = "h";
    if (highlow === "х") normalizedHighLow = "l";

	return {
		type: "keep",
		highlow: normalizedHighLow,
		expr: expr || defaultExpression,
	}
}

DropMod = op:("dh" / "dl" / "d" / "уб" / "ул" / "ух") expr:RollExpr? {
  let highlow = null;
  if (op === "dh" || op === "ул") highlow = "h";
  if (op === "dl" || op === "ух") highlow = "l";
  return { type: "drop", highlow, expr: expr || defaultExpression };
}

GroupedRoll = "{" _ head:(RollExpression) tail:(_ "," _ (RollExpression))* _ "}" {
	return {
		rolls: [head, ...tail.map((el) => el[3])],
		type: "group",
	}
}

RollExpression = head:RollOrExpression tail:(_ ("+") _ RollOrExpression)* {
	if (tail.length == 0) {
		return head;
	}

	const ops = tail
		.map((element) => ({
			type: "math",
			op: element[1],
			tail: element[3]
		}));

	return {
		head: head,
		type: "diceExpression",
		ops,
	};
}

RollOrExpression = FullRoll / Expression

FullRoll = roll:TargetedRoll _ label:Label? {
	if (label) {
		roll.label = label;
	}

	return roll;
}

TargetedRoll = head:RolledModRoll mods:(DropMod / KeepMod / SuccessMod / FailureMod / CriticalFailureMod / CriticalSuccessMod)* match:MatchMod? sort:(SortMod)? {
	const targets = mods.filter((mod) => ["success", "failure"].includes(mod.type));
	mods = mods.filter((mod) => !targets.includes(mod));

	head.mods = (head.mods || []).concat(mods);

	if (targets.length > 0) {
		head.targets = targets;
	}

	if (match) {
		head.match = match;
	}

	if (sort) {
		head.sort = sort;
	}

	return head;
}

SortMod = ("s" / "с") dir:("a" / "d" / "в" / "у")? {
	if(dir == "d" || dir == "у"){
		return {
			type: "sort",
			asc: false
		}
	}
	return {
		type: "sort",
		asc: true
	}
}

RolledModRoll = head:DiceRoll tail:(CompoundRoll / PenetrateRoll / ExplodeRoll / ReRollOnceMod / ReRollMod)* {
	head.mods = (head.mods || []).concat(tail);
	return head;
}

ExplodeRoll = "!" target:TargetMod? {
	return {
		type: "explode",
		target,
	}
}

CompoundRoll = "!!" target:TargetMod? {
	return {
		type: "compound",
		target,
	}
}

PenetrateRoll = ("!p" / "!п") target:TargetMod? {
	return {
		type: "penetrate",
		target,
	}
}

ReRollMod = ("r" / "пб") target:TargetMod? {
	target = target || defaultTarget;

	return {
		type: "reroll",
		target,
	}
}

ReRollOnceMod = ("ro" / "пр") target:TargetMod? {
	target = target || defaultTarget;

	return {
		type: "rerollOnce",
		target,
	}
}

TargetMod = mod:(">"/"<"/"=")? value:RollExpr {
	return {
		type: "target",
		mod,
		value,
	}
}

DiceRoll = FateRoll / StandardDiceRoll

FateRoll = head:RollExpr? op:("dF" / "df" / "кС" / "кс") {
	return {
		die: { type: "fate" },
		count: head || { type: "number", value: 1 },
		type: "die"
	}
}

StandardDiceRoll = head:RollExpr? ("d" / "к") tail:(PercentExpr / RollExpr) {
	head = head ? head : { type: "number", value: 1 };

	return {
		die: tail,
		count: head,
		type: "die"
	};
}

PercentExpr = ("%") {
	return {
		type: "number",
		value: "100",
	}
}

RollExpr = BracketExpression / Integer;

Expression = InlineExpression / AddSubExpression / BracketExpression;

BracketExpression = "(" expr:AddSubExpression ")" _ label:Label? {
	if (label) {
		expr.label = label;
	}

	return expr;
}

AddSubExpression = head:MultDivExpression tail:(_ ("+" / "-") _ MultDivExpression)* {
	if (tail.length == 0) {
		return head;
	}

	const ops = tail
		.map((element) => ({
			type: "math",
			op: element[1],
			tail: element[3],
		}));

	return {
		head,
		type: "expression",
		ops,
	};
}

MultDivExpression = head:ModExpoExpression tail:(_ ("*" / "/") _ ModExpoExpression)* {
	if (tail.length == 0) {
		return head;
	}

	const ops = tail
		.map((element) => ({
			type: "math",
			op: element[1],
			tail: element[3],
		}));

	return {
		head,
		type: "expression",
		ops,
	};
}

ModExpoExpression = head:FunctionOrRoll tail:(_ ("**" / "%") _ FunctionOrRoll)* {
	if (tail.length == 0) {
		return head;
	}

	const ops = tail
		.map((element) => ({
			type: "math",
			op: element[1],
			tail: element[3],
		}));

	return {
		head,
		type: "expression",
		ops,
	};
}

MathFunction = op:("floor" / "ceil" / "round" / "abs" / "низ" / "верх" / "окр" / "мод") {
    switch (op) {
        case "низ": return "floor";
        case "верх": return "ceil";
        case "окр": return "round";
        case "мод": return "abs";
        default: return op;
    }
}

MathFnExpression = op:MathFunction _ "(" _ expr:AddSubExpression _ ")" {
	return {
		type: "mathfunction",
		op,
		expr
	};
}

FunctionOrRoll = MathFnExpression / AnyRoll / BracketExpression

Integer "integer" = "-"? [0-9]+ {
	const num = parseInt(text(), 10);
	return {
		type: "number",
		value: num,
	}
}

Label = "[" label:([^\]]+) "]" {
	return label.join("")
}

_ "whitespace"
	= [ \t\n\r]*

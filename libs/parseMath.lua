--[[
(...) - All between brackets will be evaluated recursively
<Function_Name>[<Argument1>, <Argument2>; <Argument3>] - Then any functions will be evaluated. Note: there is no space between <Function_Name> and [, but other whitespace characters are ignored.
pow[ a, b ] - Raises a to the exponent of b;
sqrt[ a ] - Calculates square root out of a;
abs[ a ] - Returns non-negative representation of a;
sin[ a ] - Returns sine of a;
cos[ a ] - Returns cosine of a;
tan[ a ] - Returns tangent of a;
log[ a ] - Returns natural logarithm of a;
log10[ a ] - Returns ten-based logarithm of a;
pi[] - Returns pi number;
floor[ a ] - Returns floor-rounded representation of a;
ceil[ a ] - Returns ceil-rounded representation of a;
rad[ a ] - Returns converted to radians a;
deg[ a ] - Returns converted to degrees a;
bits[ a, b ] - Casts a to b amount of bits;
bit[ a ] - Casts a to one bit;
byte[ a ] - Casts a to one byte;
word[ a ] - Casts a to two bytes;
int[ a ] - Casts a to four bytes;
Logical operators, all operators are bit-based (All is shown in priority decreasing order)
not a - NOT operator;
~a - NOT operator (C-style);
a and b - AND operator;
a & b - AND operator (C-style);
a or b - OR operator;
a | b - OR operator (C-style);
a xor b - XOR operator;
a ~^ b - XOR operator (C-style);
a shl b - Shift Left operator;
a << b - Shift Left operator (C-style);
a shr b - Shift Right operator;
a >> b - Shift Right operator (C-style);
a ** b/a ^ b - Exponential operator: Raises a to the exponent of b. Same as pow[ a, b ];
Integer division operators:
a div b - DIV operator;
a // b - DIV operator (C-style);
Modulus operators:
a mod b - MOD operator;
a % b - MOD operator (C-style);
Arithmetic operators:
a * b - Multiplication operator
a / b - Division operator
a + b - Sum operator
a - b - Subtraction operator
Equality operators (return 1 if equal, 0 otherwise):
a = b - Equality operator;
a == b - Equality operator (C-style);
Boolean logic operators
!a - NOT operator
a && b - AND operator
a || b - OR operator
a !^ b - XOR operator
Constants
$pi = math.pi;
$e = math.exp(1);
Usage example
floor[ sqrt[ pow[ 2, log[ 154 ] ] ] ] - Useless math
sqrt[ 3**2 + 4**2 ] - Pythagoras rule
(238 && 156) == (238 and 156) - Test logic
((238 && 156) == (238 and 156)) << (2 xor 1) = ((154 || 12) == (154 or 12)) shl (1 ^ 2) - Advanced logic test
((23 ** 2 div 2) == (23 ** 2 // 2)) && (((15 mod 2 << 1) >> 2) == ((15 % 2 shl 1) shr 2)) - Logic and arithmetics
]]


local main = {}
local bit = require("bit") or require("bit32")

local function newMask(...)
	local args = {...}
	return format(rep("%s", #args), unpack(args))
end

main.numberMask = newMask("%-?%d+%.?%d*")

main.exponentMask = newMask(main.numberMask, "%s-%*%*%s-", main.numberMask)
main.luaExponentialMask = newMask(main.numberMask, "%s-%^%s-", main.numberMask)

main.divMask = newMask(main.numberMask, "%s+div%s+", main.numberMask)
main.modMask = newMask(main.numberMask, "%s+mod%s+", main.numberMask)
main.divMaskC = newMask(main.numberMask, "%s-%/%/%s-", main.numberMask)
main.modMaskC = newMask(main.numberMask, "%s-%%%s-", main.numberMask)

main.multiplyMask = newMask(main.numberMask, "%s-%*%s-", main.numberMask)
main.divideMask = newMask(main.numberMask, "%s-%/%s-", main.numberMask)
main.addMask = newMask(main.numberMask, "%s-%+%s-", main.numberMask)
main.subtractMask = newMask(main.numberMask, "%s-%-%s-", main.numberMask)

main.andMask = newMask(main.numberMask, "%s+and%s+", main.numberMask)
main.orMask = newMask(main.numberMask, "%s+or%s+", main.numberMask)
main.xorMask = newMask(main.numberMask, "%s+xor%s+", main.numberMask)
main.shlMask = newMask(main.numberMask, "%s+shl%s+", main.numberMask)
main.shrMask = newMask(main.numberMask, "%s+shr%s+", main.numberMask)
main.equalMask = newMask(main.numberMask, "%s-%=%s-", main.numberMask)
main.notMask = newMask("not%s+", main.numberMask)

main.andMaskC = newMask(main.numberMask, "%s-&%s-", main.numberMask)
main.orMaskC = newMask(main.numberMask, "%s-|%s-", main.numberMask)
main.xorMaskC = newMask(main.numberMask, "%s-~^%s-", main.numberMask)
main.shlMaskC = newMask(main.numberMask, "%s-<<%s-", main.numberMask)
main.shrMaskC = newMask(main.numberMask, "%s->>%s-", main.numberMask)
main.equalMaskC = newMask(main.numberMask, "%s-%=%=%s-", main.numberMask)
main.notMaskC = newMask("~%s-", main.numberMask)

main.boolAndMaskC = newMask(main.numberMask, "%s-&&%s-", main.numberMask)
main.boolOrMaskC = newMask(main.numberMask, "%s-||%s-", main.numberMask)
main.boolXorMaskC = newMask(main.numberMask, "%s-!%^%s-", main.numberMask)
main.boolNotMaskC = newMask("!%s-", main.numberMask)

main.functionMask = "%w[%w%d_]*%b[]"

function main.extractNumbers(text)
	local result = {}

	for cap in gmatch(text, main.numberMask) do
		local num = tonumber(cap)

		if num then
			insert(result, num)
		else
			printf("Could not transform number: %s", cap)
		end
	end

	return result
end

function main.resolve(text)
	return gsub(text, main.functionMask,
		function(text)
			local name = ""

			for word in gmatch(text, "%w+") do
				name = word
				break
			end

			local equat = ""
			local result = {}

			for equat in gmatch(text, "%b[]") do
				equat = sub(equat, 2, - 2)

				local arg = ""
				local opd = 0

				while len(equat) > 0 do
					local c = sub(equat, 1, 1) -- Char
					equat = sub(equat, 2)

					if (c == "," or c == ",") and opd == 0 then
						insert(result, processEquation(arg))
						arg = ""
					else
						if c == "[" then
							opd = opd + 1
							arg = format("%s%s", arg, c)
						elseif c == "]" then
							opd = opd + 1
							arg = format("%s%s", arg, c)
						else
							arg = format("%s%s", arg, c)
						end
					end
				end

				insert(result, processEquation((arg == "") and "0" or arg))
				break
			end

			local args = result

			if name == "sqrt" then
				return sqrt(args[1])
			elseif name == "pow" then
				return pow(args[1], args[2])
			elseif name == "abs" then
				return abs(args[1])
			elseif name == "sin" then
				return sin(args[1])
			elseif name == "cos" then
				return cos(args[1])
			elseif name == "tan" then
				return tan(args[1])
			elseif name == "log" then
				return log(args[1])
			elseif name == "log10" then
				return log10(args[1])
			elseif name == "pi" then
				return pi * args[1] or 1
			elseif name == "floor" then
				return floor(args[1])
			elseif name == "ceil" then
				return ceil(args[1])
			elseif name == "rad" then
				return rad(args[1])
			elseif name == "deg" then
				return deg(args[1])
			else
				return format("Unknown function: %s", name)
			end
		end
	)
end

local constants = {
	['$pi'] = pi,
	['$e'] = exp(1),
}

function replaceConstants(text)
	local mask = newMask(" ", text, " ")
	local replaced = gsub(mask, "(%$%w+)", constants)

	return replaced:sub(2, - 2)
end

function main.DIV(text)
	return gsub(text, main.divMask,
		function(c)
			local arg = main.extractNumbers(c)
			return floor(arg[1] / arg[2])
		end
	)
end

function main.MOD(text)
	return gsub(text, main.modMask,
		function(c)
			local arg = main.extractNumbers(c)
			return (arg[1] % arg[2])
		end
	)
end

function main.DIVC(text)
	return gsub(text, main.divMaskC,
		function(c)
			local arg = main.extractNumbers(c)
			return (math.floor(arg[1] / arg[2]))
		end
	)
end

function main.exp(text)
	return gsub(text, main.exponentMask,
		function(c)
			local arg = main.extractNumbers(c)
			return (math.pow(arg[1], arg[2]))
		end
	)
end

function main.luaExp(text)
	return gsub(text, main.luaExponentialMask,
		function(c)
			local arg = main.extractNumbers(c)
			return math.pow(arg[1], arg[2])
		end
	)
end

function main.modc(text)
	return gsub(text, main.modMaskC,
		function(c)
			local arg = main.extractNumbers(c)
			return (arg[1] % arg[2])
		end
	)
end

function main.AND(text)
	return gsub(text, main.andMask,
		function(c)
			local arg = main.extractNumbers(c)
			return (bit.band(arg[1], arg[2]))
		end
	)
end

function main.OR(text)
	return gsub(text, main.orMask,
		function(c)
			local arg = main.extractNumbers(c)
			return (bit.bor(arg[1], arg[2]))
		end
	)
end

function main.XOR(text)
	return gsub(text, main.xorMask,
		function(c)
			local arg = main.extractNumbers(c)
			return (bit.bxor(arg[1], arg[2]))
		end
	)
end

function main.NOT(text)
	return gsub(text, main.notMask,
		function(c)
			local arg = main.extractNumbers(c)
			return (bit.bnot(arg[1]))
		end
	)
end

function main.shl(text)
	return gsub(text, main.shlMask,
		function(c)
			local arg = main.extractNumbers(c)
			return (bit.lshift(arg[1], arg[2]))
		end
	)
end

function main.shr(text)
	return gsub(text, main.shrMask,
		function(c)
			local arg = main.extractNumbers(c)
			return (bit.rshift(arg[1], arg[2]))
		end
	)
end

function main.equal(text)
	return gsub(text, main.equalMask,
		function(c)
			local arg = main.extractNumbers(c)
			return ((arg[1] == arg[2]) and 1 or 0)
		end
	)
end

function main.andC(text)
	return gsub(text, main.andMaskC,
		function(c)
			local arg = main.extractNumbers(c)
			return (bit.band(arg[1], arg[2]))
		end
	)
end

function main.boolAndC(text)
	return gsub(text, main.boolAndMaskC,
		function(c)
			local arg = main.extractNumbers(c)
			return ((arg[1] ~= 0) and (arg[2] ~= 0)) and 1 or 0
		end
	)
end

function main.orC(text)
	return gsub(text, main.orMaskC,
		function(c)
			local arg = main.extractNumbers(c)
			return (bit.bor(arg[1], arg[2]))
		end
	)
end

function main.boolOrC(text)
	return gsub(text, main.boolOrMaskC,
		function(c)
			local arg = main.extractNumbers(c)
			return ((arg[1] ~= 0) or (arg[2] ~= 0)) and 1 or 0
		end
	)
end

function main.xorC(text)
	return gsub(text, main.xorMaskC,
		function(c)
			local arg = main.extractNumbers(c)
			return (bit.bxor(arg[1], arg[2]))
		end
	)
end

function main.boolXorC(text)
	return gsub(text, main.boolXorMaskC,
		function(c)
			local arg = main.extractNumbers(c)
			return ((arg[1] ~= 0) ~= (arg[2] ~= 0)) and 1 or 0
		end
	)
end

function main.notC(text)
	return gsub(text, main.notMaskC,
		function(c)
			local arg = main.extractNumbers(c)
			return (bit.bnot(arg[1]))
		end
	)
end

function main.boolNotC(text)
	return gsub(text, main.boolNotMaskC,
		function(c)
			local arg = main.extractNumbers(c)
			return (not (arg[1] ~= 0)) and 1 or 0,
		end
	)
end

function main.shlC(text)
	return gsub(text, main.shlMaskC,
		function(c)
			local arg = main.extractNumbers(c)
			return (bit.lshift(arg[1], arg[2]))
		end
	)
end

function main.shrC(text)
	return gsub(text, main.shrMaskC,
		function(c)
			local arg = main.extractNumbers(c)
			return (bit.rshift(arg[1], arg[2]))
		end
	)
end

function main.equalC(text)
	return gsub(text, main.equalMaskC,
		function(c)
			local arg = main.extractNumbers(c)
			return ((arg[1] == arg[2]) and 1 or 0)
		end
	)
end

function main.multiply(text)
	return gsub(text, main.multiplyMask,
		function(c)
			local arg = main.extractNumbers(c)
			return (arg[1] * arg[2])
		end
	)
end

function main.divide(text)
	return gsub(text, main.divideMask,
		function(c)
			local arg = main.extractNumbers(c)
			return (arg[1] / arg[2])
		end
	)
end

function main.add(text)
	return gsub(text, main.addMask,
		function(c)
			local arg = main.extractNumbers(c)
			return (arg[1] + arg[2])
		end
	)
end

function main.subtract(text)
	return gsub(text, main.subtractMask,
		function(c)
			local arg = main.extractNumbers(c)
			return (arg[1] - arg[2])
		end
	)
end

function main.calculate(text)
	local num = main.replaceConstants(text)
	local count = 0
	local prefixed = {
		main.not,
		main.notc,
		main.boolNotC,
	},

	repeat
		num, count = main.resolve(num)
	until (count == 0) or not count

	local used = {}
	local len = #prefixed

	while true do
		for i = 1, len do
			used[i] = 0
		end

		local count = 0

		for i = 1, len do
			repeat
				num, count = prefixed[i](num)
				used[i] = used[i] + (count or 0)
			until not count or (count == 0)
		end

		local check = true
		for i = 1, len do
			if not (used[i] == 0) then
				check = false
				break
			end
		end
		if check then
			break
		end
	end

	local arg = {
		main.and,
		main.andC,

		main.or,
		main.orC,

		main.xor,
		main.xorC,

		main.shl,
		main.shlC,
		main.shr,
		main.shrC,

		main.exp,
		main.luaExp,

		main.div,
		main.divC,
		main.mod,
		main.modC,

		main.multiply,
		main.divide,
		main.add,
		main.subtract,

		main.equal,
		main.equalC,

		main.boolAndC,
		main.boolOrC,
		main.boolXorC,
	}

	for i = 1, #arg do
		repeat
			num, count = arg[i](num)
		until (count == 0) or (not count)
	end

	return tonumber(num) or error('Invalid number: ' .. num)
end

function main.processEquation(equa)
	local frms = equa:gsub('%b()',
		function(text)
			return main.processEquation(text:sub(2, - 2))
		end
	)
	return main.calculate(frms)
end

main.evaluate = main.processEquation
main.eval = main.processEquation

local eval = main.eval
local res = eval("((238 && 156) == (238 and 156)) << (2 xor 1) = ((154 || 12) == (154 or 12)) shl (1 ^ 2)")
print(res)

return main

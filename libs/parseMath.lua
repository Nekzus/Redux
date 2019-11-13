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

main.resolveFunctionMask = "%w[%w%d_]*%b[]"

function main.extractNumbers(text)
	local result = {}

	for n in gmatch(text, main.numberMask) do
		insert(result, tonumber(n) or format("Could not transform number: %s", cap))
	end

	return result
end

function main.resolveString(text)
	return gsub(text, main.resolveFunctionMask,
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

					if (c == "," or c == ";") and opd == 0 then
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

function main["div"](text)
	return gsub(text, main.divMask,
		function(s)
			local arg = main.extractNumbers(s)
			return floor(arg[1] / arg[2])
		end
	)
end

function main["mod"](text)
	return gsub(text, main.modMask,
		function(s)
			local args = main.extractNumbers(s)
			return args[1] % args[2]
		end
	)
end

function main["divC"](text)
	return gsub(text, main.divMaskC,
		function(s)
			local args = main.extractNumbers(s)
			return floor(args[1] / args[2])
		end
	)
end

function main["exp"](text)
	return gsub(text, main.exponentMask,
		function(s)
			local args = main.extractNumbers(s)
			return pow(args[1], args[2])
		end
	)
end

function main["luaExp"](text)
	return gsub(text, main.luaExponentialMask,
		function(s)
			local args = main.extractNumbers(s)
			return pow(args[1], args[2])
		end
	)
end

function main["modC"](text)
	return gsub(text, main.modMaskC,
		function(s)
			local args = main.extractNumbers(s)
			return args[1] % args[2]
		end
	)
end

function main["and"](text)
	return gsub(text, main.andMask,
		function(s)
			local args = main.extractNumbers(s)
			return bit.band(args[1], args[2])
		end
	)
end

function main["or"](text)
	return gsub(text, main.orMask,
		function(s)
			local args = main.extractNumbers(s)
			return bit.bor(args[1], args[2])
		end
	)
end

function main["xor"](text)
	return gsub(text, main.xorMask,
		function(s)
			local args = main.extractNumbers(s)
			return bit.bxor(args[1], args[2])
		end
	)
end

function main["not"](text)
	return gsub(text, main.notMask,
		function(s)
			local args = main.extractNumbers(s)
			return bit.bnot(args[1])
		end
	)
end

function main["shl"](text)
	return gsub(text, main.shlMask,
		function(s)
			local args = main.extractNumbers(s)
			return bit.lshift(args[1], args[2])
		end
	)
end

function main["shr"](text)
	return gsub(text, main.shrMask,
		function(s)
			local args = main.extractNumbers(s)
			return bit.rshift(args[1], args[2])
		end
	)
end

function main["equal"](text)
	return gsub(text, main.equalMask,
		function(s)
			local args = main.extractNumbers(s)
			return (args[1] == args[2]) and 1 or 0
		end
	)
end

function main["andC"](text)
	return gsub(text, main.andMaskC,
		function(s)
			local args = main.extractNumbers(s)
			return bit.band(args[1], args[2])
		end
	)
end

function main["boolAndC"](text)
	return gsub(text, main.BoolANDMaskC,
		function(s)
			local args = main.extractNumbers(s)
			return (((args[1] ~= 0) and (args[2] ~= 0)) and 1) or 0
		end
	)
end

function main["orC"](text)
	return gsub(text, main.orMaskC,
		function(s)
			local args = main.extractNumbers(s)
			return bit.bor(args[1], args[2])
		end
	)
end

function main["boolOrC"](text)
	return gsub(text, main.boolOrMaskC,
		function(s)
			local args = main.extractNumbers(s)
			return ((args[1] ~= 0) or (args[2] ~= 0)) and 1 or 0
		end
	)
end

function main["xorC"](text)
	return gsub(text, main.xorMaskC,
		function(s)
			local args = main.extractNumbers(s)
			return bit.bxor(args[1], args[2])
		end
	)
end

function main["boolXorC"](text)
	return gsub(text, main.boolXorMaskC,
		function(s)
			local args = main.extractNumbers(s)
			return ((args[1] ~= 0) ~= (args[2] ~= 0)) and 1 or 0
		end
	)
end

function main["notC"](text)
	return gsub(text, main.notMaskC,
		function(s)
			local args = main.extractNumbers(s)
			return bit.bnot(args[1])
		end
	)
end

function main["boolNotC"](text)
	return gsub(text, main.boolNotMaskC,
		function(s)
			local args = main.extractNumbers(s)
			return (not (args[1] ~= 0)) and 1 or 0
		end
	)
end

function main["shlC"](text)
	return gsub(text, main.shlMaskC,
		function(s)
			local args = main.extractNumbers(s)
			return bit.lshift(args[1], args[2])
		end
	)
end

function main["shrC"](text)
	return gsub(text, main.shrMaskC,
		function(s)
			local args = main.extractNumbers(s)
			return bit.rshift(args[1], args[2])
		end
	)
end

function main["equalC"](text)
	return gsub(text, main.equalMaskC,
		function(s)
			local args = main.extractNumbers(s)
			return (args[1] == args[2]) and 1 or 0
		end
	)
end

function main["multiply"](text)
	return gsub(text, main.multiplyMask,
		function(s)
			local args = main.extractNumbers(s)
			return args[1] * args[2]
		end
	)
end

function main["divide"](text)
	return gsub(text, main.divideMask,
		function(s)
			local args = main.extractNumbers(s)
			return args[1] / args[2]
		end
	)
end

function main["add"](text)
	return gsub(text, main.addMask,
		function(s)
			local args = main.extractNumbers(s)
			return args[1] + args[2]
		end
	)
end

function main["subtract"](text)
	return gsub(text, main.subtractMask,
		function(s)
			local args = main.extractNumbers(s)
			return args[1] - args[2]
		end
	)
end

function main.calculate(text)
	local num = main.replaceConstants(text)
	local count = 0
	local used = {}
	local prefixed = {
		main["not"],
		main["notC"],
		main["boolNotC"],
	}
	local len = #prefixed

	repeat
		num, count = main.resolveString(num)
	until count == 0 or not count

	while true do
		for i = 1, len do used[i] = 0; end

		local prefixCount = 0;
		for i = 1, len do
			repeat
				num, prefixCount = prefixed[i](num)
				used[i] = used[i] + (prefixCount or 0)
			until not prefixCount or (prefixCount == 0)
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

	local args = {
		main["and"],
		main["andC"],

		main["or"],
		main["orC"],

		main["xor"],
		main["xorC"],

		main["shl"],
		main["shlC"],
		main["shr"],
		main["shrC"],

		main["exp"],
		main["luaExp"],

		main["div"],
		main["divC"],
		main["mod"],
		main["modC"],

		main["multiply"],
		main["divide"],
		main["add"],
		main["subtract"],

		main["equal"],
		main["equalC"],

		main["boolAndC"],
		main["boolOrC"],
		main["boolXorC"],
	}

	for i = 1, #args do
		repeat
			num, count = args[i](num)
		until (count == 0) or (not count)
	end

	return tonumber(num) or format("Invalid number: %s", num)
end

function main.processEquation(equation)
	local formulas = gsub(equation, '%b()',
		function(text)
			return main.processEquation(sub(text, 2, - 2))
		end
	)

	return main.calculate(formulas)
end

main.evaluate = main.processEquation
main.eval = main.processEquation

return main

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

function main.resolveString(text)
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

function main.div(text)
	return gsub(text, main.divMask,
		function(c)
			local arg = main.extractNumbers(c)
			return floor(arg[1] / arg[2])
		end
	)
end

function main.DIV(str)
	return str:gsub(main.divMask,
		function(s)
			local Arr = main.ExtractNumbers(s);
			return (math.floor(Arr[1] / Arr[2]));
	end);
end;

function main.MOD(str)
	return str:gsub(main.ModMask,
		function(s)
			local Arr = main.ExtractNumbers(s);
			return (Arr[1] % Arr[2]);
	end);
end;

function main.DIVC(str)
	return str:gsub(main.DivMaskC,
		function(s)
			local Arr = main.ExtractNumbers(s);
			return (math.floor(Arr[1] / Arr[2]));
	end);
end;

function main.EXP(str)
	return str:gsub(main.ExponentMask,
		function(s)
			local Arr = main.ExtractNumbers(s);
			return (math.pow(Arr[1], Arr[2]));
	end);
end;

function main.LuaEXP(str)
	return str:gsub(main.LuaExponentialMask,
		function(s)
			local Arr = main.ExtractNumbers(s);
			return math.pow(Arr[1], Arr[2]);
	end);
end;

function main.MODC(str)
	return str:gsub(main.ModMaskC,
		function(s)
			local Arr = main.ExtractNumbers(s);
			return (Arr[1] % Arr[2]);
	end);
end;

function main.AND(str)
	return str:gsub(main.ANDMask,
		function(s)
			local Arr = main.ExtractNumbers(s);
			return (bit.band(Arr[1], Arr[2]));
	end);
end;

function main.OR(str)
	return str:gsub(main.ORMask,
		function(s)
			local Arr = main.ExtractNumbers(s);
			return (bit.bor(Arr[1], Arr[2]));
	end);
end;

function main.XOR(str)
	return str:gsub(main.XORMask,
		function(s)
			local Arr = main.ExtractNumbers(s);
			return (bit.bxor(Arr[1], Arr[2]));
	end);
end;

function main.NOT(str)
	return str:gsub(main.NOTMask,
		function(s)
			local Arr = main.ExtractNumbers(s);
			return (bit.bnot(Arr[1]));
	end);
end;

function main.SHL(str)
	return str:gsub(main.SHLMask,
		function(s)
			local Arr = main.ExtractNumbers(s);
			return (bit.lshift(Arr[1], Arr[2]));
	end);
end;

function main.SHR(str)
	return str:gsub(main.SHRMask,
		function(s)
			local Arr = main.ExtractNumbers(s);
			return (bit.rshift(Arr[1], Arr[2]));
	end);
end;

function main.EQUAL(str)
	return str:gsub(main.EqualMask,
		function(s)
			local Arr = main.ExtractNumbers(s);
			return ((Arr[1] == Arr[2]) and 1 or 0);
	end);
end;

function main.ANDC(str)
	return str:gsub(main.ANDMaskC,
		function(s)
			local Arr = main.ExtractNumbers(s);
			return (bit.band(Arr[1], Arr[2]));
	end);
end;

function main.BoolANDC(str)
	return str:gsub(main.BoolANDMaskC,
		function(s)
			local Arr = main.ExtractNumbers(s);
			return ((Arr[1] ~= 0) and (Arr[2] ~= 0)) and 1 or 0;
	end);
end;

function main.ORC(str)
	return str:gsub(main.ORMaskC,
		function(s)
			local Arr = main.ExtractNumbers(s);
			return (bit.bor(Arr[1], Arr[2]));
	end);
end;

function main.BoolORC(str)
	return str:gsub(main.BoolORMaskC,
		function(s)
			local Arr = main.ExtractNumbers(s);
			return ((Arr[1] ~= 0) or (Arr[2] ~= 0)) and 1 or 0;
	end);
end;

function main.XORC(str)
	return str:gsub(main.XORMaskC,
		function(s)
			local Arr = main.ExtractNumbers(s);
			return (bit.bxor(Arr[1], Arr[2]));
	end);
end;

function main.BoolXORC(str)
	return str:gsub(main.BoolXORMaskC,
		function(s)
			local Arr = main.ExtractNumbers(s);
			return ((Arr[1] ~= 0) ~= (Arr[2] ~= 0)) and 1 or 0;
	end);
end;

function main.NOTC(str)
	return str:gsub(main.NOTMaskC,
		function(s)
			local Arr = main.ExtractNumbers(s);
			return (bit.bnot(Arr[1]));
	end);
end;

function main.BoolNOTC(str)
	return str:gsub(main.BoolNOTMaskC,
		function(s)
			local Arr = main.ExtractNumbers(s);
			return (not (Arr[1] ~= 0)) and 1 or 0;
	end);
end;

function main.SHLC(str)
	return str:gsub(main.SHLMaskC,
		function(s)
			local Arr = main.ExtractNumbers(s);
			return (bit.lshift(Arr[1], Arr[2]));
	end);
end;

function main.SHRC(str)
	return str:gsub(main.SHRMaskC,
		function(s)
			local Arr = main.ExtractNumbers(s);
			return (bit.rshift(Arr[1], Arr[2]));
	end);
end;

function main.EQUALC(str)
	return str:gsub(main.EqualMaskC,
		function(s)
			local Arr = main.ExtractNumbers(s);
			return ((Arr[1] == Arr[2]) and 1 or 0);
	end);
end;

function main.Multiply(str)
	return str:gsub(main.MultiplyMask,
		function(s)
			local Arr = main.ExtractNumbers(s);
			return (Arr[1] * Arr[2]);
	end);
end;

function main.Divide(str)
	return str:gsub(main.DivideMask,
		function(s)
			local Arr = main.ExtractNumbers(s);
			return (Arr[1] / Arr[2]);
	end);
end;

function main.Add(str)
	return str:gsub(main.AddMask,
		function(s)
			local Arr = main.ExtractNumbers(s);
			return (Arr[1] + Arr[2]);
	end);
end;

function main.Subtract(str)
	return str:gsub(main.SubtractMask,
		function(s)
			local Arr = main.ExtractNumbers(s);
			return (Arr[1] - Arr[2]);
	end);
end;

function main.Calculate(str)
	local num = main.SubstituteConstants(str);
	local count = 0;
	local Prefixed = {
		main.NOT;
		main.NOTC;
		main.BoolNOTC;
	};

	repeat
		num, count = main.FUNC(num);
	until (count == 0) or not count;

	local Used = { };

	local Len = #Prefixed;
	while true do
		for i = 1, Len do Used[i] = 0; end;

		local Count = 0;
		for i = 1, Len do
			repeat
				num, Count = Prefixed[i](num);
				Used[i] = Used[i] + (Count or 0);
			until not Count or (Count == 0);
		end;

		local Check = true;
		for i = 1, Len do
			if not (Used[i] == 0) then
				Check = false;
				break;
			end;
		end;
		if Check then
			break;
		end;
	end;

	local Arr = 
	{
		main.AND;
		main.ANDC;

		main.OR;
		main.ORC;

		main.XOR;
		main.XORC;

		main.SHL;
		main.SHLC;
		main.SHR;
		main.SHRC;

		main.EXP;
		main.LuaEXP;

		main.DIV;
		main.DIVC;
		main.MOD;
		main.MODC;

		main.Multiply;
		main.Divide;
		main.Add;
		main.Subtract;

		main.EQUAL;
		main.EQUALC;

		main.BoolANDC;
		main.BoolORC;
		main.BoolXORC;
	};
	for i = 1, #Arr do
		repeat
			num, count = Arr[i](num);
		until (count == 0) or (not count);
	end;
	return tonumber(num) or error('Invalid number: ' .. num);
end;

function main.ProcessEquation(equa)
	local frms = equa:gsub('%b()',
		function(str)
			return main.ProcessEquation(str:sub(2, - 2));
	end);
	return main.Calculate(frms);
end;

main.Evaluate = main.ProcessEquation;

return HMathP;

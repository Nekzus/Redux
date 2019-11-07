local main = {}
local bit = require("bit") or require("bit32")

local function newMask(...)
	local args = {...}
	return format(rep("%s", #args), unpack(args))
end

local numberMask = newMask("%-?%d+%.?%d*")

local exponentMask = newMask(numberMask, "%s-%*%*%s-", numberMask)
local luaExponentialMask = newMask(numberMask, "%s-%^%s-", numberMask)

local divMask = newMask(numberMask, "%s+div%s+", numberMask)
local modMask = newMask(numberMask, "%s+mod%s+", numberMask)
local divMaskC = newMask(numberMask, "%s-%/%/%s-", numberMask)
local modMaskC = newMask(numberMask, "%s-%%%s-", numberMask)

local multiplyMask = newMask(numberMask, "%s-%*%s-", numberMask)
local divideMask = newMask(numberMask, "%s-%/%s-", numberMask)
local addMask = newMask(numberMask, "%s-%+%s-", numberMask)
local subtractMask = newMask(numberMask, "%s-%-%s-", numberMask)

local andMask = newMask(numberMask, "%s+and%s+", numberMask)
local orMask = newMask(numberMask, "%s+or%s+", numberMask)
local xorMask = newMask(numberMask, "%s+xor%s+", numberMask)
local shlMask = newMask(numberMask, "%s+shl%s+", numberMask)
local shrMask = newMask(numberMask, "%s+shr%s+", numberMask)
local equalMask = newMask(numberMask, "%s-%=%s-", numberMask)
local notMask = newMask("not%s+", numberMask)

local andMaskC = newMask(numberMask, "%s-&%s-", numberMask)
local orMaskC = newMask(numberMask, "%s-|%s-", numberMask)
local xorMaskC = newMask(numberMask, "%s-~^%s-", numberMask)
local shlMaskC = newMask(numberMask, "%s-<<%s-", numberMask)
local shrMaskC = newMask(numberMask, "%s->>%s-", numberMask)
local equalMaskC = newMask(numberMask, "%s-%=%=%s-", numberMask)
local notMaskC = newMask("~%s-", numberMask)

local boolAndMaskC = newMask(numberMask, "%s-&&%s-", numberMask)
local boolOrMaskC = newMask(numberMask, "%s-||%s-", numberMask)
local boolXorMaskC = newMask(numberMask, "%s-!%^%s-", numberMask)
local boolNotMaskC = newMask("!%s-", numberMask)

local functionMask = "%w[%w%d_]*%b[]"

local function extractNumbers(text)
	local result = {}

	for cap in text:gmatch(numberMask) do
		local num = tonumber(cap)

		if num then
			insert(result, num)
			--else
			--printf("Could not transform number: %s", cap)
		end
	end

	return result
end

local function resolveString(text)
	return gsub(text, functionMask,
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

local operations = {
	DIV = function(text)

	end
}



function HMathP.DIV(str)
	return str:gsub(HMathP.DivMask,
		function(s)
			local Arr = HMathP.ExtractNumbers(s);
			return (math.floor(Arr[1] / Arr[2]));
	end);
end;

function HMathP.MOD(str)
	return str:gsub(HMathP.ModMask,
		function(s)
			local Arr = HMathP.ExtractNumbers(s);
			return (Arr[1] % Arr[2]);
	end);
end;

function HMathP.DIVC(str)
	return str:gsub(HMathP.DivMaskC,
		function(s)
			local Arr = HMathP.ExtractNumbers(s);
			return (math.floor(Arr[1] / Arr[2]));
	end);
end;

function HMathP.EXP(str)
	return str:gsub(HMathP.ExponentMask,
		function(s)
			local Arr = HMathP.ExtractNumbers(s);
			return (math.pow(Arr[1], Arr[2]));
	end);
end;

function HMathP.LuaEXP(str)
	return str:gsub(HMathP.LuaExponentialMask,
		function(s)
			local Arr = HMathP.ExtractNumbers(s);
			return math.pow(Arr[1], Arr[2]);
	end);
end;

function HMathP.MODC(str)
	return str:gsub(HMathP.ModMaskC,
		function(s)
			local Arr = HMathP.ExtractNumbers(s);
			return (Arr[1] % Arr[2]);
	end);
end;

function HMathP.AND(str)
	return str:gsub(HMathP.ANDMask,
		function(s)
			local Arr = HMathP.ExtractNumbers(s);
			return (bit.band(Arr[1], Arr[2]));
	end);
end;

function HMathP.OR(str)
	return str:gsub(HMathP.ORMask,
		function(s)
			local Arr = HMathP.ExtractNumbers(s);
			return (bit.bor(Arr[1], Arr[2]));
	end);
end;

function HMathP.XOR(str)
	return str:gsub(HMathP.XORMask,
		function(s)
			local Arr = HMathP.ExtractNumbers(s);
			return (bit.bxor(Arr[1], Arr[2]));
	end);
end;

function HMathP.NOT(str)
	return str:gsub(HMathP.NOTMask,
		function(s)
			local Arr = HMathP.ExtractNumbers(s);
			return (bit.bnot(Arr[1]));
	end);
end;

function HMathP.SHL(str)
	return str:gsub(HMathP.SHLMask,
		function(s)
			local Arr = HMathP.ExtractNumbers(s);
			return (bit.lshift(Arr[1], Arr[2]));
	end);
end;

function HMathP.SHR(str)
	return str:gsub(HMathP.SHRMask,
		function(s)
			local Arr = HMathP.ExtractNumbers(s);
			return (bit.rshift(Arr[1], Arr[2]));
	end);
end;

function HMathP.EQUAL(str)
	return str:gsub(HMathP.EqualMask,
		function(s)
			local Arr = HMathP.ExtractNumbers(s);
			return ((Arr[1] == Arr[2]) and 1 or 0);
	end);
end;

function HMathP.ANDC(str)
	return str:gsub(HMathP.ANDMaskC,
		function(s)
			local Arr = HMathP.ExtractNumbers(s);
			return (bit.band(Arr[1], Arr[2]));
	end);
end;

function HMathP.BoolANDC(str)
	return str:gsub(HMathP.BoolANDMaskC,
		function(s)
			local Arr = HMathP.ExtractNumbers(s);
			return ((Arr[1] ~= 0) and (Arr[2] ~= 0)) and 1 or 0;
	end);
end;

function HMathP.ORC(str)
	return str:gsub(HMathP.ORMaskC,
		function(s)
			local Arr = HMathP.ExtractNumbers(s);
			return (bit.bor(Arr[1], Arr[2]));
	end);
end;

function HMathP.BoolORC(str)
	return str:gsub(HMathP.BoolORMaskC,
		function(s)
			local Arr = HMathP.ExtractNumbers(s);
			return ((Arr[1] ~= 0) or (Arr[2] ~= 0)) and 1 or 0;
	end);
end;

function HMathP.XORC(str)
	return str:gsub(HMathP.XORMaskC,
		function(s)
			local Arr = HMathP.ExtractNumbers(s);
			return (bit.bxor(Arr[1], Arr[2]));
	end);
end;

function HMathP.BoolXORC(str)
	return str:gsub(HMathP.BoolXORMaskC,
		function(s)
			local Arr = HMathP.ExtractNumbers(s);
			return ((Arr[1] ~= 0) ~= (Arr[2] ~= 0)) and 1 or 0;
	end);
end;

function HMathP.NOTC(str)
	return str:gsub(HMathP.NOTMaskC,
		function(s)
			local Arr = HMathP.ExtractNumbers(s);
			return (bit.bnot(Arr[1]));
	end);
end;

function HMathP.BoolNOTC(str)
	return str:gsub(HMathP.BoolNOTMaskC,
		function(s)
			local Arr = HMathP.ExtractNumbers(s);
			return (not (Arr[1] ~= 0)) and 1 or 0;
	end);
end;

function HMathP.SHLC(str)
	return str:gsub(HMathP.SHLMaskC,
		function(s)
			local Arr = HMathP.ExtractNumbers(s);
			return (bit.lshift(Arr[1], Arr[2]));
	end);
end;

function HMathP.SHRC(str)
	return str:gsub(HMathP.SHRMaskC,
		function(s)
			local Arr = HMathP.ExtractNumbers(s);
			return (bit.rshift(Arr[1], Arr[2]));
	end);
end;

function HMathP.EQUALC(str)
	return str:gsub(HMathP.EqualMaskC,
		function(s)
			local Arr = HMathP.ExtractNumbers(s);
			return ((Arr[1] == Arr[2]) and 1 or 0);
	end);
end;

function HMathP.Multiply(str)
	return str:gsub(HMathP.MultiplyMask,
		function(s)
			local Arr = HMathP.ExtractNumbers(s);
			return (Arr[1] * Arr[2]);
	end);
end;

function HMathP.Divide(str)
	return str:gsub(HMathP.DivideMask,
		function(s)
			local Arr = HMathP.ExtractNumbers(s);
			return (Arr[1] / Arr[2]);
	end);
end;

function HMathP.Add(str)
	return str:gsub(HMathP.AddMask,
		function(s)
			local Arr = HMathP.ExtractNumbers(s);
			return (Arr[1] + Arr[2]);
	end);
end;

function HMathP.Subtract(str)
	return str:gsub(HMathP.SubtractMask,
		function(s)
			local Arr = HMathP.ExtractNumbers(s);
			return (Arr[1] - Arr[2]);
	end);
end;

function HMathP.Calculate(str)
	local num = HMathP.SubstituteConstants(str);
	local count = 0;
	local Prefixed = {
		HMathP.NOT;
		HMathP.NOTC;
		HMathP.BoolNOTC;
	};

	repeat
		num, count = HMathP.FUNC(num);
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
		HMathP.AND;
		HMathP.ANDC;

		HMathP.OR;
		HMathP.ORC;

		HMathP.XOR;
		HMathP.XORC;

		HMathP.SHL;
		HMathP.SHLC;
		HMathP.SHR;
		HMathP.SHRC;

		HMathP.EXP;
		HMathP.LuaEXP;

		HMathP.DIV;
		HMathP.DIVC;
		HMathP.MOD;
		HMathP.MODC;

		HMathP.Multiply;
		HMathP.Divide;
		HMathP.Add;
		HMathP.Subtract;

		HMathP.EQUAL;
		HMathP.EQUALC;

		HMathP.BoolANDC;
		HMathP.BoolORC;
		HMathP.BoolXORC;
	};
	for i = 1, #Arr do
		repeat
			num, count = Arr[i](num);
		until (count == 0) or (not count);
	end;
	return tonumber(num) or error('Invalid number: ' .. num);
end;

function HMathP.ProcessEquation(equa)
	local frms = equa:gsub('%b()',
		function(str)
			return HMathP.ProcessEquation(str:sub(2, - 2));
	end);
	return HMathP.Calculate(frms);
end;

HMathP.Evaluate = HMathP.ProcessEquation;

return HMathP;

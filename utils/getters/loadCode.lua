function loadCode(code, level, extra)
	local output = {}
	local result = {}

	if level == "dev" then
		result = getfenv()
		result.getfenv = getfenv
		result.setfenv = setfenv
	end

	--result.math = math
	--result.string = string
	result.tostring = tostring
	result.tonumber = tonumber

	if extra then
		for key, value in next, extra do
			result[key] = value
		end
	end

	function result.print(...)
		table.insert(output, printLine(...))
	end

	function result.error(...)
		table.insert(output, printLine(...))
	end

	function result.warn(...)
		table.insert(output, printLine(...))
	end

	local func, syntaxError = load(code:gsub('```\n?', ''), 'Sandbox', 't', result)
	local success, runtimeError = pcall(func)

	if success then
		response = table.concat(output, '\n')

		if #response > 1990 then
			response = response:sub(1, 1990)
		end

		return true, codeStyle(response)
	else
		return false, codeStyle(runtimeError)
	end
end

return loadCode

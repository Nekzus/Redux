function loadCode(code, level, extra)
	local output = {}
	local result = {}

	if level == "dev" then
		result = getfenv()
	else
		result.math = math
		result.string = string
		result.tostring = tostring
		result.tonumber = tonumber
	end

	for key, value in next, extra do
		result[key] = value
	end

	function result.print(...)
		insert(output, printLine(...))
	end

	function result.error(...)
		insert(output, printLine(...))
	end

	function result.warn(...)
		insert(output, printLine(...))
	end

	local func, syntaxError = load(code:gsub('```\n?', ''), 'Sandbox', 't', result)
	local success, runtimeError = pcall(func)

	if success then
		response = concat(output, '\n')

		if #response > 1990 then
			response = response:sub(1, 1990)
		end

		return true, codeStyle(response)
	else
		return false, codeStyle(runtimeError)
	end
end

return loadCode

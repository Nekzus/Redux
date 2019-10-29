function loadCode(code, message, extra)
	if not message then
		print("Message not found for loadCode()")
	end

	if not code then
		return("Missing argument")
	end

	local output = {}
	local result = {}

	if message.author.id == client.owner.id then
		result = getfenv()
	else
		result.enums = enums
		result.math = math
		result.string = string
		result.eval = eval
		result.type = type
		result.tostring = tostring
		result.tonumber = tonumber
	end

	result.message = message

	if extra then
		for key, value in next, extra do
			result[key] = value
		end
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

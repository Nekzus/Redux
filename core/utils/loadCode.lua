function loadCode(code, message, extra)
	if not message then
		print("Message not found for loadCode()")
	end

	if not code then
		return("Missing argument")
	end

	local output = {}
	local ret = {}

	if message.author.id == client.owner.id then
		ret = getfenv()
	else
		ret.enums = enums
		ret.math = math
		ret.string = string
		ret.eval = eval
		ret.type = type
		ret.tostring = tostring
		ret.tonumber = tonumber
	end

	ret.message = message

	if extra then
		for k, v in next, extra do
			ret[k] = v
		end
	end

	function ret.print(...)
		table.insert(output, printLine(...))
	end

	function ret.error(...)
		table.insert(output, printLine(...))
	end

	function ret.warn(...)
		table.insert(output, printLine(...))
	end

	local f, syntaxError = load(code:gsub('```\n?', ''), 'LuaSandbox', 't', ret)
	local success, runtimeError = pcall(f)

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

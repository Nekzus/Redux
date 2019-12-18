function abbrevNum(...)
	local args = {...}
	local result

	if type(args[1]) == "number" then
		result = realNum(args[1])

	elseif type(args[1]) == "string" then
		if args[1] == "all" then
			return args[2]

		elseif args[1] == "half" then
			return args[2] * 0.5

		elseif args[1]:find("%d+%%") then
			local num = args[1]:match("%d+")

			if num then
				result = (num / 100) * args[2]
			end

		elseif args[1] == "most" then
			local num = args[2]:match("%d+")

			if num then
				result = num * 0.7
			end

		elseif args[1] == "least" then
			local num = args[2]:match("%d+")

			if num then
				result = num * 0.3
			end

		elseif args[1]:find("rand") then
			local num = args[2]:match("%d+")

			if num and num > 0 then
				result = math.random(args[2], args[3])
			end

		else
			result = realNum(args[1])
		end
	end

	return result
end

return abbrevNum

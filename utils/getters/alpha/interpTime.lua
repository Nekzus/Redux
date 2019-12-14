function interpTime(text)
	text = type(text) == "string" and text
	or type(text) == "number" and tostring(text)
	or nil

	assert(text, "Text must be a number or string!")

	local totalTime = 0
	local ordered = {}

	for name, value in next, timeUnit do
		table.insert(ordered, {
			name = name,
			value = value
		})
	end

	table.sort(ordered, function(a, b)
		return a.value < b.value
	end)

	for value, name in text:gmatch(config.patterns.time.capture) do
		for _, item in next, ordered do
			if item.name:find(name:lower()) then
				totalTime = totalTime + value * item.value
				break
			end
		end
	end

	if totalTime <= 0 then
		local match = text:match("%d+")

		if match then
			totalTime = (totalTime + (tonumber(match))) * timeUnit.hour
		else
			totalTime = 60 * 60
		end
	end

	return totalTime
end

return interpTime

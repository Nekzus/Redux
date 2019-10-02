function interpTime(text)
	local totalTime = 0

	for formula in text:gmatch(config.patterns.mute.base) do
		local num, key = formula:match(config.patterns.mute.capture)

		if key then
			for k, v in next, config.timeInterps do
				if k:sub(1, #key) == key then
					totalTime = totalTime + num * v
					break
				end
			end
		end
	end

	if totalTime <= 0 then
		local match = text:match("%d+")

		if match then
			totalTime = (totalTime + (tonumber(match))) * hour
		else
			totalTime = 60 * 60
		end
	end

	return totalTime
end

return interpTime

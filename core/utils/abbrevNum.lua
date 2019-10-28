function abbrevNum(text, numMax)
	local result

	if type(text) == "string" then
		if text:lower() == "all" then
			result = numMax
		elseif text:lower() == "half" then
			result = numMax / 2
		elseif text:match("%d+%%") then
			local num = text:match("%d+")

			if num then
				result = (num / 100) * numMax
			end
		elseif text:match("rand%a-") then
			local num = text:match("%d+")

			if num and num > 0 then
				result = random(numMax)
			end
		else
			result = realNum(text)
		end
	elseif type(text) == "number" then
		result = realNum(text)
	end

	if result then
		return result
	else
		return false
	end
end

return abbrevNum

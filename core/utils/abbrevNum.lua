function abbrevNum(text, highestNum)
	if type(text) == "string" then
		if text:lower() == "all" then
			text = highestNum
		elseif text:lower() == "half" then
			text = highestNum / 2
		elseif text:match("%d+%%") then
			text = text:match("%d+")

			if text then
				text = (text / 100) * highestNum
			end
		else
			text = realNum(text)
		end

		return text
	end

	return false
end

return abbrevNum

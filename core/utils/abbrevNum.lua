function abbrevNum(text, numMax)
	if type(text) == "string" then
		if text:lower() == "all" then
			text = numMax
		elseif text:lower() == "half" then
			text = numMax / 2
		elseif text:match("%d+%%") then
			text = text:match("%d+")

			if text then
				text = (text / 100) * numMax
			end
		else
			text = realNum(text)
		end

		return text
	end

	return false
end

return abbrevNum

function getColor(text)
	local result = {
		match(text or config.colors.grey,
		config.patterns.colorRGB.capture)
	}

	if #result == 3 then
		return discordia.Color.fromRGB(unpack(result)).value
	else
		return discordia.Color.fromRGB(unpack(result[1] or random(255), result[2] or random(255), result[3] or random(255)))
	end
end

return getColor

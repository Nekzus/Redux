function getColor(text)
	local ret = {match(text or config.colors.grey, config.patterns.colorRGB.capture)}

	if #ret == 3 then
		return discordia.Color.fromRGB(unpack(ret)).value
	else
		return discordia.Color.fromRGB(unpack(ret[1] or random(255), ret[2] or random(255), ret[3] or random(255)))
	end
end

return getColor

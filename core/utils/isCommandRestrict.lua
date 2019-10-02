function isCommandRestrict(commandData, lang)
	local restricted = true

	if commandData.restrict then
		for k, v in next, commandData.restrict do
			if v == lang then
				restricted = false
				break
			end
		end
	else
		restricted = false
	end

	return restricted
end

return isCommandRestrict

function isCommandRestrict(commandData, langName)
	local restricted = true

	if commandData.restrict then
		for _, lang in next, commandData.restrict do
			if lang == langName then
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

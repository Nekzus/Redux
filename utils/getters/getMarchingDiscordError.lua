function getMatchingDiscordError(text, list)
	for errorKey, errorMessage in next, list do
		if errorKey:find(text) then
			return errorMessage
		end
	end

	return nil
end

return getMatchingDiscordError

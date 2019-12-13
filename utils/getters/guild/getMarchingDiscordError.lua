function getMatchingDiscordError(text, lang)
	for errorKey, errorMessage in next, langs do
		if errorKey:find(text) then
			return errorMessage[lang]
		end
	end

	return nil
end

return getMatchingDiscordError

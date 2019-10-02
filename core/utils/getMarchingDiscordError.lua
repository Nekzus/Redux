function getMatchingDiscordError(text, list)
	for k, v in next, list do
		if k:find(text) then
			return v
		end
	end

	return nil
end

return getMatchingDiscordError

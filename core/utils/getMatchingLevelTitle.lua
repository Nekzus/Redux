function getMatchingLevelTitle(level)
	for k, v in next, config.titles do
		if v.level == level then
			return v.title
		end
	end

	return nil
end

return getMatchingLevelTitle

function getMatchingLevelTitle(level)
	for titleKey, titleData in next, config.titles do
		if titleData.level == level then
			return titleData.title
		end
	end

	return nil
end

return getMatchingLevelTitle

function getMatchingRoleTitle(num)
	for titleKey, titleData in next, config.titles do
		if titleData.level == num then
			return titleData.title
		end
	end

	return nil
end

return getMatchingRoleTitle

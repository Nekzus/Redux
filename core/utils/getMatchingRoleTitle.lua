function getMatchingRoleTitle(num)
	for k, v in next, config.titles do
		if v.level == num then
			return v.title
		end
	end

	return nil
end

return getMatchingRoleTitle

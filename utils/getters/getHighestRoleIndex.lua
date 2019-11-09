function getHighestRoleIndex(level, list)
	local result = false
	local added

	for roleId, roleData in next, list do
		if roleData.level and roleData.level == level then
			if roleData.added and (added == nil or (roleData.added > added)) then
				added = roleData.added
				result = roleId
			end
		end
	end

	return result
end

return getHighestRoleIndex

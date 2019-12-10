function getHighestRoleIndex(level, list)
	local result = false
	local lastAdded

	for roleId, roleData in next, list do
		if roleData.level and roleData.level == level then
			if roleData.added
			and (lastAdded == nil or (roleData.added > lastAdded)) then
				lastAdded = roleData.added
				result = roleId
			end
		end
	end

	return result
end

return getHighestRoleIndex

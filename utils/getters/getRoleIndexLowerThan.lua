function getRoleIndexLowerThan(level, list, added)
	local roleId = false
	local added

	for roleId, roleData in next, list do
		if roleData.level and roleData.level == level then
			if roleData.added and (added == nil or (roleData.added > added)) then
				if (added and roleData.added < added) or added == nil then
					added = roleData.added
					roleId = roleId
				end
			end
		end
	end

	return roleId
end

return getRoleIndexLowerThan

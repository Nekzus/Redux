function getHighestRoleIndex(level, list)
	local roleId = false
	local added

	for k, v in next, list do
		if v.level and v.level == level then
			if v.added and (added == nil or (v.added > added)) then
				added = v.added
				roleId = k
			end
		end
	end

	return roleId
end

return getHighestRoleIndex

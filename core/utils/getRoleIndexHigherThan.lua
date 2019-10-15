function getRoleIndexHigherThan(level, list, reference)
	local result = false
	local added

	for roleId, roleData in next, list do
		if roleData.level and roleData.level == level then
			if roleData.added and (added == nil or (roleData.added < added)) then
				if (reference and roleData.added > reference) or reference == nil then
					added = roleData.added
					result = roleId
				end
			end
		end
	end

	return result
end

return getRoleIndexHigherThan

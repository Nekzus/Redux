function getRoleIndexHigherThan(level, list, reference)
	local roleId = false
	local added

	for k, v in next, list do
		if v.level and v.level == level then
			if v.added and (added == nil or (v.added < added)) then
				if (reference and v.added > reference) or reference == nil then
					added = v.added
					roleId = k
				end
			end
		end
	end

	return roleId
end

return getRoleIndexHigherThan

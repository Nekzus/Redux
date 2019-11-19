function getMembersFromRole(role)

	for k, v in next, data.guild:getRole(role).members:toArray() do
		return k, v
		k = k + 1
	end

	return nil
end

return getMembersFromRole

function getMembersFromRole(role)

	for k, v in next, data.guild:getRole(role).members:toArray() do
		MembersFromRole = k, v
	end

	return MembersFromRole
end

return getMembersFromRole

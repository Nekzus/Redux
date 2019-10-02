function inList(value, list)
	for k, v in next, list do
		if value == k then
			return v, k
		elseif value == v then
			return k, v
		end
	end

	return nil
end

return inList

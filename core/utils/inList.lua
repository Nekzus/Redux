function inList(item, list)
	for key, value in next, list do
		if item == key then
			return value, key
		elseif item == value then
			return key, value
		end
	end

	return nil
end

return inList

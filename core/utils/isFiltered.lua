function isFiltered(text, list)
	text = text:lower()

	for k, v in next, list do
		v = v:lower()

		if text:find(v) then
			return v, k
		end
	end

	return nil
end

return isFiltered

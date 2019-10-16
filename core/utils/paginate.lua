function paginate(list, perPage, page)
	perPage = perPage or 8
	page = page or 1

	local sliceTo = (page * perPage)
	local sliceAt = (sliceTo - (perPage - 1))
	local result = slice(list, sliceAt, sliceTo, 1)

	return result
end

return paginate

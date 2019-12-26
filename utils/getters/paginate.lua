function paginate(list, perPage, page)
	perPage = perPage or 10
	page = page or 1

	local sliceTo = (page * perPage)
	local sliceAt = (sliceTo - (perPage - 1))
	local result = table.slice(list, sliceAt, sliceTo, 1)

	return result
end

return paginate

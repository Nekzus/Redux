function paginate(list, perPage, page)
	local perPage = perPage or 10
	local page = page or 1
	local sliceTo = (page * perPage)
	local sliceAt = (sliceTo - (perPage - 1))

	return table.slice(list, sliceAt, sliceTo, 1)
end

return paginate

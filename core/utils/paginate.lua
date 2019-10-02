function paginate(list, perPage, page)
	perPage = perPage or 10
	page = page or 1

	local endAt = (page * perPage)
	local startAt = (endAt - (perPage - 1))
	local rList = slice(list, startAt, endAt, 1)

	return rList
end

return paginate

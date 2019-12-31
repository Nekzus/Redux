local methods = {}
local metatable = {}

function metatable:__index(...)
	return rawget(methods, ...)
end

local function updatePages(list, perPage)
	assert(type(list), "List must be a table")
	assert(type(perPage), "PerPage must be a number")

	local count = #list

	return (count == 0 or perPage == 0 and 0)
	or count / perPage
end

function metatable:__call(list)
	return setmetatable({
		list = list or {},
		page = 1,
		pages = list and updatePages(list) or 1,
		perPage = 10,
	}, metatable)
end

function methods:setPerPage(items)
	assert(self.list, "Must create object first")
	assert(type(items) == "number", "Items must be a number")

	self.perPage = items
end

function methods:setList(list)
	assert(self.list, "Must create object first")
	assert(type(list) == "table", "List must be a table")

	self.list = list
	self.pages = updatePages(self.list, self.perPage)
end

function methods:insert(item)
	assert(self.list, "Must create object first")
	assert(item, "Must provide a valid item")

	table.insert(self.list, item)
	self.pages = updatePages(self.list, self.perPage)
end

function methods:remove(index)
	assert(self.list, "Must create object first")
	assert(type(index) == "number", "Index must be a number (table position)")

	table.remove(self.list, index)
	self.pages = updatePages(self.list, self.perPage)
end

function methods:setPage(page)
	assert(self.list, "Must create object first")
	assert(type(page) == "number", "Page must be a number")

	self.page = page
end

function methods:next(increment)
	assert(self.list, "Must create object first")

	self:setPage(math.min(self.page + increment or 1, self.pages))
end

function methods:back(increment)
	assert(self.list, "Must create object first")

	self:setPage(math.max(self.page - increment or 1, self.pages))
end

function methods:sort(func)
	assert(self.list, "Must create object first")

	table.sort(self.list, func)
end

function methods:render()
	return paginate(self.list, self.perPage, self.page)
end

function methods:getPage()
	return self.page
end

function methods:getPages()
	return self.pages
end

function methods:getList()
	return self.list
end

book = setmetatable(methods, metatable)

return book

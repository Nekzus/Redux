local methods = {}
local metatable = {}

function methods:author(text)
	local embed = assert(self.embed, "Must create object first")
	assert(text and type(text), "Text must be a string in author()")

	embed.author = self.embed.author or {}
	embed.author.name = text

	return self
end

function methods:authorImage(text)
	local embed = assert(self.embed, "Must create object first")
	assert(text and type(text), "Text must be a string in authorImage()")

	embed.author = embed.author or {}
	embed.author.icon_url = text

	return self
end

function methods:authorUrl(text)
	local embed = assert(self.embed, "Must create object first")
	assert(text and type(text), "Text must be a string in authorUrl()")

	embed.author = embed.author or {}
	embed.author.url = text

	return self
end

function methods:color(list)
	assert(list and type(list) == "table" and #list == 3, "List must include three elements")
	local embed = assert(self.embed, "Must create object first")

	embed.color = discordia.Color.fromRGB(unpack(list)).value

	return self
end

function methods:thumbnail(text)
	local embed = assert(self.embed, "Must create object first")

	embed.thumbnail = embed.thumbnail or {}
	embed.thumbnail.url = text

	return self
end

function methods:image(text)
	local embed = assert(self.embed, "Must create object first")

	embed.image = embed.image or {}
	embed.image.url = text

	return self
end

function methods:footer(text)
	local embed = assert(self.embed, "Must create object first")

	embed.footer = embed.footer or {}
	embed.footer.text = text

	return self
end

function methods:footerIcon(text)
	local embed = assert(self.embed, "Must create object first")

	embed.footer = embed.footer or {}
	embed.footer.icon_url = text

	return self
end

function methods:title(text)
	local embed = assert(self.embed, "Must create object first")

	embed.title = text

	return self
end

function methods:timestamp(text)
	local embed = assert(self.embed, "Must create object first")

	embed.timestamp = text

	return self
end

function methods:description(text)
	local embed = assert(self.embed, "Must create object first")

	embed.description = text

	return self
end

function methods:field(field)
	local embed = assert(self.embed, "Must create object first")

	embed.fields = embed.fields or {}
	table.insert(embed.fields, field)

	return self
end

function methods:raw()
	return assert(self.embed, "Must create object first")
end

function metatable:__call(data)
	assert(self.embed == nil, "Object already exists")

	return setmetatable({
		embed = data or {},
	}, metatable)
end

function metatable:__index(key)
	return rawget(methods, key)
end

newEmbed = setmetatable(methods, metatable)

return newEmbed

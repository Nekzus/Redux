newEmbed = {}
newEmbed.__index = newEmbed

function newEmbed:__call(data)
	assert(self.embed == nil, "Embed already exists, cannot create a new")

	return setmetatable({
		embed = data or {},
	}, newEmbed)
end

function newEmbed:author(text)
	local embed = assert(self.embed, "Must create an embed first with constructor")

	embed.author = self.embed.author or {}
	embed.author.name = text
end

function newEmbed:authorImage(text)
	local embed = assert(self.embed, "Must create an embed first with constructor")

	embed.author = embed.author or {}
	embed.author.icon_url = text
end

function newEmbed:authorUrl(text)
	local embed = assert(self.embed, "Must create an embed first with constructor")

	embed.author = embed.author or {}
	embed.author.url = text
end

function newEmbed:color(r, g, b)
	local embed = assert(self.embed, "Must create an embed first with constructor")

	embed.color = discordia.Color.fromRGB(r, g, b).value
end

function newEmbed:thumbnail(text)
	local embed = assert(self.embed, "Must create an embed first with constructor")

	embed.thumbnail = embed.thumbnail or {}
	embed.thumbnail.url = text
end

function newEmbed:image(text)
	local embed = assert(self.embed, "Must create an embed first with constructor")

	embed.image = embed.image or {}
	embed.image.url = text
end

function newEmbed:footer(text)
	local embed = assert(self.embed, "Must create an embed first with constructor")

	embed.footer = embed.footer or {}
	embed.footer.text = text
end

function newEmbed:footerIcon(text)
	local embed = assert(self.embed, "Must create an embed first with constructor")

	embed.footer = embed.footer or {}
	embed.footer.icon_url = text
end

function newEmbed:title(text)
	local embed = assert(self.embed, "Must create an embed first with constructor")

	embed.title = text
end

function newEmbed:timestamp(text)
	local embed = assert(self.embed, "Must create an embed first with constructor")

	embed.timestamp = text
end

function newEmbed:description(text)
	local embed = assert(self.embed, "Must create an embed first with constructor")

	embed.description = text
end

function newEmbed:content(text)
	local embed = assert(self.embed, "Must create an embed first with constructor")

	embed.content = text
end

function newEmbed:field(field)
	local embed = assert(self.embed, "Must create an embed first with constructor")

	embed.fields = embed.fields or {}
	insert(embed.fields, field)
end

function newEmbed:raw()
	return assert(self.embed, "Must create an embed first with constructor")
end

newEmbed = setmetatable({}, newEmbed)

return newEmbed

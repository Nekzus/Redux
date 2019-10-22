local main = {}
main.__index = main

function main:__call(data)
	assert(self.embed == nil, "Embed already exists, cannot create a new")

	return setmetatable({
		embed = data or {},
	}, main)
end

function main:author(text)
	local embed = assert(self.embed, "Must create an embed first with constructor")

	embed.author = self.embed.author or {}
	embed.author.name = text
end

function main:authorImage(text)
	local embed = assert(self.embed, "Must create an embed first with constructor")

	embed.author = embed.author or {}
	embed.author.icon_url = text
end

function main:authorUrl(text)
	local embed = assert(self.embed, "Must create an embed first with constructor")

	embed.author = embed.author or {}
	embed.author.url = text
end

function main:color(r, g, b)
	local embed = assert(self.embed, "Must create an embed first with constructor")

	embed.color = discordia.Color.fromRGB(r, g, b).value
end

function main:thumbnail(text)
	local embed = assert(self.embed, "Must create an embed first with constructor")

	embed.thumbnail = embed.thumbnail or {}
	embed.thumbnail.url = text
end

function main:image(text)
	local embed = assert(self.embed, "Must create an embed first with constructor")

	embed.image = embed.image or {}
	embed.image.url = text
end

function main:footer(text)
	local embed = assert(self.embed, "Must create an embed first with constructor")

	embed.footer = embed.footer or {}
	embed.footer.text = text
end

function main:footerIcon(text)
	local embed = assert(self.embed, "Must create an embed first with constructor")

	embed.footer = embed.footer or {}
	embed.footer.icon_url = text
end

function main:title(text)
	local embed = assert(self.embed, "Must create an embed first with constructor")

	embed.title = text
end

function main:timestamp(text)
	local embed = assert(self.embed, "Must create an embed first with constructor")

	embed.timestamp = text
end

function main:description(text)
	local embed = assert(self.embed, "Must create an embed first with constructor")

	embed.description = text
end

function main:content(text)
	local embed = assert(self.embed, "Must create an embed first with constructor")

	embed.content = text
end

function main:field(field)
	local embed = assert(self.embed, "Must create an embed first with constructor")

	embed.fields = embed.fields or {}
	insert(embed.fields, field)
end

function main:raw()
	return assert(self.embed, "Must create an embed first with constructor")
end

newEmbed = setmetatable({}, main)

return newEmbed

--[[
	Parte responsável por facilitar a criação de embeds para o discord.
]]

-- Cria um construtor para registrar os métodos e metamétodos
local main = {}
main.__index = main

-- Função construtora que cria um novo objeto 'embed' para ser editado
function main:__call(data)
	assert(self.embed == nil, "Embed already exists, cannot create a new")

	return setmetatable({
		embed = data or {},
	}, main)
end

-- Define o nome para o campo autor
function main:author(text)
	local embed = assert(self.embed, "Must create an embed first with constructor")
	assert(text and type(text), "Text must be a string in author()")

	embed.author = self.embed.author or {}
	embed.author.name = text

	return self
end

-- Define uma imagem miniatura para o autor
function main:authorImage(text)
	local embed = assert(self.embed, "Must create an embed first with constructor")
	assert(text and type(text), "Text must be a string in authorImage()")

	embed.author = embed.author or {}
	embed.author.icon_url = text

	return self
end

-- Define um direcionamento de link ao clicar no nome do autor
function main:authorUrl(text)
	local embed = assert(self.embed, "Must create an embed first with constructor")
	assert(text and type(text), "Text must be a string in authorUrl()")

	embed.author = embed.author or {}
	embed.author.url = text

	return self
end

-- Define a cor do tema do embed conforme a cor que for passada em text
function main:color(text)
	local embed = assert(self.embed, "Must create an embed first with constructor")
	assert(text and type(text) == "string", "Text must be a color-resolvable (r0g0b0)")

	-- Quebra o texto em partes conforme o padrão de cores em config.patterns.colorRGB
	local r, g, b = text:match(config.patterns.colorRGB.capture)

	embed.color = discordia.Color.fromRGB(r, g, b).value

	return self
end

-- Define um novo objeto de imagem miniatura
function main:thumbnail(text)
	local embed = assert(self.embed, "Must create an embed first with constructor")

	embed.thumbnail = embed.thumbnail or {}
	embed.thumbnail.url = text

	return self
end

-- Define um novo objeto de imagem para cobrir o centro
function main:image(text)
	local embed = assert(self.embed, "Must create an embed first with constructor")

	embed.image = embed.image or {}
	embed.image.url = text

	return self
end

-- Define um texto para o rodapé
function main:footer(text)
	local embed = assert(self.embed, "Must create an embed first with constructor")

	embed.footer = embed.footer or {}
	embed.footer.text = text

	return self
end

-- Define um icone para o rodapé
function main:footerIcon(text)
	local embed = assert(self.embed, "Must create an embed first with constructor")

	embed.footer = embed.footer or {}
	embed.footer.icon_url = text

	return self
end

-- Define o título do embed
function main:title(text)
	local embed = assert(self.embed, "Must create an embed first with constructor")

	embed.title = text

	return self
end

-- Define o horário do embed
function main:timestamp(text)
	local embed = assert(self.embed, "Must create an embed first with constructor")

	embed.timestamp = text

	return self
end

-- Define uma descrição
function main:description(text)
	local embed = assert(self.embed, "Must create an embed first with constructor")

	embed.description = text

	return self
end

-- Define um novo campo dentro do embed
function main:field(field)
	local embed = assert(self.embed, "Must create an embed first with constructor")

	embed.fields = embed.fields or {}
	insert(embed.fields, field)

	return self
end

-- Retorna as informações cruas do embed
function main:raw()
	return assert(self.embed, "Must create an embed first with constructor")
end

-- Registra o processo
newEmbed = setmetatable({}, main)

-- Retorna o processo para confirmar que houve a execução sem erros
return newEmbed

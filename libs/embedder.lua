--[[
	Parte responsável por facilitar a criação de embeds para o discord.
]]

-- Cria um construtor para registrar os métodos e metamétodos
local methods = {}
local metatable = {}

-- Função construtora que cria um novo objeto 'embed' para ser editado
function metatable:__call(data)
	assert(self.embed == nil, "Embed already exists, can only use the methods")

	return setmetatable({
		embed = data or {},
	}, metatable)
end

-- Associa os métodos ao objeto
function metatable:__index(key)
	local method = rawget(methods, key)

	if method then
		return method
	end
end

-- Define o nome para o campo autor
function methods:author(text)
	local embed = assert(self.embed, "Must create an embed first with constructor")
	assert(text and type(text), "Text must be a string in author()")

	embed.author = self.embed.author or {}
	embed.author.name = text

	return self
end

-- Define uma imagem miniatura para o autor
function methods:authorImage(text)
	local embed = assert(self.embed, "Must create an embed first with constructor")
	assert(text and type(text), "Text must be a string in authorImage()")

	embed.author = embed.author or {}
	embed.author.icon_url = text

	return self
end

-- Define um direcionamento de link ao clicar no nome do autor
function methods:authorUrl(text)
	local embed = assert(self.embed, "Must create an embed first with constructor")
	assert(text and type(text), "Text must be a string in authorUrl()")

	embed.author = embed.author or {}
	embed.author.url = text

	return self
end

-- Define a cor do tema do embed conforme a cor que for passada em text
function methods:color(list)
	assert(list and type(list) == "table" and #list == 3, "List must include three elements")
	local embed = assert(self.embed, "Must create an embed first with constructor")

	-- Quebra o texto em partes conforme o padrão de cores em config.patterns.colorRGB
	embed.color = discordia.Color.fromRGB(unpack(list)).value

	return self
end

-- Define um novo objeto de imagem miniatura
function methods:thumbnail(text)
	local embed = assert(self.embed, "Must create an embed first with constructor")

	embed.thumbnail = embed.thumbnail or {}
	embed.thumbnail.url = text

	return self
end

-- Define um novo objeto de imagem para cobrir o centro
function methods:image(text)
	local embed = assert(self.embed, "Must create an embed first with constructor")

	embed.image = embed.image or {}
	embed.image.url = text

	return self
end

-- Define um texto para o rodapé
function methods:footer(text)
	local embed = assert(self.embed, "Must create an embed first with constructor")

	embed.footer = embed.footer or {}
	embed.footer.text = text

	return self
end

-- Define um icone para o rodapé
function methods:footerIcon(text)
	local embed = assert(self.embed, "Must create an embed first with constructor")

	embed.footer = embed.footer or {}
	embed.footer.icon_url = text

	return self
end

-- Define o título do embed
function methods:title(text)
	local embed = assert(self.embed, "Must create an embed first with constructor")

	embed.title = text

	return self
end

-- Define o horário do embed
function methods:timestamp(text)
	local embed = assert(self.embed, "Must create an embed first with constructor")

	embed.timestamp = text

	return self
end

-- Define uma descrição
function methods:description(text)
	local embed = assert(self.embed, "Must create an embed first with constructor")

	embed.description = text

	return self
end

-- Define um novo campo dentro do embed
function methods:field(field)
	local embed = assert(self.embed, "Must create an embed first with constructor")

	embed.fields = embed.fields or {}
	insert(embed.fields, field)

	return self
end

-- Retorna as informações cruas do embed
function methods:raw()
	return assert(self.embed, "Must create an embed first with constructor")
end

-- Registra o processo
newEmbed = setmetatable(methods, metatable)

-- Retorna o processo para confirmar que houve a execução sem erros
return newEmbed

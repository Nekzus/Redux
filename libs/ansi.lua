--[[
	Parte responsável por retornar um texto formatado para dar suporte à
	visualização de elementos coloridos no console do Windows

	Exemplos:
	print(colors('%{red}hello'))
	print(colors('%{redbg}hello%{reset}'))
	print(colors('%{bright red underline}hello'))
]]

-- Detecta se estamos utilizando o ambiente do Windows
local function isWindows()
	return type(package) == 'table'
	and type(package.config) == 'string'
	and sub(package.config, 1, 1) == '\\'
end

local supported = not isWindows()

if isWindows() then
	supported = os.getenv("ANSICON")
end

local keys = {
	-- Comportamentos
	reset = 0,
	bright = 1,
	dim = 2,
	underline = 4,
	blink = 5,
	reverse = 7,
	hidden = 8,

	-- Cores de texto
	black = 30,
	red = 31,
	green = 32,
	yellow = 33,
	blue = 34,
	magenta = 35,
	cyan = 36,
	white = 37,

	-- Cores de fundo
	blackbg = 40,
	redbg = 41,
	greenbg = 42,
	yellowbg = 43,
	bluebg = 44,
	magentabg = 45,
	cyanbg = 46,
	whitebg = 47
}

local escapeString = string.char(27) .. '[%dm'

local function escapeNumber(number)
	return format(escapeString, number)
end

local function escapeKeys(text)
	if not supported then
		return ""
	end

	local buffer = {}
	local number

	for word in gmatch(text, "%w+") do
		number = keys[word]
		assert(number, format("Unknown key: %s", word))
		insert(buffer, escapeNumber(number) )
	end

	return concat(buffer)
end

local function replaceAnsi(text)
	return gsub(text, "(!{(.-)})",
		function(full, word)
			return escapeKeys(word)
		end
	)
end

function ansiColor(str)
	return replaceAnsi(format("%s%s%s", "!{reset}", tostring(str or ""), "!{reset}"))
end

return ansiColor

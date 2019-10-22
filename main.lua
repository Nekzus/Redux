-- Agrupa as principais funcionalidades para o bot
discordia = require("discordia")
client = discordia.Client{cacheAllMembers = true, logLevel = 3, logFile = ""}
emitter = discordia.Emitter()
time = discordia.Time()
enums = discordia.enums
discordia.extensions()

-- Atalhos string
byte = string.byte
char = string.char
find = string.find
format = string.format
gmatch = string.gmatch
gsub = string.gsub
len = string.len
lower = string.lower
match = string.match
rep = string.rep
reverse = string.reverse
sub = string.sub
upper = string.upper
startsWith = string.startswith
endsWith = string.endswith
split = string.split
trim = string.trim
pad = string.pad
levenshtein = string.levenshtein

-- Atalhos math
abs = math.abs
acos = math.acos
asin = math.asin
atan = math.atan
ceil = math.ceil
cos = math.cos
clamp = math.clamp
deg = math.deg
exp = math.exp
floor = math.floor
fmod = math.fmod
huge = math.huge
log = math.log
max = math.max
min = math.min
modf = math.modf
pi = math.pi
rad = math.rad
random = math.random
randomSeed = math.randomseed
round = math.round
sin = math.sin
sqrt = math.sqrt
tan = math.tan

-- Atalhos table
concat = table.concat
copy = table.copy
insert = table.insert
remove = table.remove
unpack = table.unpack
sort = table.sort
deepCopy = table.deepcopy
deepCount = table.deepcount
slice = table.slice
randomPair = table.randompair
randomIpair = table.randomipair
reverse = table.reverse
reversed = table.reversed
keys = table.keys
values = table.values
sorted = table.sorted
search = table.search

-- Extensões principais
fs = require("fs")
query = require("querystring")
http = require("coro-http")
json = require("json")
timer = require("timer")
parse = require("url").parse
spawn = require("coro-spawn")

-- Pontos pricipais de acesso
bot = {}
saves = {}
config = {}

config.time = {
	second = 1,
	minute = 60,
	hour = 3600,
	day = 86400,
	week = 604800,
	month = 2592000,
	year = 31536000,
}

randomSeed(os.time())

-- Funções facilitadoras essenciais
function wait(num) -- wait baseado no timer.sleep que não para o processo de execução principal do Luvit (como loops)
	return timer.sleep(num * 1000)
end

function printf(text, ...) -- Print formatado que permite exibir um texto ao mesmo tempo que há a formatação
	return print(format(text, ...))
end

function loadFile(path) -- Função principal para carregar arquivos que estão presentes em um caminho pré-definido
	local file = fs.readFileSync(path)
	local fileName = path:split("/")

	if fileName then
		fileName = fileName[#fileName]
	else
		fileName = format("UNKNOWN FILENAME (%s)", tostring(os.time() + random()):gsub("[.]", ""))
	end

	if file then
		local code, err = loadstring(file, fileName)

		if code then
			setfenv(code, getfenv())

			local success, result = pcall(code)

			if success then
				return result
			else
				printf("RUNTIME ERROR: %s | %s", fileName, ret)
				return false
			end
		else
			printf("SYNTAX ERROR: %s | %s", fileName, err)
			return false
		end
	else
		printf("LOAD ERROR: %s | %s", code, err)
		return false
	end
end

-- Salva todos os dados
function saveAllData()
	for name, data in next, saves do
		db.save(data:raw(), name)
	end
end

-- Inicializa a estrutura
function loadBot()
	-- Inicializa o bot
	local startMessage = format("%s %s %s\n", rep("-", 10), os.date("%m/%d/%Y %I:%M %p"), rep("-", 10))

	bot.loaded = false
	print(format("\n%s", startMessage))
	client:removeAllListeners()

	-- Carrega todos os arquivos de configuração
	for file, type in fs.scandirSync("./config/") do
		if type == "file" then
			loadFile(format("./config/%s", file))
		end
	end

	-- Carrega todas as bibliotecas e utilidades
	for _, folder in next, {"libs", "utils"} do
		for file, type in fs.scandirSync(format("./core/%s/", folder)) do
			if type == "file" then
				loadFile(format("./core/%s/%s", folder, file))
			end
		end
	end

	-- Carrega todas as linguagens e eventos
	for _, folder in next, {"langs", "events"} do
		for file, type in fs.scandirSync(format("./%s/", folder)) do
			if type == "file" then
				loadFile(format("./%s/%s", folder, file))
			end
		end
	end

	-- Carrega todos os comandos
	for category, type in fs.scandirSync("./mods/") do
		if type == "directory" then
			for file, type in fs.scandirSync(format("./mods/%s/", category)) do
				if type == "file" then
					local mod = loadFile(format("./mods/%s/%s", category, file))

					if mod then
						local aliases = mod.config.aliases
						mod.config.category = format("${%s}", category)
						mod.config.func = mod.func
						mod.config.aliases = nil
						commands:create(mod.config):accept(unpack(aliases))
					else
						printf("Failed to load %s of category %s", file, category)
					end
				end
			end
		end
	end

	-- Carrega todos os dados
	saves.global = cache(db.load("global") or {}) -- Informações principais de guildas
	saves.economy = cache(db.load("economy") or {}) -- Economia de servidores e itens das lojas virtuais
	saves.clans = cache(db.load("clans") or {}) -- Informações de clans, membros e hierarquia
	saves.track = cache(db.load("track") or {}) -- Rastreadores globais de mutes e patronos
	saves.temp = cache(db.load("temp") or {}) -- Informações temporárias de utilização de comandos
	bot.loaded = true
end

-- Inicializa o processo principal
loadBot()
client:run(format("Bot %s", config.main.botToken))

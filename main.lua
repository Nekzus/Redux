discordia = require("discordia") -- Carrega as funcionalidades da biblioteca Discordia
emitter = discordia.Emitter() -- Função para inscrever callbacks conforme sinais forem ativados
time = discordia.Time() -- Biblioteca com funções relacionadas à tempo
enums = discordia.enums -- Dicionário de valores enumerados para serem usados via Discordia
discordia.extensions() -- Carrega as extensões disponíveis pelo autor do Discordia na memória
client = discordia.Client({ -- Inicializa o cliente conforme as configurações
	cacheAllMembers = true,
	logLevel = 3,
	logFile = ""
})

fs = require("fs")
http = require("coro-http")
json = require("json")
timer = require("timer")
url = require("url")
query = require("querystring")

luaxp = require("luaxp")
serpent = require("serpent")

unpack = table.unpack
first = function(list) return list[1] end
last = function(list) return list[#list] end

bot = {}
saves = {}
config = {}

timeUnit = {
	second = 1,
	minute = 60,
	hour = 3600,
	day = 86400,
	week = 604800,
	month = 2592000,
	year = 31536000,
	decade = 315360000,
	century = 3153600000,
}

math.randomseed(os.time())

function wait(time)
	return timer.sleep((time or 0) * 1000)
end

function printf(text, ...)
	return string.format(text, ...)
end

function join(...)
	local args = {...}

	return string.format(string.rep("%s", #args), unpack(args))
end

function dos(cmd, raw)
	local func = assert(io.popen(cmd, "r"))
	local result = assert(func:read("*a"))

	func:close()

	if raw then
		return result
	end

	return result:gsub("^%s+", "")
	:gsub("%s+$", "")
	:gsub("[\n\r]+", " ")
end

function loadFile(path)
	assert(type(path) == "string", "Path must be a string")

	local file = io.open(path, "rb")
	local result = file and file:read("*a")
	local fileName = last(path:split("/"))

	if not file then
		printf("Load Error: %s | %s", fileName or path)
		return false
	end

	local code, err = loadstring(result, fileName)

	if not code then
		printf("Syntax Error: %s | %s", fileName, err)
		return false
	end

	setfenv(code, getfenv())

	local success, result = pcall(code)

	if success then
		return result
	else
		printf("Runtime Error: %s | %s", fileName, result)
		return false
	end
end

function loadFiles(path, callback)
	for file, type in fs.scandirSync(path) do
		if type == "file" then
			local loaded = loadFile(join(path, "/", file))

			if callback and loaded then
				return callback(loaded)
			end
		elseif type == "directory" then
			loadFiles(join(path, "/", file))
		end
	end
end

function loadBot()
	local line = string.rep("-", 10)
	local info = join(line, os.date("%m/%d/%Y %I:%M %p"), line)

	print(join("\n", info, "\n"))
	client:removeAllListeners()

	loadFiles("./config")
	loadFiles("./libs")
	loadFiles("./utils")
	loadFiles("./events")

	local path = "./addons"

	for category, type in fs.scandirSync(path) do
		if type == "directory" then
			for file, type in fs.scandirSync(join(path, "/", category)) do
				if type == "file" then
					local addon = loadFile(join(path, "/", category, "/", file))

					if not addon then
						printf("Failed to load %s from %s", file, category)
					end

					local aliases = addon.config.aliases or {}

					addon.config.category = string.format("${%s}", category)
					addon.config.func = addon.func

					local command = worker:create(addon.config)

					if #aliases > 0 then
						command:accept(unpack(aliases))
					end
				end
			end
		end
	end

	saves.temp = saves.temp or think("./saves/bot/temp.bin")
	saves.track = saves.track or think("./saves/bot/track.bin")
	bot.loaded = true
end

loadBot()
client:run(join("Bot ", config.main.botToken))

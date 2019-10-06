-- Core
discordia = require("discordia")
client = discordia.Client{cacheAllMembers = true, logLevel = 3, logFile = ""}
emitter = discordia.Emitter()
time = discordia.Time()
enums = discordia.enums
discordia.extensions()

-- String
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

-- Math
abs = math.abs
acos = math.acos
asin = math.asin
atan = math.atan
ceil = math.ceil
cos = math.cos
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
randomseed = math.randomseed
sin = math.sin
sqrt = math.sqrt
tan = math.tan

-- Table
concat = table.concat
insert = table.insert
remove = table.remove
unpack = table.unpack
sort = table.sort
deepcopy = table.deepcopy
slice = table.slice

-- Extensions
fs = require("fs")
query = require("querystring")
http = require("coro-http")
json = require("json")
timer = require("timer")
parse = require("url").parse
spawn = require("coro-spawn")

-- Trackers shortcuts
bot = {loaded = false}
saves = {}

function wait(sec)
	return timer.sleep(sec * 1000)
end

function printf(text, ...)
	return print(format(text, ...))
end

function isValue(list, value)
	for k, v in next, list do
		if v == value then
			return true
		end
	end

	return false
end

randomseed(os.time())

function loadFile(path)
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

			local ran, ret = pcall(code)

			if ran then
				return ret
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

function saveAllData()
	for name, data in next, saves do
		db.save(data.bin, name)
	end
end

function loadBot()
	local startMessage = format("%s %s %s\n", rep("-", 10), os.date("%m/%d/%Y %I:%M %p"), rep("-", 10))

	if bot.loaded then
		startMessage = format("\n%s", startMessage)
	end

	-- Initializes the bot
	bot.loaded = false
	print(startMessage)
	client:removeAllListeners()
	loadFile("./config.lua")

	-- Loads all extensions and utilities
	for _, folder in next, {"libs", "utils"} do
		for file, type in fs.scandirSync(format("./core/%s/", folder)) do
			if type == "file" then
				loadFile(format("./core/%s/%s", folder, file))
			end
		end
	end

	-- Loads all languages and listeners
	for _, folder in next, {"langs", "events"} do
		for file, type in fs.scandirSync(format("./%s/", folder)) do
			if type == "file" then
				loadFile(format("./%s/%s", folder, file))
			end
		end
	end

	-- Loads all mods from its categories
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

	-- Initializes the datastores
	saves.global = cache(db.load("global") or {}) -- Patrons and guilds data
	saves.economy = cache(db.load("economy") or {}) -- Servers economy and store items
	saves.clans = cache(db.load("clans") or {}) -- Servers clans data, membership and hierarchy
	saves.track = cache(db.load("track") or {}) -- Global trackers for mutes and bot data
	saves.temp = cache(db.load("temp") or {}) -- Temporary information and last command use
	bot.loaded = true
end

loadBot()
client:run(format("Bot %s", config.meta.token))
config.meta.token = nil

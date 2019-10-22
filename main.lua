-- Principais pontos de acesso para extensões
discordia = require("discordia")
client = discordia.Client(config.params)
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
startsWith = string.startswith
endsWith = string.endswith
split = string.split
trim = string.trim
pad = string.pad
levenshtein = string.levenshtein

-- Math
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

-- Table
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

-- Extensions
fs = require("fs")
query = require("querystring")
http = require("coro-http")
json = require("json")
timer = require("timer")
parse = require("url").parse
spawn = require("coro-spawn")

-- Trackers shortcuts
bot = {}
saves = {}

function wait(sec)
	return timer.sleep(sec * 1000)
end

function printf(text, ...)
	return print(format(text, ...))
end

randomSeed(os.time())

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

-- Saves all bot data
function saveAllData()
	for name, data in next, saves do
		db.save(data:raw(), name)
	end
end

-- Initializes the framework
function loadBot()
	-- Initialiazes the bot
	local startMessage = format("%s %s %s\n", rep("-", 10), os.date("%m/%d/%Y %I:%M %p"), rep("-", 10))

	bot.loaded = false
	print(format("\n%s", startMessage))
	client:removeAllListeners()
	loadFile("./config.lua")

	-- Loads all libraries and utilities
	for _, folder in next, {"libs", "utils"} do
		for file, type in fs.scandirSync(format("./core/%s/", folder)) do
			if type == "file" then
				loadFile(format("./core/%s/%s", folder, file))
			end
		end
	end

	-- Loads all languages and events
	for _, folder in next, {"langs", "events"} do
		for file, type in fs.scandirSync(format("./%s/", folder)) do
			if type == "file" then
				loadFile(format("./%s/%s", folder, file))
			end
		end
	end

	-- Loads all commands
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

	-- Loads all data
	saves.global = cache(db.load("global") or {}) -- Patrons and guilds data
	saves.economy = cache(db.load("economy") or {}) -- Servers economy and store items
	saves.clans = cache(db.load("clans") or {}) -- Servers clans data, membership and hierarchy
	saves.track = cache(db.load("track") or {}) -- Global trackers for mutes and bot data
	saves.temp = cache(db.load("temp") or {}) -- Temporary information and last command use
	bot.loaded = true
end

-- Initializes the process
loadBot()
client:run(format("Bot %s", config.meta.token))
config.meta.token = nil

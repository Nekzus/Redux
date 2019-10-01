-- Core
discordia = require("discordia")
client = discordia.Client{cacheAllMembers = true, logLevel = 3, logFile = ""}
emitter = discordia.Emitter()
time = discordia.Time()
enums = discordia.enums
discordia.extensions()

-- String
format = string.format
match = string.match
gsub = string.gsub
gmatch = string.gmatch
rep = string.rep
sub = string.sub
find = string.find

-- Math
random = math.random
seed = math.randomseed
max = math.max
min = math.min
modf = math.modf

-- Table
insert = table.insert
remove = table.remove
concat = table.concat
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

math.randomseed(os.time())

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

			local ran, err = pcall(code)

			if ran then
				return ran
			else
				printf("RUNTIME ERROR: %s | %s", fileName, err)

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

	bot.loaded = false
	print(startMessage)
	client:removeAllListeners()
	loadFile("./config.lua")

	-- Loads the core functionalities
	for _, folder in next, {"core", "langs", "events"} do
		for file, type in fs.scandirSync(format("./%s/", folder)) do
			if type == "file" then
				loadFile(format("./%s/%s", folder, file))
			end
		end
	end

	-- Loads in the mods
	for _, folder in next, {"base", "economy", "entertainment", "moderation"} do
		for file, type in fs.scandirSync(format("./mods/%s/", folder)) do
			if type == "file" then
				local mod = loadFile(format("./%s/%s", folder, file))

				mod.config.category = format("${%s}", folder)
				command:create(mod.config)
			end
		end
	end

	saves.global = cache(db.load("global") or {}) -- Patrons and guilds data
	saves.economy = cache(db.load("economy") or {}) -- Servers economy and store items
	saves.clans = cache(db.load("clans") or {}) -- Servers clans data, membership and hierarchy
	saves.track = cache(db.load("track") or {}) -- Global trackers for mutes and bot data
	saves.temp = cache(db.load("temp") or {}) -- Temporary information and last command use
	bot.loaded = true
end

function loadBot()
	local startupMessage = format("%s %s %s\n", rep("-", 10), os.date("%m/%d/%Y %I:%M %p"), rep("-", 10))

	if bot.loaded then
		startupMessage = format("\n%s", startupMessage)
	end

	bot.loaded = false
	print(startupMessage)
	client:removeAllListeners()
	loadFile("./config.lua")

	for _, folder in next, {"core", "langs", "mods", "events"} do
		for file, type in fs.scandirSync(format("./%s/", folder)) do
			if type == "file" then
				loadFile(format("./%s/%s", folder, file))
			end
		end
	end

	saves.global = cache(db.load("global") or {}) -- Patrons and guilds data
	saves.economy = cache(db.load("economy") or {}) -- Servers economy and store items
	saves.clans = cache(db.load("clans") or {}) -- Servers clans data, membership and hierarchy
	saves.track = cache(db.load("track") or {}) -- Global trackers for mutes and bot data
	saves.temp = cache(db.load("temp") or {}) -- Temporary information and last command use

	bot.loaded = true
end

coroutine.wrap(function()
	loadBot()
	client:run(format("Bot %s", config.meta.token))
	config.meta.token = nil
end)()

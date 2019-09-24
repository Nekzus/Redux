-- VOICE LOAD https://github.com/rokf/nandek/blob/master/bot.lua
-- https://github.com/fabiocolacio/discord-sound-board/blob/master/discord_sound_board.lua

function getRole(value, key, guild)
   return guild.roles:find(function(r)
      return r[key] == value
   end)
end

function getEmoji(value, key, guild)
   return guild.emojis:find(function(r)
      return r[key] == value
   end)
end

function getTextChannel(value, key, guild)
   return guild.textChannels:find(function(r)
      return r[key] == value
   end)
end

function getGuildData(guild)
   local guildId = (type(guild) == "string" and guild) or (type(guild) == "table" and guild.id)
   local guildData = saves.global:get(guildId)
   local guildRoles = guildData:get("roles")
   local guildMutes = guildData:get("mutes")

   for k, v in next, config.default do
      guildData:get(k, v)
   end

   for roleId, _ in next, guildRoles:raw() do
      if not getRole(roleId, "id", guild) then
         guildRoles:set(roleId, nil)
      end
   end

   return guildData
end

function getGuildEconomy(guild)
   local guildId = (type(guild) == "string" and guild) or (type(guild) == "table" and guild.id)
   local guildData = saves.economy:get(guildId, config.economyDefault)

   for k, v in next, config.economyDefault do
      guildData:get(k, v)
   end

   return guildData
end

function getMemberEconomy(member, guild)
   local guildData = getGuildEconomy(guild)
   local memberData = guildData:get("users"):get(member.id)

   return memberData, guildData
end

--[[function getClanData(member, clanId)
	local clanData = saves.clans:get(clanId)
end]]

function getColor(text)
   local ret = {match(text or config.colors.grey, config.patterns.colorRGB.capture)}

   if #ret == 3 then
      return discordia.Color.fromRGB(unpack(ret)).value
   else
      return discordia.Color.fromRGB(unpack(
         ret[1] or random(255),
         ret[2] or random(255),
         ret[3] or random(255)
      ))
   end
end

function getMemberLevel(member, guild)
   local guildData = getGuildData(guild)
   local guildRoles = guildData:get("roles")

   local rLevel, rRole = 0

   member = member.highestRole and member or guild:getMember(member)

   if member.id == client.owner.id then
      rLevel = config.titles.dev.level
   elseif member.id == guild.owner.id then
      rLevel = config.titles.owner.level
   end

   for roleId, roleData in next, guildRoles:raw() do
      local role = getRole(roleId, "id", guild)

      if member:hasRole(roleId) then
         if roleData.level > rLevel then
            rLevel = roleData.level
            rRole = role
         end
      end
   end

   return rLevel, rRole
end

function getHighestRoleIndex(level, list)
   local roleId = false
   local added

   for k, v in next, list do
      if v.level and v.level == level then
         if v.added and (added == nil or (v.added > added)) then
            added = v.added
            roleId = k
         end
      end
   end

   return roleId
end

function getPrimaryRoleIndex(level, list)
   local roleId = false
   local added

   for k, v in next, list do
      if v.level and v.level == level then
         if v.added and (added == nil or (v.added < added)) then
            added = v.added
            roleId = k
         end
      end
   end

   return roleId
end

function getMatchingRoleTitle(num)
   for k, v in next, config.titles do
      if v.level == num then
         return v.title
      end
   end

   return nil
end

function getRoleIndexHigherThan(level, list, reference)
   local roleId = false
   local added

   for k, v in next, list do
      if v.level and v.level == level then
         if v.added and (added == nil or (v.added < added)) then
            if (reference and v.added > reference) or reference == nil then
               added = v.added
               roleId = k
            end
         end
      end
   end

   return roleId
end

function getRoleIndexLowerThan(level, list, reference)
   local roleId = false
   local added

   for k, v in next, list do
      if v.level and v.level == level then
         if v.added and (added == nil or (v.added > added)) then
            if (reference and v.added < reference) or reference == nil then
               added = v.added
               roleId = k
            end
         end
      end
   end

   return roleId
end

function getUserDefinedRoles(member, guild)
   local guildData = getGuildData(guild)

   if not guildData then
      printf("Could not find guildData for guild '%s'", guild.name)

      return false
   end

   local ret = {}

   for obj in member.roles:iter() do
      local roleExists = getRole(obj.id, "id", guild)
      local guildRoles = guildData:get("roles"):raw()
      local guildRole = guildRoles[obj.id]

      if roleExists and guildRole then
         local isPrimary = getPrimaryRoleIndex(guildRole.level, guildRoles) == roleId

         insert(ret, {id = obj.id, level = guildRole.level, primary = isPrimary, added = guildRole.added})
      end
   end

   if #ret > 1 then
      sort(ret, function(a, b)
         return a.level > b.level or (a.level == b.level and a.added > b.added)
      end)
   end

   return ret
end

function getGuildDefinedRoles(guild)
   local guildData = getGuildData(guild)

   if not guildData then
      printf("Could not find guildData for guild '%s'", guild.name)

      return false
   end

   local ret = {}

   for roleId, roleData in next, guildData:get("roles"):raw() do
      local roleExists = getRole(roleId, "id", guild)
      local guildRoles = guildData:get("roles"):raw()

      if roleExists then
         local isPrimary = getPrimaryRoleIndex(roleData.level, guildRoles) == roleId

         insert(ret, {id = roleId, level = roleData.level, primary = isPrimary, added = roleData.added})
      end
   end

   if #ret > 1 then
      sort(ret, function(a, b)
         return a.level > b.level or (a.level == b.level and a.added > b.added)
      end)
   end

   return ret
end

function getMatchingDiscordError(text, list)
   for k, v in next, list do
      if k:find(text) then
         return v
      end
   end

   return nil
end

function getMatchingLevelTitle(level)
   for k, v in next, config.titles do
      if v.level == level then
         return v.title
      end
   end

   return nil
end

function isOnline(member)
   return member.status ~= "offline"
end

function isRoleColored(role)
   return role.color > 0
end

function isPrivateChat(channel)
   return channel and channel.type == enums.channelType.private or false
end

function parseText(text, pattern, list, f)
   return (text:gsub(pattern, function(word)
      if f then
      return f(list[word:sub(3, - 2)] or word)
   else
      return list[word:sub(3, - 2)] or word
   end
end))
end

function parseFormat(text, list, ...)
assert(text, "Must provide a text")
assert(list, "Must provide a replacement list")

local replace = {
   ["($%b{})"] = function(text) return text end,
   ["($%b<>)"] = function(text) return string.lower(text) end,
   ["($%b[])"] = function(text) return string.upper(text) end,
}

for pattern, f in next, replace do
   if text:find(pattern) then
      text = parseText(text, pattern, list, f)
   end
end

return #{...} > 0 and text:format(...) or text
end

function signFooter(embed, author, lang)
embed:timestamp(discordia.Date():toISO("T", "Z"))
embed:footer(parseFormat("${commandRanBy}", langs[lang or config.default.lang], author.tag))

return embed
end

function replyEmbed(text, message, method)
local embed = newEmbed()
local private = isPrivateChannel(message.channel)
local guildData = not private and getGuildData(message.guild)
local guildLang = guildData and guildData:get("lang") or config.default.lang
local color

if method == "ok" then
   color = config.colors.green
elseif method == "warn" then
   color = config.colors.yellow
elseif method == "error" then
   color = config.colors.red
elseif method == "no" then
   color = config.colors.red2
elseif method == "info" then
   color = config.colors.blue
end

embed:color(color:match(config.patterns.colorRGB.capture))
embed:footerIcon(config.images[method] or message.author.avatarURL)
if text then
   embed:description(text)
end
signFooter(embed, message.author, guildLang)

return embed
end

function getLoadingEmoji()
return getEmoji(config.emojis.loading, "name", baseGuild).mentionString
end

function isPatron(id)
return saves.track:get("patrons"):raw()[id] ~= nil
end

function canRunCommand(data)
local permit = false
local private = isPrivateChannel(data.channel)
local userLevel = not private and getMemberLevel(data.user, data.guild) or 0
local commandPatron = false
local commandName = data.command:lower():sub(2)
local commandData = commandName and commands.list[commandName]
local commandLevel = commandData and commandData.level

if not (userLevel and commandData and data) then
   return false, printf("Missing arguments on canRunCommand()")
end

local member = data.user
local patron = data.member and isPatron(data.member) or (userLevel >= 255)

if userLevel then
   if commandData.level then
      if type(commandData.level) == "number" and userLevel >= commandData.level then
         if commandData.patron then
            commandPatron = true

            if private then
               if commandData.allowDm then
                  if patron then
                     permit = true
                  end
               end
            else
               if patron then
                  permit = true
               end
            end
         else
            if private then
               if commandData.allowDm then
                  permit = true
               end
            else
               permit = true
            end
         end
      end
   else
      if commandData.patron then
         commandPatron = true

         if private then
            if commandData.allowDm then
               if patron then
                  permit = true
               end
            end
         else
            if patron then
               permit = true
            end
         end
      else
         if private then
            if commandData.allowDm then
               permit = true
            end
         else
            permit = true
         end
      end
   end
end

return permit, commandPatron
end

function isCommandRestrict(commandData, lang)
local restricted = true

if commandData.restrict then
   for k, v in next, commandData.restrict do
      if v == lang then
         restricted = false
         break
      end
   end
else
   restricted = false
end

return restricted
end

function canUseCommand(command, member)
local usersData = saves.temp:get("users")
local userData = usersData:get(member.id)
local commandsUsed = userData:get("commandsUsed")
local commandData = commands.list[command]

if not commandData then
   printf("Could not find command '%s'", command)

   return false
elseif commandData.alias then
   command = commandData.origin
   commandData = commands.list[command]
end

local permit = false
local newTime = os.time()
local cooldown = commandData.cd or 0
local commandUsedData = commandsUsed:raw()[command]
local elapsedTime, lastUse

if commandUsedData then
   lastUse = commandUsedData.lastUse
   elapsedTime = newTime - lastUse

   if not lastUse then
      permit = true
   elseif elapsedTime >= cooldown then
      permit = true
   end
else
   permit = true
end

return permit, not permit and (cooldown - elapsedTime)
end

function updateCommandCooldown(command, member)
local usersData = saves.temp:get("users")
local userData = usersData:get(member.id)
local commandsUsed = userData:get("commandsUsed")
local commandData = commands.list[command]

if not commandData then
   printf("Could not find command '%s'", command)

   return false
end

if commandData.cd then
   commandsUsed:set(commandData.origin or command, {lastUse = os.time()})
end

clearTempCommandsUsed(member)
end

function clearTempCommandsUsed(member)
local usersData = saves.temp:get("users")
local userData = usersData:get(member.id)
local commandsUsed = userData:get("commandsUsed")

for k, v in next, commandsUsed:raw() do
   if canUseCommand(k, member) then
      commandsUsed:set(k, nil)
   end
end
end

function canUseEconomyCommand(command, member, guild)
local memberEconomy, guildEconomy = getMemberEconomy(member, guild)
local commandsUsed = memberEconomy:get("commandsUsed")
local commandData = commands.list[command]

if not commandData then
   printf("Could not find command '%s'", command)

   return false
end

if commandData.alias then
   command = commandData.origin
   commandData = commands.list[command]
end

commandData = config.economyDefault.actions[command] and guildEconomy:get("actions"):raw()[command]

if not commandData then
   printf("Could not find action '%s'", command)

   return false
end

local permit = false
local newTime = os.time()
local cooldown = commandData.cd or 0
local commandUsedData = commandsUsed:raw()[command]
local elapsedTime, lastUse

if commandUsedData then
   lastUse = commandUsedData.lastUse
   elapsedTime = newTime - lastUse

   if not lastUse then
      permit = true
   elseif elapsedTime >= cooldown then
      permit = true
   end
else
   permit = true
end

return permit, not permit and (cooldown - elapsedTime)
end

function updateEconomyCommandCooldown(command, member, guild)
local memberEconomy, guildEconomy = getMemberEconomy(member, guild)
local commandsUsed = memberEconomy:get("commandsUsed")
local commandData = commands.list[command]

if commandData.alias then
   command = commandData.origin
   commandData = commands.list[command]
end

commandData = config.economyDefault.actions[command] and guildEconomy:get("actions"):raw()[command]

if not commandData then
   printf("Could not find command '%s'", command)

   return false
end

local commandUsedData = commandsUsed:get(command)

commandUsedData:set("lastUse", os.time())
clearEconomyCommandsUsed(member, guild)
end

function clearEconomyCommandsUsed(member, guild)
local memberEconomy, guildEconomy = getMemberEconomy(member, guild)
local commandsUsed = memberEconomy:get("commandsUsed")

for k, v in next, commandsUsed:raw() do
   if canUseEconomyCommand(k, member, guild) == true then
      commandsUsed:set(k, nil)
   end
end
end

function isPrivateChannel(channel)
return channel and channel.type == enums.channelType.private or false
end

function isFiltered(text, list)
text = text:lower()

for k, v in next, list do
   v = v:lower()

   if text:find(v) then
      return v, k
   end
end

return nil
end

function inList(value, list)
for k, v in next, list do
   if value == k then
      return v, k
   elseif value == v then
      return k, v
   end
end

return nil
end

function printLine(...)
local result = {}

for i = 1, select('#', ...) do
   insert(result, tostring(select(i, ...)))
end

return concat(result, '\t')
end

function codeStyle(text)
return format('```\n%s```', text)
end

function loadCode(code, message, extra)
if not message then
   print("Message not found for loadCode()")
end

if not code then
   return("Missing argument")
end

local output = {}
local ret = {}

if message.author.id == client.owner.id then
   ret = getfenv()
else
   ret.enums = enums
   ret.math = math
   ret.string = string
   ret.eval = eval
   ret.type = type
   ret.tostring = tostring
   ret.tonumber = tonumber
end

ret.message = message

if extra then
   for k, v in next, extra do
      ret[k] = v
   end
end

function ret.print(...)
   table.insert(output, printLine(...))
end

function ret.error(...)
   table.insert(output, printLine(...))
end

function ret.warn(...)
   table.insert(output, printLine(...))
end

local f, syntaxError = load(code:gsub('```\n?', ''), 'LuaSandbox', 't', ret)
local success, runtimeError = pcall(f)

if success then
   response = table.concat(output, '\n')

   if #response > 1990 then
      response = response:sub(1, 1990)
   end

   return true, codeStyle(response)
else
   return false, codeStyle(runtimeError)
end
end

function specifiesUser(message)
if not message.mentionsEveryone and message.mentionedUsers:iter()() then
   return true
end

return false
end

function mentionsOwner(message)
if message.mentionedUsers:iter()() == message.guild.owner.member then
   return true
end

return false
end

function mentionsBot(message)
if message.mentionedUsers:iter()() == client.member then
   return true
end

return false
end

function mentionsOtherBot(message)
if #message.mentionedUsers == 0 then
   return false
end

if message.mentionedUsers:iter()().bot then
   return true
end

return false
end

function mentionsSelf(message)
if message.mentionedUsers:iter()() == message.author then
   return true
end

return false
end

function paginate(list, perPage, page)
perPage = perPage or 10
page = page or 1

local endAt = (page * perPage)
local startAt = (endAt - (perPage - 1))
local rList = slice(list, startAt, endAt, 1)

return rList
end

-- https://en.wikipedia.org/wiki/Names_of_large_numbers
numAffixes = {
{key = "K", name = "Thousand"}, -- 10e3
{key = "M", name = "Million"}, -- 10e6
{key = "B", name = "Billion"}, -- 10e9
{key = "T", name = "Trillion"}, -- 10e12
{key = "Qa", name = "Quadrillion"}, -- 10e15
{key = "Qi", name = "Quintillion"}, -- 10e18
{key = "Sx", name = "Sextillion"}, -- 10e21
{key = "Sp", name = "Septillion"}, -- 10e24
{key = "Oc", name = "Octillion"}, -- 10e27
{key = "No", name = "Nonillion"}, -- 10e30
{key = "Dc", name = "Decillion"}, -- 10e33
{key = "Un", name = "Undecillion"}, -- 10e36
{key = "Du", name = "Duodecillion"}, -- 10e39
{key = "Tr", name = "Tredecillion"}, -- 10e42
{key = "Qad", name = "Quattuordecillion"}, -- 10e45
{key = "Qid", name = "Quinquadecillion"}, -- 10e48
{key = "Sd", name = "Sedecillion"}, -- 10e51
{key = "Spd", name = "Septendecillion"}, -- 10e54
{key = "Ocd", name = "Octodecillion"}, -- 10e57
{key = "Nvd", name = "Novendecillion"}, -- 10e60
{key = "V", name = "Vigintillion"}, -- 10e63
{key = "Unv", name = "Unvigintillion"}, -- 10e66
{key = "Duv", name = "Duovigintillion"}, -- 10e69
{key = "Trv", name = "Tresvigintillion"}, -- 10e72
{key = "Qav", name = "Quattuorvigintillion"}, -- 10e75
{key = "Qiv", name = "Quinquavigintillion"}, -- 10e78
{key = "Sev", name = "Sesvigintillion"}, -- 10e81
{key = "Spv", name = "Septemvigintillion"}, -- 10e84
{key = "Ocv", name = "Octovigintillion"}, -- 10e87
{key = "Nvv", name = "Novemvigintillion"}, -- 10e90
{key = "Trt", name = "Trigintillion"}, -- 10e93
{key = "Unt", name = "Untrigintillion"}, -- 10e96
{key = "Dut", name = "Duotrigintillion"}, -- 10e99
{key = "Trt", name = "Trestrigintillion"}, -- 10e102
{key = "Qat", name = "Quattuortrigintillion"}, -- 10e105
{key = "Qit", name = "Quinquatrigintillion"}, -- 10e108
{key = "Set", name = "Sestrigintillion"}, -- 10e111
{key = "Spt", name = "Septentrigintillion"}, -- 10e114
{key = "Oct", name = "Octotrintillion"}, -- 10e117
{key = "Nvt", name = "Noventrigintillion"}, -- 10e120
{key = "Qag", name = "Quadragintillion"}, -- 10e123
}

function affixNum(num)
if type(num) == "string" then
   num = tonumber(num)
elseif type(num) == "number" then
   num = num
else
   return false
end

local isNeg = false

if num < 1000 and num > - 1000 then
   return num
end

if num < 0 then
   isNeg = true
   num = num * - 1
end

num = num - num % 10

local affix = math.min(math.floor(math.log(math.abs(num)) / math.log(1000)), #numAffixes)

if isNeg then
   num = num * - 1
end

return string.format("%02.2f%s", (num / 1000 ^ affix), numAffixes[affix].key)
end

function realNum(text)
if type(text) == "string" then
   text = text
elseif type(text) == "number" then
   return text
else
   return false
end

local affix = text:match("%a+")
local num = text:match("[0-9]+[%p][0-9]+") or text:match("[0-9]+")
local sig = text:match("[%+|%-]")
local nAffix

if sig then
   num = format("%s%s", sig, num)
end

if num then
   num = tonumber(num)
else
   return false
end

if not affix then
   return num
end

for k, v in pairs(numAffixes) do
   if affix:lower() == v.key:lower() then
      nAffix = k
      break
   end
end

if not nAffix then
   return false
end

return num * (1000 ^ nAffix)
end

function abbrevNum(text, highestNum)
if type(text) == "string" then
   if text:lower() == "all" then
      text = highestNum
   elseif text:lower() == "half" then
      text = highestNum / 2
   elseif text:match("%d+%%") then
      text = text:match("%d+")

      if text then
         text = (text / 100) * highestNum
      end
   else
      text = realNum(text)
   end

   return text
end

return false
end

function timeLong(seconds)
seconds = seconds and tonumber(seconds) or 0

local result = ""

local days = math.floor(seconds / day)
local hours = math.floor(math.fmod(seconds, day) / hour)
local minutes = math.floor(math.fmod(seconds, hour) / minute)
local seconds = math.floor(math.fmod(seconds, minute))

if days > 0 then
   result = format("%s%s %s", result, tostring(days), days == 1 and "$<day>, " or "$<days>, ")
end

if hours > 0 then
   result = format("%s%s %s", result, tostring(hours), hours == 1 and "$<hour>, " or "$<hours>, ")
end

if minutes > 0 then
   result = format("%s%s %s", result, tostring(minutes), minutes == 1 and "$<minute>, " or "$<minutes>, ")
end

if seconds > 0 then
   result = format("%s%s %s", result, tostring(seconds), seconds == 1 and "$<second>, " or "$<seconds>, ")
end

if result == "" then
   return "0 $<seconds>"
else
   return result:sub(1, - 3)
end
end

timeInterps = {
second = second,
minute = minute,
hour = hour,
day = day,
week = week,
month = month,
year = year,
}

function interpTime(text)
local totalTime = 0

for formula in text:gmatch(config.patterns.mute.base) do
   local num, key = formula:match(config.patterns.mute.capture)

   if key then
      for k, v in next, timeInterps do
         if k:sub(1, #key) == key then
            totalTime = totalTime + num * v
            break
         end
      end
   end
end

if totalTime <= 0 then
   local match = text:match("%d+")

   if match then
      totalTime = (totalTime + (tonumber(match))) * hour
   else
      totalTime = 60 * 60
   end
end

return totalTime
end

--[[
	{
		added = os.time,
		duration = seconds,
		reason = text,
		moderator = id,
	}
]]
muteTimers = muteTimers or {}

function handleMuteData(muteData)
if not muteData.guild then
   print("Guild for muteData not found")

   return false
end

local guild = client:getGuild(muteData.guild)
local guildData = getGuildData(guild)
local tempMutes = saves.temp:get("mutes")
local member = guild:getMember(muteData.user)

local newTime = os.time()
local elapsedTime = newTime - muteData.added
local roleId = getPrimaryRoleIndex(-1, guildData:get("roles"):raw())
local role = roleId and getRole(roleId, "id", guild)

if not role then
   guildData.mutes[member.id] = nil

   return false
end

if elapsedTime >= muteData.duration then
   guildData:get("mutes"):set(member.id, nil)
   tempMutes:set(muteData.guid, nil)

   if role and member:hasRole(roleId) then
      member:removeRole(role)
   end

   return true
end

-- :stop() :close()
local process = timer.setTimeout((muteData.duration - elapsedTime) * 1000, function()
   coroutine.wrap(function()
   guildData:get("mutes"):set(member.id, nil)
   tempMutes:set(muteData.guid, nil)

   if role and member:hasRole(roleId) then
      member:removeRole(role)
   end
end)()
end
)

muteTimers[muteData.guid] = process

return process
end

client:on("messageCreate", function(message)
if message.author == client.user then
return
end

if message.author.bot then
return
end

if baseGuild == nil then
baseGuild = client:getGuild(config.meta.baseGuild)
timer.sleep(1000)
end

local data = {
message = message,
content = message.content,
user = message.member or message.author,
author = message.author,
member = message.member,
channel = message.channel,
guild = message.guild,
args = message.content:split(" "),
command = message.content:split(" ")[1],
}

local private = data.member == nil
local guildData = not private and getGuildData(data.guild)
local guildLang = not private and guildData and guildData:get("lang") or config.default.lang
local langList = langs[guildLang]
local deleteCommand = not private and guildData:get("deleteCommand", false) or false

if not private then
data.guildData = guildData
data.guildLang = guildLang
data.prefix = guildData:raw().prefix
else
data.guildLang = config.default.lang
data.prefix = config.default.prefix
end

local commandPrefix = data.prefix
local commandName = data.command:lower():sub(2)
local commandData = commandName and commands.list[commandName]
local commandCategory = commandData and commandData.category:match("%w+")

if commandData and (data.command:lower() == format("%s%s", commandPrefix, commandName:lower())) then
local userData = saves.temp:get(format("users/%s", data.user.id))
local commandPermit, commandPatron = canRunCommand(data)

if not bot.loaded then
data.channel:reply("Bot is restarting, please try again in a few seconds..")

return false
end

if not commandPermit then
if commandPatron then
local text = parseFormat("${noPerm}; ${patronsOnlyCommand}", langList)
local embed = replyEmbed(text, message, "error")

bird:post(nil, embed:raw(), data.channel)
else
local text = parseFormat("${noPerm}", langList)
local embed = replyEmbed(text, message, "error")
bird:post(nil, embed:raw(), data.channel)
end

if deleteCommand == true then
message:delete()
end

return false

elseif isCommandRestrict(commandData, guildLang) then
local text = parseFormat("${notAvailableLang}", langList)
local embed = replyEmbed(text, message, "warn")

return bird:post(nil, embed:raw(), data.channel)
end

if private and not commandData.allowDm then
if deleteCommand == true then
message:delete()
end

local text = parseFormat("${executeFromGuild}", langList)
local embed = replyEmbed(text, message, "error")

return bird:post(nil, embed:raw(), data.channel)
end

if commandCategory then
if commandCategory == "economy" then
if config.economyDefault.actions[commandName] then
   local canUse, timeLeft = canUseEconomyCommand(commandName, data.user, data.guild)

   if not canUse then
      local text = parseFormat("${commandCooldownFor}", langList, timeLeft)
      local embed = replyEmbed(text, data.message, "warn")

      return bird:post(nil, embed:raw(), data.channel)
   end
end
else
local canUse, timeLeft = canUseCommand(commandName, data.author)

if canUse then
   updateCommandCooldown(commandName, data.user)
else
   local text = parseFormat("${commandCooldownFor}", langList, timeLeft)
   local embed = replyEmbed(text, data.message, "warn")

   return bird:post(nil, embed:raw(), data.channel)
end
end
end

local success, commandError = pcall(commandData.func, data)
deleteCommand = not private and guildData:get("deleteCommand", false) or false

if not success then
printf("\nCommand Error: '%s' --> %s\nInformation: '%s' --> %s", commandName, commandError, data.author.tag, data.message.content)
end

if not private then
deleteCommand = guildData:get("deleteCommand", false)

if deleteCommand == true then
message:delete()
end
end
end
end)

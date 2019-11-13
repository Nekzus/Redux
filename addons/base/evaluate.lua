local _config = {
	name = "evaluate",
	desc = "${evalsMath}",
	usage = "${pageKey}",
	aliases = {"eval", "exp", "lua", "math"},
	cooldown = 0,
	level = 0,
	direct = true,
}

local function getCtxDefault()
	return {
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
		log10 = math.log10
		max = math.max
		min = math.min
		modf = math.modf
		pi = math.pi
		rad = math.rad
		random = math.random
		randomSeed = math.randomseed
		sin = math.sin
		sqrt = math.sqrt
		tan = math.tan
	}
end

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local langData = langs[guildLang]
	local args = data.args

	if not (args[2]) then
		local text = parseFormat("${missingArg}", langData)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	--[[evalContext = evalContext or setmetatable({
		count = 0
	}, {
		__newindex = function(list, key, value)
			if list == self then
				if count >= 100 then
					remove(self, 1)
					count = count - 1
				end

				list[key] = value
				count = count + 1
			else
				list[key] = value
			end
		end
	})]]

	evalContext = evalContext or {}

	if inList(args[2]:lower(), {"reset", "new", "restart", "clear"}) then
		evalContext[data.author.id] = getCtxDefault()

		return true
	end

	local userContext = evalContext[data.author.id]

	if not userContext then
		userContext = getCtxDefault()
		evalContext[data.author.id] = userContext
	end

	local input = data.content:sub(#args[1] + 2)
	local result, err = pcall(luaxp.evaluate, tostring(input), userContext)
	local embed = replyEmbed(nil, data.message, "ok")

	embed:field({
		name = parseFormat("${inputResult}", langData),
		value = format("```%s```", input),
		inline = true
	})
	embed:field({
		name = parseFormat("${outputResult}", langData),
		value = format("```%s```", result or err and err.message),
		inline = true
	})

	if result then
		embed:color(config.colors.blue)
		embed:footerIcon(config.images.info)
	elseif err then
		embed:color(config.colors.red)
		embed:footerIcon(config.images.error)
	end

	signFooter(embed, data.author, guildLang)

	bird:post(nil, embed:raw(), data.channel)

	return true
end

return {config = _config, func = _function}

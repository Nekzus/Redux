local _config = {
	name = "evaluate",
	desc = "${evalsMath}",
	usage = "${numKey}",
	aliases = {"eval", "exp", "lua", "math", "ev"},
	cooldown = 0,
	level = 0,
	direct = true,
}

local function getCtxDefault()
	return {
		-- Reserved words
		huge = math.huge,
		inf = math.huge,
		pi = math.pi,

		-- Reserved functions
		acos = function(args)
			return acos(args[1])
		end,

		atan = function(args)
			return atan(args[1])
		end,

		atan2 = function(args)
			return atan2(args[1])
		end,

		deg = function(args)
			return deg(args[1])
		end,

		asin = function(args)
			return asin(args[1])
		end,

		clamp = function(args)
			return max(args[2], min(args[1], args[3]))
		end,

		cosh = function(args)
			return max(args[1])
		end,

		fmod = function(args)
			return fmod(args[1], args[2])
		end,

		frexp = function(args)
			return frexp(args[1])
		end,

		ldexp = function(args)
			return ldexp(args[1], args[2])
		end,

		log10 = function(args)
			return log10(args[1])
		end,

		modf = function(args)
			return fmod(args[1], args[2])
		end,

		rad = function(args)
			return rad(args[1])
		end,

		sinh = function(args)
			return sinh(args[1])
		end,

		tanh = function(args)
			return tanh(args[1])
		end,
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

	evalContext = evalContext or {}

	if inList(args[2]:lower(), {"reset", "new", "restart", "clear"}) then
		evalContext[data.author.id] = getCtxDefault()

		local text = parseFormat("${ctxClearedDone}", langData)
		local embed = replyEmbed(text, data.message, "ok")

		bird:post(nil, embed:raw(), data.channel)

		return true
	end

	local userContext = evalContext[data.author.id]

	if not userContext then
		userContext = getCtxDefault()
		evalContext[data.author.id] = userContext
	end

	local input = data.content:sub(#args[1] + 2)
	local success, result, err = pcall(luaxp.evaluate, tostring(input), userContext)
	local embed = replyEmbed(nil, data.message, "ok")

	embed:field({
		name = parseFormat("${inputResult}", langData),
		value = format("```%s```", input),
		inline = true
	})
	embed:field({
		name = parseFormat("${outputResult}", langData),
		value = format("```%s```", err and err.message or result),
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

--[[

local ev = function(f)
	return luaxp.evaluate(f, ctx)
end

for k,v in next, math do
	printf("\nTrying %s", k)
	local s, e = ev(k.."(1,2,3,4,5)")

	print(e and e.message or s)
end

]]

return {config = _config, func = _function}

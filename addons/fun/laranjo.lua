local _config = {
	name = "laranjo",
	desc = "${laranjosText}",
	usage = "${messageKey}",
	aliases = {"lar"},
	restrict = {"pt-br"},
	cooldown = 0,
	level = 0,
	direct = true,
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local langData = langs[guildLang]
	local args = data.args

	local text = data.content:sub(#args[1] + 2):lower()
	local replaces = {
		["filho"] = "fio",
		["inho%s"] = "in ",
		["moral"] = "molau",
		["gostar"] = "gosta",
		["droga"] = "dorga",
		["tomar"] = "toma",
		["jog"] = "xog",
		["morada"] = "molada",
		["mãe"] = "mai",
		["mae"] = "mai",
		["via"] = "fia",
		["dinh"] = "tinh",
		["viad"] = "fiat",
		["sexual"] = "sexu uau",
		["aparentemente"] = "apaentimenti",
		["virtu"] = "vitu",
		["vazi"] = "fasi",
		["alvez"] = "alveis",
		["nheci"] = "nhesi",
		["para"] = "pa",
		["import"] = "impot",
		["hoje"] = "oje",
		["guês"] = "gueis",
		["escreve"] = "esqueve",
		["otario"] = "otairu",
		["pergunt"] = "pegunt",
		["vamo"] = "famu",
		["voce"] = "fose",
		["vc"] = "fose",
		["você"] = "fose",
		["iau"] = "inhau",
		["ch"] = "x",
		["ão"] = "au",
		["ç"] = "s",
		["ss"] = "ç",
		["tou"] = "to",
		["desde"] = "desd",
		["demonio"] = "the monio",
		["demônio"] = "the monio",
		["baby"] = "beibe",
		["me fudend"] = "mifu den",
		["gay"] = "guei",
		["olha"] = "oia",
		["pra"] = "pa",
		["fica"] = "fika",
		["qu"] = "k",
		["esto"] = "sto",
		["esta"] = "sta",
		["está"] = "stá",
		["com"] = "co",
		["bom"] = "baum",
		["voc"] = "oc",
		["endo"] = "eno",
		["oda"] = "ota",
		["todo"] = "tudu",
		["alho"] = "aiu",
		["filha"] = "fia",
		["filho"] = "fio",
		["er"] = "e",
		["êr"] = "ê",
		["ou"] = "o",
		["é"] = "eh",
		["rr"] = "r",
		["ado"] = "adu",
		["can"] = "kan",
		["boa"] = "poa",
	}

	if isFiltered(text, {"http://", "https://"}) then
		local text = parseFormat("${linksNotSupported}", langData)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	for word, replace in pairs(replaces) do
		text = text:gsub(word, replace)
	end

	local embed = replyEmbed(text, data.message, "ok")

	embed:thumbnail(config.images.laranjo)

	bird:post(nil, embed:raw(), data.channel)

	return true
end

return {config = _config, func = _function}

local _config = {
	name = "vemzap",
	desc = "${zappifiesText}",
	usage = "${messageKey}",
	aliases = {"zap"},
	cooldown = 0,
	level = 0,
	direct = true,
	restrict = {"pt-br"},
}

local fullMatch = {
	["100"] = {"💯"},
	["alface"] = {"🥗"},
	["alvo"] = {"🎯"},
	["amo"] = {"😍", "😻", "😘", "😗", "😙", "😚", "💘	", "❤", "💓", "💕", "💖", "💖"},
	["amor"] = {"😍", "😻", "😘", "😗", "😙", "😚", "💘	", "❤", "💓", "💕", "💖", "💖"},
	["ap"] = {"🏢"},
	["ape"] = {"🏢"},
	["apice"] = {"🔝", "🏔", "⛰", "🗻"},
	["arma"] = {"🔫", "🔪", "💣💥"},
	["avalanche"] = {"🏔", "❄", "☃"},
	["banda"] = {"🎷", "🎸", "🎹", "🎺", "🎻", "🥁", "🎼", "🎵", "🎶", "🎤"},
	["bandas"] = {"🎷", "🎸", "🎹", "🎺", "🎻", "🥁", "🎼", "🎵", "🎶", "🎤"},
	["banheira"] = {"🛁"},
	["banheiro"] = {"🚽"},
	["banho"] = {"🚿", "🛁", "🧖‍♂️", "🧖‍♀️"},
	["bar"] = {"🍺", "🍻", "🥃", "🍾", "🤢"},
	["beber"] = {"🍺", "🍻", "🥃", "🍾", "🤢"},
	["bem"] = {"☺"},
	["boa"] = {"🤙"},
	["bolsa"] = {"👜", "👝"},
	["bravo"] = {"😤", "😤💦", "😖", "🙁", "😩", "😦", "😡", "👺", "💣", "💢", "✋🛑", "☠"},
	["bumbum"] = {"😮", "😏"},
	["carro"] = {"🚐", "🚗"},
	["casa"] = {"😋"},
	["casal"] = {"💑"},
	["caso"] = {"💑"},
	["celular"] = {"📱"},
	["cerebro"] = {"🧠", "💭"},
	["chama"] = {"📞", "☎"},
	["chef"] = {"👨‍🍳", "👩‍🍳"},
	["ciencia"] = {"👩‍🔬", "👨‍🔬", "⚗", "🔬", "🔭", "📡"},
	["classe"] = {"📚", "📘"},
	["consciencia"] = {"🧠", "💭"},
	["coracao"] = {"💘	", "❤", "💓", "💕", "💖", "💖"},
	["corra"] = {"🏃"},
	["corre"] = {"🏃"},
	["croissant"] = {"🥐"},
	["dado"] = {"🎲"},
	["data"] = {"📅", "🗓"},
	["dinheiro"] = {"💳", "💵", "💰", "💲"},
	["embuste"] = {"😭", "🤢", "💥", "😘", "😜"},
	["escola"] = {"👨‍🎓", "👩‍🎓", "📚", "📘", "🏫"},
	["faculdade"] = {"👨‍🎓", "👩‍🎓", "📚", "📘"},
	["feio"] = {"😛"},
	["feia"] = {"😛"},
	["fora"] = {"👉"},
	["fim"] = {"🙅‍♂️", "🙅‍♀️"},
	["já"] = {"⏰"},
	["internet"] = {"🌐"},
	["madame"] = {"🌹"},
	["marcial"] = {"💪"},
	["marciais"] = {"💪"},
	["mente"] = {"🧠", "💭"},
	["moca"] = {"🌹"},
	["mundo"] = {"🌍"},
	["nada"] = {"😮"},
	["nao"] = {"⛔", "🚫", "🛑", "✋", "✋🛑", "⚠"},
	["oi"] = {"😏", "😉"},
	["ok"] = {"👌"},
	["papo"] = {"💬"},
	["parabens"] = {"🎈", "🎉", "🎊", "👏"},
	["pc"] = {"💻", "🖥", "🖱⌨", "💾", "👨‍💻", "👩‍💻"},
	["planeta"] = {"🌍"},
	["preco"] = {"💳", "💵", "💰", "💲"},
	["princesa"] = {"👸"},
	["principe"] = {"🤴"},
	["quer"] = {"😏"},
	["raio"] = {"⚡"},
	["ri"] = {"😅", "😂", "🤣"},
	["rir"] = {"😅", "😂", "🤣"},
	["risada"] = {"😅", "😂", "🤣"},
	["riso"] = {"😅", "😂", "🤣"},
	["rola"] = {"😒", "😝", "👉👌"},
	["sai"] = {"🚫", "⛔"},
	["saliente"] = {"😋"},
	["secreto"] = {"🕵️‍"},
	["sera"] = {"🤨", "🤔", "🧐"},
	["sexo"] = {"😆", "👉👌"},
	["soco"] = {"🥊"},
	["sono"] = {"💤"},
	["sos"] = {"🆘"},
	["susto"] = {"😱", "🎃"},
	["terra"] = {"🌍"},
	["tesao"] = {"🌚"},
	["tiro"] = {"🔫"},
	["tomar"] = {"🍺", "🍻"},
	["topo"] = {"🔝", "🏔", "⛰", "🗻"},
	["ve"] = {"👀", "👁"},
	["vem"] = {"🚐", "🏎"},
	["ver"] = {"👀👀", "👀"},
	["voce"] = {"👉"},
	["zumbi"] = {"🧟‍♂️", "🧟‍♀️"},
	["meu"] = {"😌", "😇", "😍", "😻", "😘", "😗", "😙", "😚"},
	["minha"] = {"😌", "😇", "😍", "😻", "😘", "😗", "😙", "😚"},
	["grande"] = {"😎", "👍", "👌"},

	-- Abreviações/Girias
	["aff"] = {"🙄"},
	["bb"] = {"👶", "😍", "😂", "😜", "💘"},
	["caraio"] = {"😜", "😩", "😖", "☹", "😛", "😏", "😞"},
	["caralho"] = {"😜", "😩", "😖", "☹", "😛", "😏", "😞"},
	["escroto"] = {"👺", "👹", "👿"},
	["lol"] = {"😅", "😂", "🤣"},
	["mozao"] = {"💘", "❤", "💓", "💕", "💖", "💖"},
	["top"] = {"😂👌", "👌", "🔝", "🤑"},
	["topper"] = {"😂👌", "👌", "🔝", "🤑"},
	["topperson"] = {"😂👌", "👌", "🔝", "😛", "🤑"},
	["toppersson"] = {"😂👌", "👌", "🔝", "😛", "🤑"},
	["uau"] = {"😋"},
	["wow"] = {"😋"},

	-- Comidas
	["abacate"] = {"🥑"},
	["amendoim"] = {"🥜"},
	["bacon"] = {"🥓"},
	["batata"] = {"🍟", "🥔"},
	["berinjela"] = {"🍆"},
	["biscoito"] = {"🍪"},
	["bolacha"] = {"🍪"},
	["brocolis"] = {"🥦"},
	["castanha"] = {"🌰"},
	["cenoura"] = {"🥕"},
	["cerveja"] = {"🍺", "🍻"},
	["cogumelo"] = {"🍄"},
	["doce"] = {"🍦", "🍧", "🍨", "🍩", "🍪", "🎂", "🍰", "🥧", "🍫", "🍬", "🍭", "🍮", "🍯"},
	["ovo"] = {"🥚", "🍳"},
	["pepino"] = {"🥒"},
	["pizza"] = {"🍕"},
	["pretzel"] = {"🥨"},
	["salada"] = {"🥗"},
	["sanduiche"] = {"🥪"},
	["sushi"] = {"🍣", "🍙", "🍱", "🍘"},
	["trato"] = {"🤝"},

	-- Empresas
	["aliexpress"] = {"🇨🇳"},
	["donalds"] = {"🍔🍟"},
	["globo"] = {"🌍"},
	["mcdonalds"] = {"🍔🍟"},
	["sedex"] = {"📦", "📬"},

	-- Esportes
	["basquete"] = {"🏀"},
	["futebol"] = {"⚽"},
	["volei"] = {"🏐"},

	-- Signos
	["aries"] = {"♈"},
	["touro"] = {"♉"},
	["gemeos"] = {"♊"},
	["cancer"] = {"♋"},
	["leao"] = {"♌"},
	["virgem"] = {"♍"},
	["libra"] = {"♎"},
	["escorpiao"] = {"♏"},
	["sagitario"] = {"♐"},
	["capricornio"] = {"♑"},
	["aquario"] = {"♒"},
	["peixes"] = {"♓"},

	-- Personagens
	["bolsonaro"] = {"🚫🏳️‍🌈", "🔫"},
	["dia"] = {"👍", "👌"},
	["doria"] = {"💩"},
	["lula"] = {"💰", "🏢", "🦑"},
	["mario"] = {"🍄"},
	["neymar"] = {"😍"},
	["noel"] = {"🎅"},
	["pabblo"] = {"👩", "🏳️‍🌈👩"},
	["pabbllo"] = {"👩", "🏳️‍🌈👩"},
	["pabllo"] = {"👩", "🏳️‍🌈👩"},
	["temer"] = {"🧛‍♂️", "🚫"},
	["vittar"] = {"👩", "🏳️‍🌈👩"},
}

local partialMatchAny = {
	["doent"] = {"🤢", "🤕", "🤒"},
	["tap"] = {"✋", "👋", "😍", "😉"},
	["gost"] = {"😍", "😏💦", "😙"},
	["bund"] = {"😮", "😏", "😙"},
	["ador"] = {"😍", "😏💦", "😙"},
	["bum"] = {"😍", "😏💦", "😙"},
	["brasil"] = {"🇧🇷"},
	["cabel"] = {"💇‍♂️", "💇‍♀️"},
	["deus"] = {"👼", "😇", "🙏", "🙏🙏"},
	["doid"] = {"🤪"},
	["fuma"] = {"🚬", "🚭"},
	["kk"] = {"😅", "😂", "🤣"},
	["piment"] = {"🌶"},
	["mort"] = {"☠", "💀", "⚰", "👻"},
	["zap"] = {"📞", "⚡", "📱"},
	["cala"] = {"🤐"},

	-- Especiais
	["chit"] = {"🤢", "💩", "🤧", "🐔", "🐄"},
	["karibo"] = {"🐂"},
	["corno"] = {"🐂"},
	["baiano"] = {"🛌", "😴"},
	["gado"] = {"🐂"},
}

local partialMatchPrefix = {
	["abrac"] = {"🤗"},
	["alema"] = {"🇩🇪"},
	["alun"] = {"👨‍🎓", "👩‍🎓"},
	["anjo"] = {"😇"},
	["armad"] = {"🔫", "🔪", "💣💥"},
	["arte"] = {"🖌"},
	["assust"] = {"😱", "🎃"},
	["ataq"] = {"💣", "🔫"},
	["atenc"] = {"👀"},
	["casad"] = {"💏", "👩‍❤️‍💋‍👨", "👨‍❤️‍💋‍👨"},
	["chave"] = {"🔑", "🗝"},
	["cheir"] = {"👃"},
	["combat"] = {"💣", "🔫", "🎖", "💪"},
	["computa"] = {"💻", "🖥", "🖱⌨", "💾", "👨‍💻", "👩‍💻"},
	["comun"] = {"🇷🇺"},
	["combin"] = {"🤝"},
	["condec"] = {"🎖"},
	["conhec"] = {"🧠", "💭"},
	["content"] = {"😀", "😁", "😃", "😄", "😊", "🙂", "☺"},
	["correr"] = {"🏃"},
	["corrid"] = {"🏃"},
	["danca"] = {"💃", "🕺"},
	["dance"] = {"💃", "🕺"},
	["desculpa"] = {"😅"},
	["docei"] = {"🍦", "🍧", "🍨", "🍩", "🍪", "🎂", "🍰", "🥧", "🍫", "🍬", "🍭", "🍮", "🍯"},
	["doen"] = {"😷", "🤒", "🤕", "🤢", "🤢", "🤧"},
	["enjo"] = {"🤢", "🤢"},
	["espia"] = {"🕵️‍"},
	["espio"] = {"🕵️‍"},
	["europ"] = {"🇪🇺"},
	["exercito"] = {"🎖"},
	["familia"] = {"👨‍👩‍👧‍👦"},
	["feli"] = {"😀", "😁", "😃", "😄", "😊", "🙂", "☺"},
	["fest"] = {"🎆", "🎇", "✨", "🎈", "🎉", "🎊"},
	["flor"] = {"🌹"},
	["foga"] = {"🔥"},
	["fogo"] = {"🔥"},
	["fogu"] = {"🔥"},
	["gat"] = {"😏", "👌", "😽", "😻"},
	["goz"] = {"💦"},
	["gostos"] = {"😈", "😜"},
	["guerr"] = {"💣", "🔫", "🎖"},
	["hora"] = {"⌚", "⏲", "🕛"},
	["hospita"] = {"👨‍⚕️", "⚕", "🚑"},
	["imediat"] = {"⌚", "⏳", "🕛"},
	["invest"] = {"💳", "💵", "💰", "💲"},
	["justic"] = {"⚖", "👨‍⚖️"},
	["louc"] = {"🤪", "😩", "😢", "😰"},
	["louv"] = {"👼", "😇", "🙏", "🙏🙏"},
	["mao"] = {"🖐", "🖐"},
	["maneir"] = {"🔝"},
	["mentir"] = {"🤥", "🤫"},
	["militar"] = {"🎖"},
	["miste"] = {"🕵️‍"},
	["monitor"] = {"🖥"},
	["morre"] = {"☠", "💀", "⚰", "👻"},
	["morri"] = {"☠", "💀", "⚰", "👻"},
	["musica"] = {"🎷", "🎸", "🎹", "🎺", "🎻", "🥁", "🎼", "🎵", "🎶", "🎤"},
	["olh"] = {"👀"},
	["ouv"] = {"👂"},
	["palavr"] = {"✏", "✒", "🖋", "📝", "💬"},
	["palhac"] = {"🤡"},
	["palma"] = {"👏"},
	["paulista"] = {"🏳", "🌈"},
	["patet"] = {"😣"},
	["patriot"] = {"🇧🇷"},
	["pens"] = {"🧠", "💭"},
	["pesa"] = {"🏋"},
	["pipo"] = {"🍿"},
	["pistol"] = {"🔫"},
	["pula"] = {"🏃"},
	["pule"] = {"🏃"},
	["querid"] = {"☺", "🤗"},
	["quiet"] = {"🤐"},
	["raiv"] = {"⚡", "😤", "😤💦", "😖", "🙁", "😩", "😦", "😡", "👺", "💣", "💢", "✋🛑", "☠"},
	["rock"] = {"🤟"},
	["safad"] = {"😉"},
	["saudade"] = {"😢"},
	["segred"] = {"🕵️‍"},
	["sumid"] = {"😍"},
	["surpre"] = {"😮"},
	["telefo"] = {"📱", "📞", "☎"},
	["text"] = {"✏", "✒", "🖋", "📝", "💬"},
	["transa"] = {"👉👌"},
	["transe"] = {"👉👌"},
	["trist"] = {"☹", "🙁", "😖", "😞", "😟", "😢", "😭", "😭", "😭", "😩", "😿"},
	["vergonh"] = {"😳"},
	["vist"] = {"👀"},
	["whisk"] = {"🥃"},

	-- Abreviações/Girias
	["bucet"] = {"😜", "😘", "😟"},
	["fod"] = {"👉👌", "🔞"},
	["fud"] = {"👉👌", "🔞"},
	["haha"] = {"😅", "😂", "🤣"},
	["hehe"] = {"😉", "😎", "😋", "😏", "😜", "😈", "🙊", "😼"},
	["mackenz"] = {"🐴"},
	["merd"] = {"💩"},
	["nude"] = {"🙊", "😼", "😏"},
	["print"] = {"📱"},
	["put"] = {"😤", "😤💦", "😖", "🙁", "😩", "😦", "😡", "👺", "💣", "💢", "✋🛑", "☠"},
	["vampir"] = {"🦇"},

	-- Animais
	["cachorr"] = {"🐶"},
	["morceg"] = {"🦇"},

	-- Comidas
	["hamburger"] = {"🍔"},
	["hamburguer"] = {"🍔"},
	["pao"] = {"🍞", "🥖"},
	["panqueca"] = {"🥞"},
	["milh"] = {"🌽"},

	-- Profissões
	["astronaut"] = {"👨‍🚀", "👩‍🚀"},
	["bombeir"] = {"👩‍🚒", "👨‍🚒"},
	["cienti"] = {"👩‍🔬", "👨‍🔬", "⚗", "🔬", "🔭", "📡"},
	["cozinh"] = {"👨‍🍳", "👩‍🍳"},
	["juiz"] = {"👨‍⚖️", "👩‍⚖️", "⚖"},
	["medic"] = {"👨‍⚕️", "👩‍⚕️", "⚕"},
	["pilot"] = {"👨‍✈️", "👩‍✈️"},
	["policia"] = {"🚨", "🚔", "🚓", "👮‍♂️", "👮‍♀️", "🔫"},
	["professor"] = {"👨‍🏫", "👩‍🏫"},

	-- Signos
	["arian"] = {"♈"},
	["taurin"] = {"♉"},
	["geminian"] = {"♊"},
	["cancerian"] = {"♋"},
	["leonin"] = {"♌"},
	["virginian"] = {"♍"},
	["librian"] = {"♎"},
	["escorpian"] = {"♏"},
	["sagitario"] = {"♐"},
	["capricornian"] = {"♑"},
	["aquarian"] = {"♒"},
	["piscian"] = {"♓"},
}

local moods = {
	happyEmojis = {"😀", "😁", "😂", "😃", "😄", "😅", "😆", "😉", "😊", "😋", "😎", "😛", "😜", "😝", "👌"},
	angryEmojis = {"😤", "😤💦", "😖", "🙁", "😩", "😦", "😡", "👺", "💣", "💢", "✋🛑", "☠"},
	sadEmojis = {"🙁", "😖", "😞", "😟", "😢", "😭", "😭", "😭", "😩", "😿"},
	sassyEmojis = {"😉", "😎", "😋", "😘", "😏", "😜", "😈", "😻", "🙊", "👉👌", "😼"},
	-- sickEmojis = {"😷", "🤒", "🤕", "🤢", "🤢", "🤧"},
}

local function zappify(text, force)
	local list = text:split(" ")
	local result = ""
	local mood

	force = force or 1

	for _, word in next, list do
		local lowerWord = word:lower()
		local added = false

		result = format("%s %s", result, word)

		for match, emojis in next, fullMatch do
			if lowerWord == match then
				added = true

				for i = 1, force do
					result = format("%s %s", result, emojis[random(1, #emojis)])
				end
			end
		end

		for match, emojis in next, partialMatchAny do
			if lowerWord:find(match) then
				added = true

				for i = 1, force do
					result = format("%s %s", result, emojis[random(1, #emojis)])
				end
			end
		end

		for match, emojis in next, partialMatchAny do
			if startsWith(lowerWord, match) then
				added = true

				for i = 1, force do
					result = format("%s %s", result, emojis[random(1, #emojis)])
				end
			end
		end

		if not added then
			local key, emojis = randomPair(moods)

			for i = 1, force do
				result = format("%s %s", result, emojis[random(1, #emojis)])
			end
		end
	end

	return result
end

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local langList = langs[guildLang]
	local args = data.args

	if not (args[2]) then
		local text = parseFormat("${missingArg}: level", langList)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local text = data.content:sub(#args[1] + 2)
	local zaped = zappify(text, random(1, 3))
	-- local embed = replyEmbed(zaped, data.message, "ok")

	bird:post(zaped, nil, data.channel)

	return true
end

return {config = _config, func = _function}

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
	["bravo"] = {"😤", "😤💦", "😖", "🙁", "😩", "😦", "😡", "🤬", "💣", "💢", "✋🛑", "☠"},
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
	["meu"] = {"🙆‍", "😌", "😇"},
	["minha"] = {"🙆‍", "😌", "😇"},
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
	["ador"] = {"😍", "😏💦", "😙"},
	["brasil"] = {"🇧🇷"},
	["cabel"] = {"💇‍♂️", "💇‍♀️"},
	["deus"] = {"👼", "😇", "🙏", "🙏🙏"},
	["doid"] = {"🤪"},
	["fuma"] = {"🚬", "🚭"},
	["kk"] = {"😅", "😂", "🤣"},
	["piment"] = {"🌶"},
	["mort"] = {"☠", "💀", "⚰", "👻"},
	["zap"] = {"📞", "♣", "📱"},

	-- Especiais
	["chit"] = {"🤢", "💩", "🤧", "🐔", "🐄"},
	["karibo"] = {"🐂"},
	["corno"] = {"🐂"},
	["baiano"] = {"🛌", "😴"},
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
	["bunda"] = {"😮", "😏"},
	["calad"] = {"🤐"},
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
	["raiv"] = {"⚡", "😤", "😤💦", "😖", "🙁", "😩", "😦", "😡", "🤬", "💣", "💢", "✋🛑", "☠"},
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
	["put"] = {"😤", "😤💦", "😖", "🙁", "😩", "😦", "😡", "🤬", "💣", "💢", "✋🛑", "☠"},
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
	happyEmojis = {"😀", "😁", "😂", "😃", "😄", "😅", "😆", "😉", "😊", "😋", "😎", "☺", "😛", "😜", "😝", "👌"},
	angryEmojis = {"😤", "😤💦", "😖", "🙁", "😩", "😦", "😡", "🤬", "💣", "💢", "✋🛑", "☠"},
	sadEmojis = {"☹", "🙁", "😖", "😞", "😟", "😢", "😭", "😭", "😭", "😩", "😿"},
	sassyEmojis = {"😉", "😎", "😋", "😘", "😏", "😜", "😈", "😻", "🙊", "👉👌", "😼"},
	sickEmojis = {"😷", "🤒", "🤕", "🤢", "🤢", "🤧"},
}

function zapMeme(text, force)
	local list = text:split(" ")
	local result = ""

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
			local mood, emojis = randomPair(moods)

			for i = 1, force do
				result = format("%s %s", result, emojis[random(1, #emojis)])
			end
		end
	end

	return result
end

return zapMeme

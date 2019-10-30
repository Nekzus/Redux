local textEffects = {
	["self"] = {
		"eu",
		"sou",
		"estou",
		"quero"
	},
	["want"] = {
		"quer[oi]",
		"meu",
		"minha",
	},
	["funny"] = {
		"[k]+",
		"a[h][ah]*",
		"%srs",
	},
	["friendly"] = {
		"lega[lu]",
		"gost[oa]",
		"daor[.%S]*",
		"[in]*teres[.%S]*t[ei]"
	},
	["extend"] = {
		"acha que",
		"diria que",
		"sabe se",
		"confia que",
		"sabe me",
		"diga",
		"[a]*conselh[aeo][r]*[ia]*",
		"infor[a-z%S]*"
	},
	["offensive"] = {
		"ot[.%S]*io",
		"lix",
		"corn[.%S]*",
		"desgr[.%S]*ado",
		"f[ou]d[.%S]*",
		"%sc[.]*",
		"viad*",
		"calcinha",
		"cueca",
		"buceta",
		"pau",
		"f[ou]de[r]*",
		"vadia",
		"crl",
		"puta",
		"bucet[a]*",
		"c[u]+[h]*",
		"cú",
		"vaca",
		"puta",
		"gozei",
		"gozar",
		"meter",
		"meti",
		"piranha",
		"cadela",
		"penetro",
		"penetrar",
		"boquete",
		"boqueteira",
		"chupa",
		"chupar",
		"safada",
		"putinha",
		"safadinha",
		"viado",
		"viada",
		"gay",
		"fdp",
		"capeta",
		"demonio",
		"demônio",
		"fudi",
		"arrombad[ao]*",
		"prostituta",
		"transa",
		"transar",
		"transei",
		"transou",
		"possuir",
		"seu corpo",
		"estrupar",
		"estrupei",
		"arrombada",
		"piriguete",
		"putona",
		"novinha",
		"novinhas",
		"meter",
		"meteria",
		"comer",
		"comeria",
		"cama",
		"bunda",
		"bundinha",
		"bucetinha",
		"ppk",
		"xoxota",
		"passa o",
		"pauzudo",
		"bucetuda",
		"camisinha",
		"cocaína",
		"fude",
		"fudee",
		"viadinho",
		"xereca",
		"pedofilo",
		"penis",
		"pênis",
		"rapariga",
		"gostosa",
		"eu chupo",
		"todinha",
		"sexoo",
		"sexooo",
		"sex",
		"sexo",
		"punheta",
		"siririca",
		"ponheta",
		"transaria",
		"comi ela",
		"[ei]nfia[r]*",
		"cuzin",
		"cuzao",
		"cuzão",
		"bucetinhaa",
		"bicha",
		"Que tranza",
		"tranza",
		"pica",
		"pika",
		"me encontre",
		"passa",
		"endereço",
		"vc mora",
		"você mora",
		"deu muito",
		"pika",
		"bct",
		"gostoso",
		"putiane",
		"arrombado",
		"rolas",
		"gozo",
		"virgindade",
		"estrupa",
		"arrombar",
		"estrupado",
		"estrupada",
		"estruparei",
		"chupar",
		"estrupador",
		"galinha",
		"estrupar",
		"penetra",
		"bucetuda",
		"porra",
		"fode",
		"gozada",
		"nudes",
		"adiciona",
		"cu!",
		"soca",
		"socar",
		"mata",
		"matar",
		"morrer",
		"morre",
		"mora",
		"casa",
		"pelado",
		"pelada",
		"fudeee",
		"meteu",
		"chupo",
		"chupeta"
	},
}

local positive = {
	{
		"Eu espero que sim",
		"Eu tenho certeza que sim",
		"Eu acredito que sim",

		"Espero que sim",
		"Tenho certeza que sim",
		"Acredito que sim",

		"Tudo indica que sim",
		"Pode contar com isso",
		"É certo que sim",
		"Com certeza",
		"Sem dúvidas",
	},
	{
		"Pode confiar que sim",
		"Sem dúvida alguma",
		"Óbvio que sim",
	},
	{
		"Perde teu tempo perguntando não, óbvio que sim",
		"Cê ainda tem dúvida disso? Claro que sim",
		"Bota fé nisso",
	}
}

local negative = {
	{
		"Eu espero que não",
		"Eu tenho certeza que não",
		"Eu acredito que não",

		"Espero que não",
		"Tenho certeza que não",
		"Acredito que não",

		"Tudo indica que não",
		"Não conte com isso",
		"É certo que não",
		"Com certeza não",
		"Tenho minhas dúvidas"
	},
	{
		"Pode confiar que não",
		"Com todas as dúvidas",
		"Óbvio que não",
	},
	{
		"Perca de tempo, óbvio que não",
		"Sério que você perdeu seu tempo perguntando isso? É óbvio que não",
		"Tira seu cavalinho da chuva, óbvio que não",
	}
}

local neutral = {
	{
		"Concentre-se e pergunte novamente",
		"A resposta ainda não é certa",
		"Díficil dizer",
	}
}

local extraPositive = {
	{
		"e espero que dê tudo certo",
		"e tenho certeza que vai ficar tudo certo",
		"e tenho certeza que vai dar tudo certo",
	},
	{
		"tenho certeza que vai dar tudo certo",
		"pode ficar em paz",
		"coloco fé nisso",
	},
	{
		"vamo torcer pra ficar de boa, é nois",
		"tenho certeza que tá tudo certo, tamo junto",
		"pode crer nisso, é nois",
	},
}

local extraNegative = {
	{
		"não acho que vá dar certo",
		"não confio muito nisso pelo menos",
		"eu não daria muita importância para isso",
	},
	{
		"e não ligo",
		"eu não estou nem aí",
		"eu não me importo",
		"eu não quero saber",
		"e aproposito eu tenho raiva de você",
		"e para de falar comigo",
		"e não me atrapalhe mais",
		"agora para de me atrapalhar",
		"você está me atrapalhando",
	},
	{
		"e quero que você se foda, sua bosta de cavalo",
		"e espero que um carro te atropele",
		"e espero que um carro te atropele, seu pedaço de mendigo",
		"e espero que você sente num prego e ele entre no seu cú, fdp",
		"e estou torcendo pra você ter uma diarreia, sua égua manca",
		"e não falo com quem passa o fim de semana vendo porno",
		"e não me importo com você, vai tomar NO SEU CÚ CARALHO, SOME",
		"e aproveita e vai dar o cú",
		"para de me encher a porra do saco",
		"e vai ver se outro bot quer seu cú, eu não quero",
		"vai encher o saco da puta que te pariu",
	},
}

function cubi(text)
	local list = text:split(" ")
	local effects = {}
	local result = ""

	for _, word in next, list do
		for key, matches in next, textEffects do
			for _, match in next, matches do
				if word:find(match) then
					local isKey = effects[key] or {}

					insert(isKey, match)
					effects[key] = isKey
				end
			end
		end
	end

	--[[
		self
		want
		funny
		friendly
		extend
		offensive
	]]

	local function effectLevel(name)
		local effect = effects[name]
		effect = effect and #effect or 0

		return effect
	end

	local function getRandom(list, limit)
		limit = limit or #list
		return list[random(min(limit, #list))]
	end

	-- Montamos o inicio da resposta
	local answerType = random(1, 2) == 1 and true or false
	local rudeLevel = min(3, effectLevel("offensive"))
	local canOffend = rudeLevel > 0

	if answerType then
		-- Positive
		local positiveList = getRandom(positive, canOffend and 3 or 2)
		result = format("%s%s", result, getRandom(positiveList))
	else
		-- Negative
		local negativeList = getRandom(negative, canOffend and rudeLevel or 2)
		result = format("%s%s", result, getRandom(negativeList))

		local extraList = getRandom(extraNegative, canOffend and rudeLevel or 2)
		result = format("%s, %s", result, getRandom(extraList))
	end

	return result
end

return cubi

-- https://www.normaculta.com.br/classes-gramaticais/

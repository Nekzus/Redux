local reflect = {}
reflect.badWords = {
	"ot[.%S]*io",
	"lix[o]*",
	"corn[.%S]*",
	"desgr[.%S]*ado",
	"f[ou]d[.%S]*",
	"c[.]*",
	"calcinha",
	"cueca",
	"pau",
	"f[ou]de[r]*",
	"vadia",
	"crl",
	"put[oa]",
	"bucet[a]*",
	"c[u]+[h]*",
	"c[%z\1-\127\194-\244][\128-\191]*%S",
	"sua vaca",
	"goz[ea][ir]*",
	"meter",
	"meti",
	"piranha",
	"cadela",
	"penetro",
	"penetrar",
	"boquet*",
	"chupa",
	"chupar",
	"safada",
	"putinh[ao]",
	"safadinha",
	"viado",
	"viada",
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
	"putão",
	"putao",
	"novinha",
	"novinhas",
	"meter",
	"meteria",
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
	"sex[o]*",
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
	"chupeta",
	"animal",
	"retardado",
	"retardardo",
	"idiota",
}
reflect.badPhrases = {
	"n[%z\1-\127\194-\244][\128-\191]o gosto de voc[%z\1-\127\194-\244][\128-\191]*%S",
	"eu te odeio",
	"eu odeio voc[%z\1-\127\194-\244][\128-\191]*%S",
	"voc[%z\1-\127\194-\244][\128-\191]*%S [%z\1-\127\194-\244][\128-\191] feio",
	"seu burro",
	"sua anta",
	"sua burra",
	"seu anta",
	"seu imundo",
	"seu inmundo",
	"me comer",
	"me comeria",
}
reflect.question = {
	"acha q[a-z%S]*",
	"diria q[a-z%S]*",
	"sabe [sm]e",
	"confia q[a-z%S]*",
	"diga",
	"[a]*conselh[aeo][r]*[ia]*",
	"infor[%z\1-\127\194-\244][\128-\191]*%S",
	"me ajud[ea]*",
	"quer[oi]*",
	"o qu[%z\1-\127\194-\244][\128-\191]*%S",
	"oqu[%z\1-\127\194-\244][\128-\191]*%S",
	"como",
	"ser[%z\1-\127\194-\244][\128-\191]* q*",
	"me diz",
}
reflect.greeting = {
	"oi",
	"ol[%z\1-\127\194-\244][\128-\191]*",
	"bom dia",
	"tudo bem",
	"e a[%z\1-\127\194-\244][\128-\191]*",
	"eae",
	"fala ae",
	"falae",
	"falai",
	"fala a[%z\1-\127\194-\244][\128-\191]*",
	"hello",
	"helo",
	"hey",
	"aloha",
	"alo",
	"hi",
}

local answers = {}
answers.positive = {
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
		"Claro que sim",
	},
	{
		"E eu ainda preciso te responder? Obviamente sim",
		"Cê ainda tem dúvida disso? Claro que sim",
		"Bota fé nisso",
		"Pode botar fé que sim",
		"Se pá sim",
		"Não precisava me perguntar o óbvio",
	},
}
answers.negative = {
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
		"Duvido muito",
	},
	{
		"Pode confiar que não",
		"Tenho dúvidas sobre isso",
		"Óbvio que não",
		"Claro que não",
	},
	{
		"Para de perder tempo perguntado, a resposta é não",
		"Não tenha dúvidas, a resposta é não",
		"Nem precisa ter esperanças nisso",
		"Para de me perguntar isso, óbviamente é não",
		"Se pá não",
		"Para de me fazer perder tempo, eu já disse que não",
	},
}
answers.neutral = {
	{
		"Concentre-se e pergunte novamente",
		"A resposta ainda não é certa",
		"É díficil dizer",
		"Eu não sei ao certo",
		"Não tenho certeza",
		"Não sei como te responder",
		"Minhas fontes não souberam me dizer",
		"Não posso te responder isso por enquanto",
		"Não tenho tanta certeza para te dizer",
		"Pergunte com mais vontade, por favor",
		"Faça novamente a sua pergunta",
		"Elabore melhor a sua pergunta, por favor",
		"Fica o questionamento",
		"Não faço ideia",
		"Eis a pergunta",
	},
	{
		"Você não sabe fazer uma pergunta direito mesmo em",
		"Aprende a fazer uma pergunta antes de falar comigo, obrigado",
		"Sua pergunta faz tanto sentido quanto o motivo pelo qual você nasceu",
		"Incrível, outra pergunta inútil",
		"Ah claro, mais um pra me fazer perder tempo",
		"Vai arranajar o que fazer, vai",
		"Xoooo, some daqui, não quero falar contigo",
		"E eu que sei? Vai procurar no Google",
		"Em primeiro lugar eu não sou seu psicologo, em segundo lugar, some daqui",
		"Meu.. sério, some daqui vai",
		"Para de me fazer pergunta sem sentido, obrigado",
		"Esse comando é para receber uma resposta direta, então faz uma pergunta direta",
	},
	{
		":middle_finger:",
		"Você tem pelo no dente",
		"Você é muito idiota",
		"Você é o ser mais irritante dessa porra desse servidor",
		"Aí na moral, você só pode ser virgem..",
		"Vou nem falar nada, vai que é contagioso",
		"Você é muito irritante, sabia disso? Some daqui",
		"Você é irrelevante para mim",
		"Some daqui antes que eu te dê ban",
		"Eu não falo com bandeirantes",
		"Eu não gosto de você",
		"Eu não quero falar com você",
		"Eu já disse que não quero falar com você antes e digo novamente",
		"Vai tomar no seu cú",
		"Vai se ferrar, resto de aborto",
		"Caralho, como você é irritante",
		"Gente escrota é assim, não pega ninguém e aí decide vim me encher o saco",
		"Vai se fuder, obrigado",
		"Vai lá se jogar no rio, obrigado",
		"Você é doente",
	}
}
answers.extraPositive = {
	{
		"eu acho",
		"tenho certeza",
		"tenho quase certeza",
	},
	{
		"pode ficar na paz",
		"relaxa",
		"fica de boa",
	},
	{
		"vamos torcer pra dar bom",
		"vai dar bom",
		"pode crer nisso",
	},
}
answers.extraNegative = {
	{
		"eu não sei direito",
		"não confio muito nisso",
		"pelo menos eu não confio muito nisso",
		"e eu não daria muita importância para isso",
	},
	{
		"e não ligo",
		"eu não estou nem aí",
		"eu não me importo",
		"eu não quero saber",
		"e aproposito, eu tenho raiva de você",
		"e para de falar comigo",
		"e não me atrapalhe mais",
		"agora para de me atrapalhar",
		"e aproposito, você está me atrapalhando",
	},
	{
		"e eu quero que você se foda, sua bosta de cavalo",
		"e espero que um carro te atropele",
		"e espero que um carro te atropele, seu pedaço de merda seca",
		"e espero que você sente num prego e ele entre em você bem fundo",
		"e estou torcendo pra você ter uma diarreia, sua égua manca",
		"e não falo com quem passa o fim de semana assistindo porno",
		"e não falo com quem passa o fim de semana jogando hentai simulator online",
		"e não me importo com você, vai tomar VAI SE FERRAR MANO, SOME DAQUI LOGO, NEGÓCIO CHATO VELHO",
		"e aproveita e volta lá pra esquina, seus clientes tão te esperando já faz meia hora",
		"agora para de me encher o saco seu resto de aborto",
		"e vai ver se outro bot quer te comer, eu não quero",
		"e vai encher o saco do seu médico que deu um tapa na sua cara quando você nasceu por confundir sua bunda com seu rosto",
	},
}
answers.greetings = {
	{
		"Olá",
		"Oi",
		"Aloha",
		"Hey",
		"Hello",
		"Saudações",
	},
	{
		"E aí",
		"Fala aí",
		"Eae",
		"E aí meu",
	},
	{
		"Fala, porra",
		"E aí, caralho",
		"Fala, seu resto de merda",
		"E aí, caralho",
	}
}

local function matchList(word, list)
	for _, value in next, list do
		if word:find(value) then
			return word
		end
	end

	return false
end

-- reflect: rude, question
-- answers: positive, negative, neutral, extraPositive, extraNegative

randomSeed(os.time())

function cubi(text, mode)
	text = assert(text and type(text) == "string" and text:lower(), "Text must be a string")

	-- Registra uma sequência de regras e considerações
	local rudeLevel = 0
	local question = matchList(text, reflect.question)
	local greeting = matchList(text, reflect.greeting)
	local list = text:split(" ")
	local chance = random(1, 3)
	local result = ""

	-- Verifica se há palavras ofensivas na frase
	for _, word in next, list do
		if matchList(word, reflect.badWords) then
			rudeLevel = rudeLevel + 1
		end
	end

	-- Verifica se há frases ofensivas
	for _, phrase in next, reflect.badPhrases do
		if text:find(phrase) then
			rudeLevel = rudeLevel + 1
		end
	end

	-- Checa se o usuário usou alguma forma de cumprimento
	if greeting then
		local using = answers.greetings
		local level = random(min(#using, rudeLevel + 1))
		local list = using[level]

		result = format("%s. ", list[random(#list)])
	end

	-- Caso as chances forem para dar uma resposta neutra
	if chance == 1 or mode == "neutral" then
		local using = answers.neutral
		local level = random(min(#using, rudeLevel + 1))
		local list = using[level]

		result = format("%s%s.", result, list[random(#list)])

		return result
	end

	-- Resposta positiva
	if chance == 2 then
		local using = answers.positive
		local level = random(min(#using, rudeLevel + 1))
		local list = using[level]

		result = format("%s%s", result, list[random(#list)])

		if random(1, 10) >= 6 or rudeLevel >= 2 then
			local using = answers.extraPositive
			local level = random(min(#using, rudeLevel + 1))
			local list = using[level]

			result = format("%s, %s", result, list[random(#list)])
		end

		result = format("%s.", result)

		return result
	end

	-- Resposta negativa
	if chance == 3 then -- Negative
		local using = answers.negative
		local level = random(min(#using, rudeLevel + 1))
		local list = using[level]
		local result = ""

		result = format("%s%s", result, list[random(#list)])

		if random(1, 10) >= 6 or rudeLevel >= 2 then
			local using = answers.extraNegative
			local level = random(min(#using, rudeLevel + 1))
			local list = using[level]

			result = format("%s, %s.", result, list[random(#list)])
		end

		result = format("%s.", result)

		return result
	end
end

return cubi

-- https://www.normaculta.com.br/classes-gramaticais/

-- .f client:setAvatar("./images/nekito4.png")
-- https://atom.io/packages/language-lua
-- test

config = {}
config.meta = {
	reactionTimeout = 30,
	invite = "https://discordapp.com/api/oauth2/authorize?client_id=309586161876205579&permissions=8&scope=bot",
	token = "MzA5NTg2MTYxODc2MjA1NTc5.XO1xyA.whj0EwjDy_zGyxFP6QbGPqBFmVQ",
	baseGuild = "464558668894175232",
	build = "Redux",
}
config.time = {
	second = 1,
	minute = 60,
	hour = 3600,
	day = 86400,
	week = 604800,
	month = 2592000,
	year = 31536000,
}
config.saving = {
	enabled = true,
	delay = 60,
}
config.clean = {
	enabled = true,
	delay = 2,
}
config.default = {
	prefix = ".",
	lang = "en-us",
	deleteCommand = false,
}
config.economyDefault = {
	symbol = ":dollar:",
	users = {},
	store = {},
	actions = {
		work = {
			cooldown = 30 * config.time.second,
			income = {min = 50, max = 500},
		},
		crime = {
			cooldown = 4 * config.time.minute,
		}
	},
}
config.images = {
	ok = "https://cdn.discordapp.com/attachments/605826739842711562/605826801385603083/Ok.png",
	warn = "https://cdn.discordapp.com/attachments/605826739842711562/605826803721961492/Attention.png",
	no = "https://cdn.discordapp.com/attachments/605826739842711562/605826806406184966/Prohibited.png",
	error = "https://cdn.discordapp.com/attachments/605826739842711562/605826805621981201/Cancel.png",
	info = "https://cdn.discordapp.com/attachments/605826739842711562/605827616368230411/Information.png",
	google = "https://cdn.discordapp.com/attachments/605826739842711562/611950666037854231/google.png",
	googleBlue = "https://cdn.discordapp.com/attachments/605826739842711562/611953227814141974/Google_blue.png",
}
config.emojis = {
	loading = "RotatingGears",
	topic = "Rhombus",
	arwLeft = "ArrowLeft",
	arwRight = "ArrowRight"
}
config.colors = {
	green = "r76g175b80",
	yellow = "r255g202b40",
	red = "r244g67b54",
	red2 = "r216g67b21",
	blue = "r33g150b243",
	grey = "r249g239b239",
	black = "r0g0b0",
}
config.titles = {
	dev = {level = 5, title = "${dev}"},
	owner = {level = 4, title = "${svOwner}"},
	org = {level = 3, title = "${org}"},
	admin = {level = 2, title = "${admin}"},
	mod = {level = 1, title = "${mod}"},
	member = {level = 0, title = "${member}"},
	muted = {level = -1, title = "${muted}"},
}
config.terms = {
	done = {
		"done", "d",
		"finish", "finished", "f",
	},
	cancel = {
		"cancel", "c",
		"stop", "s",
		"end", "e",
	},
	name = {

	}
}
config.patterns = {
	colorRGB = {
		base = "r%d+g%d+b%d+",
		capture = "r(%d+)g(%d+)b(%d+)",
	},
	mention = {
		base = "<@!?%d+>",
		capture = "<@!?(%d+)>",
	},
	role = {
		base = "<@&%d+>",
		capture = "<@&(%d+)>",
	},
	emoji = {
		base = "<a?:[%w_]+:%d+>",
		capture = "<a?:[%w_]+:(%d+)>",
	},
	channel = {
		base = "<#%d+>",
		capture = "<#(%d+)>",
	},
	mute = {
		base = "%d+%a",
		capture = "(%d+)(%a)",
	},
	quotes = {
		base = "(%b\"\")",
	},
	numberType1 = {
		base = "[+-]?%d+%p?%d-",
		capture = "[+-]?(%d+%p?%d-)",
	},
	keyValue = {
		base = "%s*.-%s*=%s*.-%s*$",
		capture = "%s*(.-)%s*=%s*(.-)%s*$",
	},
	-- "^%s*(.-)%s*$"
}

--[[
str = " \t \r \n String with spaces  \t  \r  \n  "

print( string.format( "Leading whitespace removed: %s", str:match( "^%s*(.+)" ) ) )
print( string.format( "Trailing whitespace removed: %s", str:match( "(.-)%s*$" ) ) )
print( string.format( "Leading and trailing whitespace removed: %s", str:match( "^%s*(.-)%s*$" ) ) )
]]

config.numAffixes = {
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


--[[
- Crime (patronos escolhem) seleciona um crime aleatório em dificuldade [facil/média/difícil]

- Você vê a recompensa e a dificuldade da missão, tendo assim, a opção de decidir se quer ou não fazê-la

- Durante a escolha, pessoas podem se juntar a você (caso você liberar) para cometer um crime
	por consequência, a recompensa será repartida entre todos (caso houver sucesso)
	caso falhar, apenas um usuário aleatório será pego e punido

- Itens da loja (ou do mercado negro) poderão diminuir a dificuldade

https://www.ranker.com/list/crimes-youd-commit-if-you-could-get-away-with-it/dani-porter
]]
--[[
- Durante as missões de crime, o usuário ou um usuário aleatório será selecionado para executar um dos níveis
	do crime, durante esse processo, um usuário terá três opções dentro do bot que, por via de reactions
	escolherá a ação desejada.

- Ação de roubar uma pessoa:
	- nível 1 do roubo: modo de assalto: Em Silencio, Agressivo, Blitzkrieg
		dentre as três opções, uma delas poderá dar errado, resultando na prisão do membro
		caso der certo, todos os outros membros procedem juntos

	- nível 2 do roubo:
]]

-- quadro de missõs aleatórias
-- shinato - trocas no bot
-- player - missões secundarias (que podem conter drops)
-- braresa - facções com sistema similar a werewolf online (adicionar top 3 pra ter chat)
-- maquina de dinheiro

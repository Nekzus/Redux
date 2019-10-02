-- .f client:setAvatar("./images/nekito4.png")
-- https://atom.io/packages/language-lua
-- test

second = 1
minute = second * 60
hour = minute * 60
day = hour * 24
week = day * 7
month = day * 30
year = day * 365

config = {}
config.meta = {
	reactionTimeout = 30,
	invite = "https://discordapp.com/api/oauth2/authorize?client_id=309586161876205579&permissions=8&scope=bot",
	token = "MzA5NTg2MTYxODc2MjA1NTc5.XO1xyA.whj0EwjDy_zGyxFP6QbGPqBFmVQ",
	baseGuild = "464558668894175232",
	build = "Redux",
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
			cd = 30 * second,
			income = {min = 50, max = 500},
		},
		crime = {
			cd = 4 * minute,
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

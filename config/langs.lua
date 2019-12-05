--[[
	Palavras			(Coisas pequenas, uma única palavra)
	Permissões			(Relação com a lista de permissões de usuário no Discord)
	Chaves				(Palavras chave como: [número] por exemplo)
	Resultados			(Respostas que serão dadas como: Sendo editado por: %usuario%)
	Erros do Discord	(Erros específicos do Discord (Gateway, 404 e etc))
	Comando work		(Respostas do comando work)

	Use Ctrl+F nas palavras chaves acima para navegação fácil
--]]


langs = {
	-- Palavras
	["unicode"] = {
		["en-us"] = "Unicode",
		["pt-br"] = "Unicode",
	},

	["commands"] = {
		["en-us"] = "Commands",
		["pt-br"] = "Comandos",
	},

	["page"] = {
		["en-us"] = "Page",
		["pt-br"] = "Página",
	},

	["name"] = {
		["en-us"] = "Name",
		["pt-br"] = "Nome",
	},

	["type"] = {
		["en-us"] = "Type",
		["pt-br"] = "Tipo",
	},

	["nativeName"] = {
		["en-us"] = "Native Name",
		["pt-br"] = "Nome Nativo",
	},

	["symbol"] = {
		["en-us"] = "Symbol",
		["pt-br"] = "Símbolo",
	},

	["code"] = {
		["en-us"] = "Code",
		["pt-br"] = "Código",
	},

	["discrim"] = {
		["en-us"] = "Discriminator",
		["pt-br"] = "Discriminador",
	},

	["id"] = {
		["en-us"] = "ID",
		["pt-br"] = "ID",
	},

	["status"] = {
		["en-us"] = "Status",
		["pt-br"] = "Status",
	},

	["joinedDisc"] = {
		["en-us"] = "Joined Discord",
		["pt-br"] = "Entrou no Discord",
	},

	["joinedServer"] = {
		["en-us"] = "Joined Server",
		["pt-br"] = "Entrou no Servidor",
	},

	["created"] = {
		["en-us"] = "Created",
		["pt-br"] = "Criado",
	},

	["createdIn"] = {
		["en-us"] = "Created in",
		["pt-br"] = "Criado em",
	},

	["members"] = {
		["en-us"] = "Members",
		["pt-br"] = "Membros",
	},

	["categories"] = {
		["en-us"] = "Categories",
		["pt-br"] = "Categorias",
	},

	["textChannels"] = {
		["en-us"] = "Text Channels",
		["pt-br"] = "Canais de Texto",
	},

	["voiceChannels"] = {
		["en-us"] = "Voice Channels",
		["pt-br"] = "Canais de Voz",
	},

	["roles"] = {
		["en-us"] = "Roles",
		["pt-br"] = "Cargos",
	},

	["emojis"] = {
		["en-us"] = "Emojis",
		["pt-br"] = "Emojis",
	},

	["moderation"] = {
		["en-us"] = "Moderation",
		["pt-br"] = "Moderação",
	},

	["fun"] = {
		["en-us"] = "Fun",
		["pt-br"] = "Diversão",
	},

	["base"] = {
		["en-us"] = "Base",
		["pt-br"] = "Base",
	},

	["owner"] = {
		["en-us"] = "Owner",
		["pt-br"] = "Dono",
	},

	["pong"] = {
		["en-us"] = "Pong",
		["pt-br"] = "Pong",
	},

	["main"] = {
		["en-us"] = "Primary",
		["pt-br"] = "Principal",
	},

	["initial"] = {
		["en-us"] = "Initial",
		["pt-br"] = "Inicial",
	},

	["patron"] = {
		["en-us"] = "Patron",
		["pt-br"] = "Patrono",
	},

	["patrons"] = {
		["en-us"] = "Patrons",
		["pt-br"] = "Patronos",
	},

	["level"] = {
		["en-us"] = "Level",
		["pt-br"] = "Nível",
	},

	["economy"] = {
		["en-us"] = "Economy",
		["pt-br"] = "Economia",
	},

	["role"] = {
		["en-us"] = "Role",
		["pt-br"] = "Cargo",
	},

	["cash"] = {
		["en-us"] = "Cash",
		["pt-br"] = "Dinheiro",
	},

	["bank"] = {
		["en-us"] = "Bank",
		["pt-br"] = "Banco",
	},

	["networth"] = {
		["en-us"] = "Networth",
		["pt-br"] = "Patrimônio",
	},

	["alias"] = {
		["en-us"] = "Alias",
		["pt-br"] = "Alias",
	},

	["aliases"] = {
		["en-us"] = "Aliases",
		["pt-br"] = "Aliases",
	},

	["none"] = {
		["en-us"] = "None",
		["pt-br"] = "Nenhum",
	},

	["command"] = {
		["en-us"] = "Command",
		["pt-br"] = "Comando",
	},

	["usage"] = {
		["en-us"] = "Usage",
		["pt-br"] = "Modo de uso",
	},

	["params"] = {
		["en-us"] = "Parameters",
		["pt-br"] = "Parâmetros",
	},

	["store"] = {
		["en-us"] = "Store",
		["pt-br"] = "Loja",
	},

	["soon"] = {
		["en-us"] = "Soon",
		["pt-br"] = "Em breve",
	},

	["no"] = {
		["en-us"] = "No",
		["pt-br"] = "Não",
	},

	["nope"] = {
		["en-us"] = "Nope",
		["pt-br"] = "Nem",
	},

	["yes"] = {
		["en-us"] = "Yes",
		["pt-br"] = "Sim",
	},

	["yep"] = {
		["en-us"] = "Yep",
		["pt-br"] = "Aham",
	},

	["maybe"] = {
		["en-us"] = "Maybe",
		["pt-br"] = "Talvez",
	},

	["question"] = {
		["en-us"] = "Question",
		["pt-br"] = "Pergunta",
	},

	["answer"] = {
		["en-us"] = "Answer",
		["pt-br"] = "Resposta",
	},

	["primaryGroup"] = {
		["en-us"] = "Primary Group",
		["pt-br"] = "Grupo Primário",
	},

	["googleSearch"] = {
		["en-us"] = "Google Search",
		["pt-br"] = "Pesquisa do Google",
	},

	["translation"] = {
		["en-us"] = "Translation",
		["pt-br"] = "Tradução",
	},

	["sourceLanguage"] = {
		["en-us"] = "Source Language",
		["pt-br"] = "Linguagem de Origem",
	},

	["translationCodes"] = {
		["en-us"] = "Translation Codes",
		["pt-br"] = "Códigos de Tradução",
	},

	["guilds"] = {
		["en-us"] = "Guilds",
		["pt-br"] = "Guildas",
	},

	["wikipedia"] = {
		["en-us"] = "Wikipedia",
		["pt-br"] = "Wikipédia",
	},

	["rating"] = {
		["en-us"] = "Rating",
		["pt-br"] = "Classificação",
	},

	["example"] = {
		["en-us"] = "Example",
		["pt-br"] = "Exemplo",
	},

	["inventory"] = {
		["en-us"] = "Inventory",
		["pt-br"] = "Inventário",
	},

	["social"] = {
		["en-us"] = "Social",
		["pt-br"] = "Social",
	},

	["friends"] = {
		["en-us"] = "Friends",
		["pt-br"] = "Amigos",
	},

	["following"] = {
		["en-us"] = "Following",
		["pt-br"] = "Seguindo",
	},

	["followers"] = {
		["en-us"] = "Followers",
		["pt-br"] = "Seguidores",
	},

	["investments"] = {
		["en-us"] = "Investments",
		["pt-br"] = "Investimentos",
	},

	["recentAveragePrice"] = {
		["en-us"] = "Recent Average Price",
		["pt-br"] = "Preço Médio Recente",
	},

	["recentAveragePriceTag"] = {
		["en-us"] = "RAP",
		["pt-br"] = "PMR",
	},

	["limiteds"] = {
		["en-us"] = "Limiteds",
		["pt-br"] = "Limitados",
	},

	["userVisits"] = {
		["en-us"] = "User Visits",
		["pt-br"] = "Visitas de Usuários",
	},

	["itemName"] = {
		["en-us"] = "Item Name",
		["pt-br"] = "Nome do Item",
	},

	["itemDesc"] = {
		["en-us"] = "Item Description",
		["pt-br"] = "Descrição do Item",
	},

	["itemPrice"] = {
		["en-us"] = "Item Price",
		["pt-br"] = "Preço do Item",
	},

	["stockQuant"] = {
		["en-us"] = "Stock Quantity",
		["pt-br"] = "Quantidade de Estoque",
	},

	["roleAward"] = {
		["en-us"] = "Role to Award",
		["pt-br"] = "Cargo para Premiar",
	},

	["day"] = {
		["en-us"] = "Day",
		["pt-br"] = "Dia",
	},

	["days"] = {
		["en-us"] = "Days",
		["pt-br"] = "Dias",
	},

	["hour"] = {
		["en-us"] = "Hour",
		["pt-br"] = "Hora",
	},

	["hours"] = {
		["en-us"] = "Hours",
		["pt-br"] = "Horas",
	},

	["minute"] = {
		["en-us"] = "Minute",
		["pt-br"] = "Minuto",
	},

	["minutes"] = {
		["en-us"] = "Minutes",
		["pt-br"] = "Minutos",
	},

	["second"] = {
		["en-us"] = "Second",
		["pt-br"] = "Segundo",
	},

	["seconds"] = {
		["en-us"] = "Seconds",
		["pt-br"] = "Segundos",
	},

	["dev"] = {
		["en-us"] = "Developer",
		["pt-br"] = "Desenvolvedor",
	},

	["svOwner"] = {
		["en-us"] = "Owner",
		["pt-br"] = "Dono",
	},

	["org"] = {
		["en-us"] = "Organizer",
		["pt-br"] = "Organizador",
	},

	["admin"] = {
		["en-us"] = "Administrator",
		["pt-br"] = "Administrador",
	},

	["mod"] = {
		["en-us"] = "Moderator",
		["pt-br"] = "Moderador",
	},

	["user"] = {
		["en-us"] = "User",
		["pt-br"] = "Usuário",
	},

	["member"] = {
		["en-us"] = "Member",
		["pt-br"] = "Membro",
	},

	["muted"] = {
		["en-us"] = "Muted",
		["pt-br"] = "Mutado",
	},

	-- Permissões
	["addReactions"] = {
		["en-us"] = "Add Reactions",
		["pt-br"] = "Adicionar Reações",
	},

	["administrator"] = {
		["en-us"] = "Administrator",
		["pt-br"] = "Administrador",
	},

	["attachFiles"] = {
		["en-us"] = "Attach Files",
		["pt-br"] = "Anexar Arquivos",
	},

	["banMembers"] = {
		["en-us"] = "Ban Members",
		["pt-br"] = "Banir Membros",
	},

	["changeNickname"] = {
		["en-us"] = "Change Nickname",
		["pt-br"] = "Mudar o Apelido",
	},

	["connect"] = {
		["en-us"] = "Connect to Voice-Chat",
		["pt-br"] = "Conectar ao Chat-de-Voz",
	},

	["createInstantInvite"] = {
		["en-us"] = "Create Instant Invite",
		["pt-br"] = "Criar Convite Instantâneo",
	},

	["deafenMembers"] = {
		["en-us"] = "Deafen Members",
		["pt-br"] = "Ensurdecer Membros",
	},

	["embedLinks"] = {
		["en-us"] = "Embed Links",
		["pt-br"] = "Embutir Links",
	},

	["kickMembers"] = {
		["en-us"] = "Kick Members",
		["pt-br"] = "Expulsar Membros",
	},

	["manageChannels"] = {
		["en-us"] = "Manage Channels",
		["pt-br"] = "Gerenciar Canais",
	},

	["manageEmojis"] = {
		["en-us"] = "Manage Emojis",
		["pt-br"] = "Gerenciar Emojis",
	},

	["manageGuild"] = {
		["en-us"] = "Manage Guild",
		["pt-br"] = "Gerenciar a Guilda",
	},

	["manageMessages"] = {
		["en-us"] = "Manage Messages",
		["pt-br"] = "Gerenciar Mensagens",
	},

	["manageNicknames"] = {
		["en-us"] = "Manage Nicknames",
		["pt-br"] = "Gerenciar Apelidos",
	},

	["manageRoles"] = {
		["en-us"] = "Manage Roles",
		["pt-br"] = "Gerenciar Cargos",
	},

	["manageWebhooks"] = {
		["en-us"] = "Manage Webhooks",
		["pt-br"] = "Gerenciar Webhooks",
	},

	["mentionEveryone"] = {
		["en-us"] = "Mention Everyone",
		["pt-br"] = "Mencionar Todos",
	},

	["moveMembers"] = {
		["en-us"] = "Move Members",
		["pt-br"] = "Mover Membros",
	},

	["muteMembers"] = {
		["en-us"] = "Mute Members",
		["pt-br"] = "Mutar Membros",
	},

	["prioritySpeaker"] = {
		["en-us"] = "Priority Speaker",
		["pt-br"] = "Orador Prioritário",
	},

	["readMessageHistory"] = {
		["en-us"] = "Read Message History",
		["pt-br"] = "Ler Histórico de Mensagens",
	},

	["readMessages"] = {
		["en-us"] = "Read Messages",
		["pt-br"] = "Ler Mensagens",
	},

	["sendMessages"] = {
		["en-us"] = "Send Messages",
		["pt-br"] = "Enviar Mensagens",
	},

	["sendTextToSpeech"] = {
		["en-us"] = "Send Text-to-Speech",
		["pt-br"] = "Enviar Texto-para-Voz",
	},

	["speak"] = {
		["en-us"] = "Speak in Voice-Chat",
		["pt-br"] = "Falar no Canal-de-Voz",
	},

	["useExternalEmojis"] = {
		["en-us"] = "Use External Emojis",
		["pt-br"] = "Usar Emojis Externos",
	},

	["useVoiceActivity"] = {
		["en-us"] = "Use Voice-Activity",
		["pt-br"] = "Usar Atividade-de-Voz",
	},

	["viewAuditLog"] = {
		["en-us"] = "View Audit Log",
		["pt-br"] = "Ver Logs de Auditoria",
	},

	["mutedUsers"] = {
		["en-us"] = "Muted Users",
		["pt-br"] = "Usuários Mutados",
	},

	["duration"] = {
		["en-us"] = "Duration",
		["pt-br"] = "Duração",
	},

	["reason"] = {
		["en-us"] = "Reason",
		["pt-br"] = "Motivo",
	},

	["timeLeft"] = {
		["en-us"] = "Time Left",
		["pt-br"] = "Tempo Restante",
	},

	["ipInfo"] = {
		["en-us"] = "IP Information",
		["pt-br"] = "Informações de IP",
	},

	["security"] = {
		["en-us"] = "Security",
		["pt-br"] = "Segurança",
	},

	["geo"] = {
		["en-us"] = "Geolocation",
		["pt-br"] = "Geolocalização",
	},

	["latitude"] = {
		["en-us"] = "Latitude",
		["pt-br"] = "Latitude",
	},

	["longitude"] = {
		["en-us"] = "Longitude",
		["pt-br"] = "Longitude",
	},

	["zipCode"] = {
		["en-us"] = "ZIP Code",
		["pt-br"] = "Código ZIP",
	},

	["timezone"] = {
		["en-us"] = "Timezone",
		["pt-br"] = "Fuso Horário",
	},

	["asn"] = {
		["en-us"] = "ASN",
		["pt-br"] = "ASN",
	},

	["gmtOffset"] = {
		["en-us"] = "GMT Offset",
		["pt-br"] = "Deslocamento GMT",
	},

	["dateTime"] = {
		["en-us"] = "Date and Time",
		["pt-br"] = "Data e Horário",
	},

	["microsoftName"] = {
		["en-us"] = "Microsoft Name",
		["pt-br"] = "Nome pela Microsoft",
	},

	["iana"] = {
		["en-us"] = "IANA",
		["pt-br"] = "IANA",
	},

	["executionTime"] = {
		["en-us"] = "Execution Time",
		["pt-br"] = "Tempo de Execução",
	},

	["error"] = {
		["en-us"] = "Error",
		["pt-br"] = "Erro",
	},

	["hostName"] = {
		["en-us"] = "Host Name",
		["pt-br"] = "Nome do Host",
	},

	["ipType"] = {
		["en-us"] = "IP Type",
		["pt-br"] = "Tipo de IP",
	},

	["requesterIp"] = {
		["en-us"] = "Requester IP",
		["pt-br"] = "IP Solicitante",
	},

	["ip"] = {
		["en-us"] = "IP",
		["pt-br"] = "IP",
	},

	["domain"] = {
		["en-us"] = "Domain",
		["pt-br"] = "Domínio",
	},

	["organization"] = {
		["en-us"] = "Organization",
		["pt-br"] = "Organização",
	},

	["isMetric"] = {
		["en-us"] = "Is Metric",
		["pt-br"] = "É Métrico",
	},

	["isInEurope"] = {
		["en-us"] = "Is In Europe",
		["pt-br"] = "Está na Europa",
	},

	["isDaylightSaving"] = {
		["en-us"] = "Is Daylight Saving",
		["pt-br"] = "Está em Horário de Verão",
	},

	["isCrawler"] = {
		["en-us"] = "Is Crawler",
		["pt-br"] = "É Crawler",
	},

	["isProxy"] = {
		["en-us"] = "Is Proxy",
		["pt-br"] = "É Proxy",
	},

	["isTor"] = {
		["en-us"] = "Is Tor",
		["pt-br"] = "É Tor",
	},

	["countryGeoId"] = {
		["en-us"] = "Country Geo ID",
		["pt-br"] = "ID Geo do País",
	},

	["regionGeoId"] = {
		["en-us"] = "Region Geo ID",
		["pt-br"] = "ID Geo da Região",
	},

	["continentGeoId"] = {
		["en-us"] = "Continent Geo ID",
		["pt-br"] = "ID Geo do Continente",
	},

	["city"] = {
		["en-us"] = "City",
		["pt-br"] = "Cidade",
	},

	["country"] = {
		["en-us"] = "Country",
		["pt-br"] = "País",
	},

	["capital"] = {
		["en-us"] = "Capital",
		["pt-br"] = "Capital",
	},

	["regionCode"] = {
		["en-us"] = "Region Code",
		["pt-br"] = "Código da Região",
	},

	["regionName"] = {
		["en-us"] = "Region Name",
		["pt-br"] = "Nome da Região",
	},

	["continentCode"] = {
		["en-us"] = "Continent Code",
		["pt-br"] = "Código do Continente",
	},

	["continentName"] = {
		["en-us"] = "Continent Name",
		["pt-br"] = "Nome do Continente",
	},

	["countryName"] = {
		["en-us"] = "Country Name",
		["pt-br"] = "Nome do País",
	},

	["countryISOCode"] = {
		["en-us"] = "Country ISO Code",
		["pt-br"] = "Código ISO do País",
	},

	["countryTwoLetterISOCode"] = {
		["en-us"] = "Country Two-Letter ISO Code",
		["pt-br"] = "Codígo de Duas-Letras ISO do País",
	},

	-- Chaves
	["pageKey"] = {
		["en-us"] = "[page]",
		["pt-br"] = "[pagina]",
	},

	["userKey"] = {
		["en-us"] = "[user]",
		["pt-br"] = "[usuário]",
	},

	["emoteKey"] = {
		["en-us"] = "[emote]",
		["pt-br"] = "[emote]",
	},

	["messageKey"] = {
		["en-us"] = "[message]",
		["pt-br"] = "[mensagem]",
	},

	["equationKey"] = {
		["en-us"] = "[equation]",
		["pt-br"] = "[equação]",
	},

	["keyKey"] = {
		["en-us"] = "[key]",
		["pt-br"] = "[chave]",
	},

	["valueKey"] = {
		["en-us"] = "[value]",
		["pt-br"] = "[valor]",
	},

	["codeKey"] = {
		["en-us"] = "[code]",
		["pt-br"] = "[código]",
	},

	["nameKey"] = {
		["en-us"] = "[name]",
		["pt-br"] = "[nome]",
	},

	["numKey"] = {
		["en-us"] = "[number]",
		["pt-br"] = "[número]",
	},

	["languageKey"] = {
		["en-us"] = "[language]",
		["pt-br"] = "[língua]",
	},

	["reasonKey"] = {
		["en-us"] = "[reason]",
		["pt-br"] = "[motivo]",
	},

	-- Resultados
	["inputResult"] = {
		["en-us"] = "Input: ",
		["pt-br"] = "Entrada: ",
	},

	["outputResult"] = {
		["en-us"] = "Output: ",
		["pt-br"] = "Saída: ",
	},

	["editModeResult"] = {
		["en-us"] = "Being edited by **%s**",
		["pt-br"] = "Sendo editado por **%s**",
	},

	["embedFinishTip"] = {
		["en-us"] = "Say `%s` once finished to fully create the embed",
		["pt-br"] = "Diga `%s` quando acabar para criar o embed completamente",
	},

	["embedFinishTip2"] = {
		["en-us"] = "You can say `%s` to end your embed from here",
		["pt-br"] = "Você pode dizer `%s` para finalizar seu embed daqui",
	},

	["itemFinishTip"] = {
		["en-us"] = "Say `%s` to finish your item, or `%s` to cancel",
		["pt-br"] = "Diga `%s` quando acabar para criar seu item, ou `%s` para cancelar",
	},

	["itemFinishTip2"] = {
		["en-us"] = "You can say `%s` to end your item from here",
		["pt-br"] = "Você pode dizer `%s` para finalizar seu item daqui",
	},

	["roleAndAbove"] = {
		["en-us"] = "%s and above",
		["pt-br"] = "%s e acima",
	},

	["nextInstruction"] = {
		["en-us"] = "Choose the **%s** (%s %s)",
		["pt-br"] = "Choose the **%s** (%s %s)",
	},

	["storeBuyTip"] = {
		["en-us"] = "Use `%s` to purchase an item from the store",
		["pt-br"] = "Use `%s` para comprar um item da loja",
	},

	["storeInfoTip"] = {
		["en-us"] = "Use `%s` to see more details about an item from the store",
		["pt-br"] = "Use `%s` para ver mais detalhes de um item da loja",
	},

	["clickHereScreenshare"] = {
		["en-us"] = "Click here to enable screenshare",
		["pt-br"] = "Clique aqui para ativar o compartilhamento",
	},

	["guildPrefix"] = {
		["en-us"] = "My prefix in this guild is: `%s`",
		["pt-br"] = "Meu prefix nesta guild é: `%s`",
	},

	["scriptErrorFor"] = {
		["en-us"] = "Script error for: %s",
		["pt-br"] = "Erro de script para: %s",
	},

	["roleDoesNotExist"] = {
		["en-us"] = "This role does note exist",
		["pt-br"] = "Este cargo não existe",
	},

	["roleName"] = {
		["en-us"] = "Name",
		["pt-br"] = "Nome",
	},

	["roleUsers"] = {
		["en-us"] = "Users",
		["pt-br"] = "Usuários",
	},

	["roleMentionable"] = {
		["en-us"] = "Mentionable",
		["pt-br"] = "Mencionável",
	},

	["roleCreatedAt"] = {
		["en-us"] = "Created at",
		["pt-br"] = "Criado em",
	},

	["roleColor"] = {
		["en-us"] = "Color (RGB)",
		["pt-br"] = "Cor (RGB)",
	},

	["roleHoisted"] = {
		["en-us"] = "Hoisted",
		["pt-br"] = "Visível",
	},

	["feedbackSubmitted"] = {
		["en-us"] = "Feedback submitted",
		["pt-br"] = "Feedback submetido",
	},

	["avatarFor"] = {
		["en-us"] = "Avatar for %s",
		["pt-br"] = "Avatar de %s",
	},

	["clickOpenInBrowser"] = {
		["en-us"] = "Click [here](%s) to open in browser",
		["pt-br"] = "Clique [aqui](%s) para abrir no navegador",
	},

	["missingArg"] = {
		["en-us"] = "Missing argument",
		["pt-br"] = "Argumento ausente",
	},

	["noReason"] = {
		["en-us"] = "No reason provided.",
		["pt-br"] = "Nenhum motivo específicado.",
	},

	["userNotFound"] = {
		["en-us"] = "User not found",
		["pt-br"] = "Usuário não encontrado",
	},

	["executeFromGuild"] = {
		["en-us"] = "Can only execute this command from a guild",
		["pt-br"] = "Só pode executar esse comando de uma guilda",
	},

	["mentionedHigher"] = {
		["en-us"] = "Mentioned user has a role higher than you or the bot",
		["pt-br"] = "O usuário mencionado tem um cargo maior que você ou o bot",
	},

	["specifyUser"] = {
		["en-us"] = "Please, specify an user",
		["pt-br"] = "Por favor, especifique um usuário",
	},

	["noExecuteOwner"] = {
		["en-us"] = "Cannot execute this command on the guild owner",
		["pt-br"] = "Não é possível executar este comando no dono da guilda",
	},

	["noExecuteBot"] = {
		["en-us"] = "Cannot execute this command on the bot",
		["pt-br"] = "Não é possível executar este comando no bot",
	},

	["noExecuteSelf"] = {
		["en-us"] = "Cannot execute this command on yourself",
		["pt-br"] = "Não é possível executar este comando em você mesmo",
	},

	["roleNotFound"] = {
		["en-us"] = "**%s** role not found",
		["pt-br"] = "Cargo **%s** não encontrado",
	},

	["luaNotSupported"] = {
		["en-us"] = "Running this type of command is not supported",
		["pt-br"] = "A execução deste tipo de comando não é suportada",
	},

	["linksNotSupported"] = {
		["en-us"] = "Links are not supported for this command",
		["pt-br"] = "Links não são suportados para esse comando",
	},

	["noAllowEdit"] = {
		["en-us"] = "You are not allowed to modify this configuration",
		["pt-br"] = "Você não está autorizado a modificar essa configuração",
	},

	["guildDataNotFound"] = {
		["en-us"] = "Guild data not found",
		["pt-br"] = "Dados da guilda não encontrados",
	},

	["muteRoleNotFound"] = {
		["en-us"] = "`Muted` role not found",
		["pt-br"] = "Cargo de `Mutado` não encontrado",
	},

	["modRoleNotFound"] = {
		["en-us"] = "`Moderator` role not found",
		["pt-br"] = "Cargo de `Moderador` não encontrado",
	},

	["adminRoleNotFound"] = {
		["en-us"] = "`Administrator` role not found",
		["pt-br"] = "Cargo de `Administrador` não encontrado",
	},

	["orgRoleNotFound"] = {
		["en-us"] = "`Organizer` role not found",
		["pt-br"] = "Cargo de `Organizador` não encontrado",
	},

	["noPerm"] = {
		["en-us"] = "Insufficient permission",
		["pt-br"] = "Permissão insuficiente",
	},

	["commandCooldownFor"] = {
		["en-us"] = "Command in cooldown for **%s**!",
		["pt-br"] = "Comando em cooldown por **%s**!",
	},

	["cashValueInvalid"] = {
		["en-us"] = "Invalid value for cash amount",
		["pt-br"] = "Valor de dinheiro inválido para o dinheiro",
	},

	["notAvailableLang"] = {
		["en-us"] = "Sorry, but this command is not supported for the selected language!",
		["pt-br"] = "Desculpe, mas esse comando não é suportado para a linguagem selecionada!",
	},

	["noResults"] = {
		["en-us"] = "No results",
		["pt-br"] = "Sem resultados",
	},

	["insufficientFunds"] = {
		["en-us"] = "Insufficient funds",
		["pt-br"] = "Fundos insuficientes",
	},

	["patronsOnlyCommand"] = {
		["en-us"] = "Only patrons have access to this command!",
		["pt-br"] = "Somente patronos tem acesso a esse comando!",
	},

	["commandNotFound"] = {
		["en-us"] = "Command '%s' not found",
		["pt-br"] = "Comando '%s' não encontrado",
	},

	["noPromoteEqual"] = {
		["en-us"] = "You cannot promote that user to your role",
		["pt-br"] = "Você não pode promover esse usuário para o seu cargo",
	},

	["noDemoteEqual"] = {
		["en-us"] = "You cannot demote that user because you have the same role",
		["pt-br"] = "Você não pode rebaixar esse usuário por que vocês tem o mesmo cargo",
	},

	["cannotPromoteUser"] = {
		["en-us"] = "**%s** cannot be promoted",
		["pt-br"] = "**%s** não pode ser promovido",
	},

	["cannotDemoteUser"] = {
		["en-us"] = "**%s** cannot be demoted",
		["pt-br"] = "**%s** não pode ser rebaixado",
	},

	["botDesc"] = {
		["en-us"] = "%s is a multi-purpose bot designed to help moderate your server.",
		["pt-br"] = "%s é um bot multi-uso desenvolvido para ajudar a moderar o seu servidor.",
	},

	["commandRanBy"] = {
		["en-us"] = "Command ran by %s",
		["pt-br"] = "Comando executado por %s",
	},

	["userBanned"] = {
		["en-us"] = "**%s** has been banned",
		["pt-br"] = "**%s** foi banido",
	},

	["userUnbanned"] = {
		["en-us"] = "**%s** has been unbanned",
		["pt-br"] = "**%s** foi desbanido",
	},

	["usersUnbanned"] = {
		["en-us"] = "**%s** users have been unbanned",
		["pt-br"] = "**%s** usuários foram desbanidos",
	},

	["userKicked"] = {
		["en-us"] = "**%s** has been kicked",
		["pt-br"] = "**%s** foi expulso",
	},

	["userUnmuted"] = {
		["en-us"] = "**%s** has been unmuted",
		["pt-br"] = "**%s** foi desmutado",
	},

	["beenDefined"] = {
		["en-us"] = "**%s** has been defined as **%s**",
		["pt-br"] = "**%s** foi definido como **%s**",
	},

	["botDataSaved"] = {
		["en-us"] = "Bot data has been saved",
		["pt-br"] = "Os dados do bot foram salvos com sucesso!",
	},

	["roleAddedMod"] = {
		["en-us"] = "Role `@%s` has been added as `Moderator`",
		["pt-br"] = "O cargo `@%s` foi adicionado como `Moderador`",
	},

	["roleRemovedMod"] = {
		["en-us"] = "Role `@%s` has been removed as a `Moderator`",
		["pt-br"] = "O cargo `@%s` foi removido de `Moderador`",
	},

	["roleAddedAdmin"] = {
		["en-us"] = "Role `@%s` has been added as `Administrator`",
		["pt-br"] = "O cargo `@%s` foi adicionado como `Administrador`",
	},

	["roleRemovedAdmin"] = {
		["en-us"] = "Role `@%s` has been removed as a `Administrator`",
		["pt-br"] = "O cargo `@%s` foi removido de `Administrador`",
	},

	["roleAddedOrganizer"] = {
		["en-us"] = "Role `@%s` has been added as `Organizer`",
		["pt-br"] = "O cargo `@%s` foi adicionado como `Organizador`",
	},

	["roleRemovedOrganizer"] = {
		["en-us"] = "Role `@%s` has been removed as a `Organizer`",
		["pt-br"] = "O cargo `@%s` foi removido de `Organizador`",
	},

	["roleAddedMuted"] = {
		["en-us"] = "Role `@%s` has been added as `Muted`",
		["pt-br"] = "O cargo `@%s` foi adicionado como `Mutado`",
	},

	["roleRemovedMuted"] = {
		["en-us"] = "Role `@%s` has been removed as a `Muted`",
		["pt-br"] = "O cargo `@%s` foi removido de `Mutado`",
	},

	["roleAddedAuto"] = {
		["en-us"] = "Role `@%s` has been added as `Auto Role`",
		["pt-br"] = "O cargo `@%s` foi adicionado como `Cargo Automático`"
	},

	["roleRemovedAuto"] = {
		["en-us"] = "Role `@%s` has been removed as `Auto Role`",
		["pt-br"] = "O cargo `@%s` foi removido de `Cargo Automático`"
	},

	["mutedRoleTip"] = {
		["en-us"] = "Don't forget to set a `Muted` role with **%ssetmute**",
		["pt-br"] = "Não se esqueça de definir um cargo de `Mutado` com **%ssetmute**",
	},

	["modRoleTip"] = {
		["en-us"] = "Don't forget to set a `Moderator` role with **%ssetmod**",
		["pt-br"] = "Não se esqueça de definir um cargo de `Moderador` com **%ssetmod**",
	},

	["adminRoleTip"] = {
		["en-us"] = "Don't forget to set a `Administrator` role with **%ssetadmin**",
		["pt-br"] = "Não se esqueça de definir um cargo de `Administrador` com **%ssetadmin**",
	},

	["orgRoleTip"] = {
		["en-us"] = "Don't forget to set a `Organizer` role with **%ssetorg**",
		["pt-br"] = "Não se esqueça de definir um cargo de `Organizador` com **%ssetorg**",
	},

	["alreadyPatron"] = {
		["en-us"] = "**%s** is already a patron",
		["pt-br"] = "**%s** já é um patrono",
	},

	["notPatron"] = {
		["en-us"] = "**%s** is not a patron",
		["pt-br"] = "**%s** is not a patron",
	},

	["patronAdded"] = {
		["en-us"] = "**%s** is now a patron",
		["pt-br"] = "**%s** agora é um patrono",
	},

	["patronRemoved"] = {
		["en-us"] = "**%s** is no longer a patron",
		["pt-br"] = "**%s** não é mais um patrono",
	},

	["cashSetSuccessful"] = {
		["en-us"] = "Cash for **%s** has been set to **%s**",
		["pt-br"] = "O dinheiro de **%s** foi definido para **%s**",
	},

	["bankSetSuccessful"] = {
		["en-us"] = "Bank for **%s** has been set to **%s**",
		["pt-br"] = "O banco de **%s** foi definido para **%s**",
	},

	["netSetSuccessful"] = {
		["en-us"] = "Networth for **%s** has been set to **%s**",
		["pt-br"] = "O patrimônio de **%s** foi definido para **%s**",
	},

	["serverEconomyReset"] = {
		["en-us"] = "Server economy has been reset",
		["pt-br"] = "A economia do servidor foi resetada",
	},

	["cashWithdrawn"] = {
		["en-us"] = "You've withdrawn **%s** from your bank!",
		["pt-br"] = "Você retirou **%s** do seu banco com sucesso!",
	},

	["cashDeposited"] = {
		["en-us"] = "You've deposited **%s** into your bank!",
		["pt-br"] = "Você depositou **%s** no seu banco com sucesso!",
	},

	["currentBankAmount"] = {
		["en-us"] = "You currently have **%s** in your bank",
		["pt-br"] = "No momento, você tem **%s** no seu banco",
	},

	["currentCashAmount"] = {
		["en-us"] = "You currently have **%s** in cash",
		["pt-br"] = "No momento, você tem **%s** em dinheiro",
	},

	["usernameSet"] = {
		["en-us"] = "Username has been set to '**%s**'",
		["pt-br"] = "O nome de usuário foi definido para '**%s**'",
	},

	["usernameFailed"] = {
		["en-us"] = "Failed to set username to '**%s**'",
		["pt-br"] = "Falha ao definir nome de usuário para '**%s**'",
	},

	["nicknameSet"] = {
		["en-us"] = "Nickname has been set to '**%s**'",
		["pt-br"] = "O apelido foi definido para '**%s**'",
	},

	["nilNickname"] = {
		["en-us"] = "Nickname removed",
		["pt-br"] = "Apelido removido",
	},

	["nicknameFailed"] = {
		["en-us"] = "Failed to set nickname to '**%s**'",
		["pt-br"] = "Falha ao definir apelido para '**%s**'",
	},

	["playingStatusSet"] = {
		["en-us"] = "Playing status has been set to '**%s**'",
		["pt-br"] = "O status de jogando foi definido para '**%s**'",
	},

	["playingStatusFailed"] = {
		["en-us"] = "Failed to set playing status to '**%s**'",
		["pt-br"] = "Falha ao definir status de jogando para '**%s**'",
	},

	["roleSelectedHigher"] = {
		["en-us"] = "Please, make sure that the bot has a role above **%s**",
		["pt-br"] = "Por favor, certifique-se de que o bot tem um cargo acima de **%s**",
	},

	["higherRole"] = {
		["en-us"] = "You cannot select a role greater than or equal to your",
		["pt-br"] = "Você não pode selecionar um cargo maior ou igual ao seu",
	},

	["userPromoted"] = {
		["en-us"] = "**%s** has been promoted to **%s**",
		["pt-br"] = "**%s** foi promovido para **%s**",
	},

	["userDemoted"] = {
		["en-us"] = "**%s** has been demoted to **%s**",
		["pt-br"] = "**%s** foi rebaixado para **%s**",
	},

	["noDefinedRoleFound"] = {
		["en-us"] = "Could not find any pre-defined role",
		["pt-br"] = "Nenhum cargo pré-definido pôde ser encontrado",
	},

	["notEnoughCash"] = {
		["en-us"] = "You don't have enough cash for that",
		["pt-br"] = "Você não tem dinheiro suficiente para isso",
	},

	["userPaidSuccess"] = {
		["en-us"] = "You have paid **%s** to **%s**",
		["pt-br"] = "Você pagou **%s** para **%s**",
	},

	["userCashTaken"] = {
		["en-us"] = "You have taken **%s** from **%s**",
		["pt-br"] = "Você tirou **%s** de **%s**",
	},

	["userCashGiven"] = {
		["en-us"] = "You gave **%s** to **%s**",
		["pt-br"] = "Você deu **%s** para **%s**",
	},

	["neksInvite"] = {
		["en-us"] = "%s",
		["pt-br"] = "%s",
	},

	["invalidAmount"] = {
		["en-us"] = "Invalid amount",
		["pt-br"] = "Quantia inválida",
	},

	["beenKicked"] = {
		["en-us"] = "You have been kicked from **%s**; Moderator note: %s",
		["pt-br"] = "Você foi expulso de **%s**; Nota do moderador: %s",
	},

	["beenBanned"] = {
		["en-us"] = "You have been banned from **%s** and may not rejoin until you are unbanned; Moderator note: %s",
		["pt-br"] = "Você foi banido de **%s** e não poderá retornar até ser desbanido; Nota do moderador: %s",
	},

	["beenMuted"] = {
		["en-us"] = "You have been muted in **%s**; Moderator note: %s",
		["pt-br"] = "Você foi mutado em **%s**; Nota do moderador: %s",
	},

	["botModulesReloaded"] = {
		["en-us"] = "All modules have been reloaded successfully!",
		["pt-br"] = "Todas as modulas foram recarregadas com sucesso!",
	},

	["noExecuteOtherBot"] = {
		["en-us"] = "You cannot execute this command in other bots",
		["pt-br"] = "Você não pode executar esse comando em outros bots",
	},

	["messageWithTermsNotFound"] = {
		["en-us"] = "Message with terms '%s' not found",
		["pt-br"] = "Mensagem com termos '%s' não encontrada",
	},

	["messageSentBy"] = {
		["en-us"] = "Message sent by %s",
		["pt-br"] = "Mensagem enviada por %s",
	},

	["jumpToMessage"] = {
		["en-us"] = "Jump to message",
		["pt-br"] = "Pular para a mensagem",
	},

	["alreadyMuted"] = {
		["en-us"] = "**%s** is already muted!",
		["pt-br"] = "**%s** já está mutado(a)!",
	},

	["videoNotFoundTerms"] = {
		["en-us"] = "Video not found for terms '%s'",
		["pt-br"] = "Vídeo não encontrado com termos '%s'",
	},

	["langNotFound"] = {
		["en-us"] = "Language **%s** not found!",
		["pt-br"] = "Linguagem **%s** não encontrada!",
	},

	["patronLevelSet"] = {
		["en-us"] = "**%s** had his patron level set to **%s**",
		["pt-br"] = "**%s** teve o seu nível de patrono mudado para **%s**",
	},

	["userEmbedEditLost"] = {
		["en-us"] = "**%s**, it seems like you already have an active embed being edited.",
		["pt-br"] = "**%s**, parece que você já tem um embed ativo sendo editado.",
	},

	["couldNotProcess"] = {
		["en-us"] = "Could not process the request",
		["pt-br"] = "O pedido não pôde ser processado",
	},

	["cannotDeleteMoreThanXMessages"] = {
		["en-us"] = "Cannot delete more than **%s** messages at once.",
		["pt-br"] = "Não é possível deletar mais de **%s** mensagens de uma vez",
	},

	["defaultAmountSetTo"] = {
		["en-us"] = "Default amount has been set to: **%s**",
		["pt-br"] = "A quantidade padrão foi definida para: **%s**",
	},

	["startingIn"] = {
		["en-us"] = "Starting in **%ss**...",
		["pt-br"] = "Começando em **%ss**...",
	},

	["failedContinueDetails"] = {
		["en-us"] = "Failed to continue: %s",
		["pt-br"] = "Falha ao continuar: %s",
	},

	["successDeletedXMessages"] = {
		["en-us"] = "Successfully deleted **%s** messages from this channel.",
		["pt-br"] = "**%s** mensagens desse canal foram deletadas com sucesso.",
	},

	["deletedCurrentXMessages"] = {
		["en-us"] = "Messages deleted so far: **%s**",
		["pt-br"] = "Mensagens deletadas até agora: **%s**",
	},

	["userItemEditLost"] = {
		["en-us"] = "**%s**, it seems like you already have an active item being edited.",
		["pt-br"] = "**%s**, parece que você já tem um item ativo sendo editado.",
	},

	["noNameSpecified"] = {
		["en-us"] = "No nome specified.",
		["pt-br"] = "Nenhum nome específicado.",
	},

	["noDescSpecified"] = {
		["en-us"] = "No description specified.",
		["pt-br"] = "Nenhuma descrição específicada.",
	},

	["newItemCanceled"] = {
		["en-us"] = "Item creation canceled.",
		["pt-br"] = "Criação do item cancelada.",
	},

	["newItemCreated"] = {
		["en-us"] = "Item created successfully.",
		["pt-br"] = "Item criado com sucesso.",
	},

	["newItemMissing"] = {
		["en-us"] = "Cannot create item, you must specify: **%s**",
		["pt-br"] = "O item não pode ser criado, você precisa especificar: **%s**",
	},

	["itemNameSpecifiedExists"] = {
		["en-us"] = "An item with the name that you've specified already exists",
		["pt-br"] = "Já existe um item com o nome que você especificou",
	},

	["inventoryItemUsed"] = {
		["en-us"] = "Item used!",
		["pt-br"] = "Item usado!",
	},

	["mustBeInGuildVoice"] = {
		["en-us"] = "You must be in a voice-channel in order for this to work!",
		["pt-br"] = "Você precisa estar em um canal-de-voz para isso funcionar!",
	},

	["shareLinkForVoice"] = {
		["en-us"] = "Screenshare for channel: %s",
		["pt-br"] = "Compartilhamento de tela para: %s",
	},

	["storeItemName"] = {
		["en-us"] = "Item name",
		["pt-br"] = "Nome do item",
	},

	["storeItemDesc"] = {
		["en-us"] = "Item description",
		["pt-br"] = "Descrição do item",
	},

	["storeItemPrice"] = {
		["en-us"] = "Item price",
		["pt-br"] = "Preço do item",
	},

	["storeItemStock"] = {
		["en-us"] = "Item stock",
		["pt-br"] = "Estoque do item",
	},

	["storeItemAwardRole"] = {
		["en-us"] = "Award role",
		["pt-br"] = "Cargo de premiação",
	},

	["storeItemAwardCash"] = {
		["en-us"] = "Award cash",
		["pt-br"] = "Dinheiro de premiação",
	},

	["storeItemRequiredRole"] = {
		["en-us"] = "Required role",
		["pt-br"] = "Cargo necessário",
	},

	["couldNotFindTerms"] = {
		["en-us"] = "Could not find anything with '%s'",
		["pt-br"] = "Nada foi encontrado com os termos '%s'",
	},

	["messageTooLong"] = {
		["en-us"] = "Your message is too long!",
		["pt-br"] = "Sua mensagem é muito grande!",
	},

	["googleTranslationNotFound"] = {
		["en-us"] = "Could not translate your message, try again later or with different terms!",
		["pt-br"] = "Sua mensagem não pode ser traduzida, tente mais tarde ou com termos diferentes!",
	},

	["missingThesePerms"] = {
		["en-us"] = "In order to continue, I must be able to %s",
		["pt-br"] = "Para continuar, eu preciso poder %s",
	},

	["guildNotFound"] = {
		["en-us"] = "Guild not found!",
		["pt-br"] = "Guilda não encontrada!",
	},

	["successLeftGuild"] = {
		["en-us"] = "Successfully left guild (**%s**)",
		["pt-br"] = "Guilda deixada com sucesso (**%s**)",
	},

	["itemNotFoundName"] = {
		["en-us"] = "Item not found!",
		["pt-br"] = "Item não encontrado!",
	},

	["itemDeletedFromStore"] = {
		["en-us"] = "Item successfully deleted from the store",
		["pt-br"] = "Item deletado da loja com sucesso",
	},

	["storeItemCashNeeded"] = {
		["en-us"] = "You're **%s** short from buying that item!",
		["pt-br"] = "Você precisa de mais **%s** para comprar esse item!",
	},

	["storeItemOutStock"] = {
		["en-us"] = "This item has ran out of stock!",
		["pt-br"] = "Esse item não está mais em estoque!",
	},

	["stockItemBuyMax"] = {
		["en-us"] = "You can only buy **%s** editions of this item!",
		["pt-br"] = "Você só pode comprar **%s** edições deste item!",
	},

	["successBoughtItem"] = {
		["en-us"] = "Item successfully bought!",
		["pt-br"] = "Item comprado com sucesso!",
	},

	["itemUseMustHaveRole"] = {
		["en-us"] = "You must have the **%s** role in order to use this item!",
		["pt-br"] = "Você precisa ter o cargo **%s** para poder usar este item!",
	},

	["itemDoesNotHave"] = {
		["en-us"] = "You don't have this item!",
		["pt-br"] = "Você não tem esse item!",
	},

	["successGaveItem"] = {
		["en-us"] = "Successfully gave the item!",
		["pt-br"] = "Item dado com sucesso!",
	},

	["ctxClearedDone"] = {
		["en-us"] = "Context has been cleared successfully",
		["pt-br"] = "Contexto limpo com sucesso",
	},

	["followingUserBeenMuted"] = {
		["en-us"] = "**%s** has been muted for **%s**",
		["pt-br"] = "**%s** foi mutado por **%s**",
	},

	["followingUsersBeenMuted"] = {
		["en-us"] = "**%s** have been muted for **%s**",
		["pt-br"] = "**%s** foram mutados por **%s**",
	},

	["followingUserCannotMute"] = {
		["en-us"] = "**%s** could not be muted",
		["pt-br"] = "**%s** não pode ser mutado",
	},

	["followingUsersCannotMute"] = {
		["en-us"] = "**%s** could not be muted",
		["pt-br"] = "**%s** não puderam ser mutados",
	},

	["followingUserAlreadyMuted"] = {
		["en-us"] = "**%s** is already muted",
		["pt-br"] = "**%s** já está mutado",
	},

	["followingUsersAlreadyMuted"] = {
		["en-us"] = "**%s** are already muted",
		["pt-br"] = "**%s** já estão mutados",
	},

	["followingUserBeenUnmuted"] = {
		["en-us"] = "**%s** has been unmuted",
		["pt-br"] = "**%s** foi desmutado",
	},

	["followingUsersBeenUnmuted"] = {
		["en-us"] = "**%s** have been unmuted",
		["pt-br"] = "**%s** foram desmutados",
	},

	["followingUserNotMuted"] = {
		["en-us"] = "**%s** is not muted",
		["pt-br"] = "**%s** não está mutado",
	},

	["followingUsersNotMuted"] = {
		["en-us"] = "**%s** are not muted",
		["pt-br"] = "**%s** não estão mutados",
	},

	["peopleAgree"] = {
		["en-us"] = "People agree",
		["pt-br"] = "Pessoas concordam",
	},

	["peopleDisagree"] = {
		["en-us"] = "People disagree",
		["pt-br"] = "Pessoas discordam",
	},

	-- Erros do Discord
	["discordError50034"] = {
		["en-us"] = "You can only bulk delete messages that are under 14 days old.",
		["pt-br"] = "Você só pode eliminar mensagens com menos de 14 dias.",
	},

	-- Descrições de Comandos
	["editsStoreItem"] = {
		["en-us"] = "edits an item from the store.",
		["pt-br"] = "edita um item da loja.",
	},

	["sendsFeedbackCreator"] = {
		["en-us"] = "submits a feedback to the development team.",
		["pt-br"] = "envia um feedback para o time de desenvolvimento.",
	},

	["categoryDescBase"] = {
		["en-us"] = "main and essential.",
		["pt-br"] = "principal e essencial.",
	},

	["categoryDescEconomy"] = {
		["en-us"] = "economy and items.",
		["pt-br"] = "economia e itens.",
	},

	["categoryDescFun"] = {
		["en-us"] = "fun and games.",
		["pt-br"] = "diversão e jogos.",
	},

	["categoryDescModeration"] = {
		["en-us"] = "moderation tools.",
		["pt-br"] = "ferramentas de moderação.",
	},

	["getsIpData"] = {
		["en-us"] = "gets information about an IP",
		["pt-br"] = "pega informações sobre um IP",
	},

	["getsDefinition"] = {
		["en-us"] = "gets the definition for the word or phrase given.",
		["pt-br"] = "pega a definição da palavra ou frase dada.",
	},

	["showsMutes"] = {
		["en-us"] = "shows the currently muted user or users.",
		["pt-br"] = "mostra o usuário ou usuários atualmente mutados.",
	},

	["givesItemToSomeone"] = {
		["en-us"] = "gives the mentioned item to the mentioned person or more.",
		["pt-br"] = "dá o item mencionado para uma ou mais pessoas.",
	},

	["showsRobloxProfile"] = {
		["en-us"] = "shows the ROBLOX profile of the mentioned user.",
		["pt-br"] = "mostra o perfil no ROBLOX do usuário mencionado.",
	},

	["searchesImage"] = {
		["en-us"] = "searches on google for the mentioned image.",
		["pt-br"] = "pesquisa no google pela imagem mencionada.",
	},

	["setsNsfwMode"] = {
		["en-us"] = "sets the NSFW mode for the channel you're in.",
		["pt-br"] = "define o modo NSFW para o canal que você está.",
	},

	["usesItemFromInventory"] = {
		["en-us"] = "uses the mentioned item in your inventory.",
		["pt-br"] = "usa o item mencionado que está em seu inventário.",
	},

	["showsInventory"] = {
		["en-us"] = "shows your inventory.",
		["pt-br"] = "mostra o seu inventário.",
	},

	["zappifiesText"] = {
		["en-us"] = "zappifies text.",
		["pt-br"] = "zapifica o texto.",
	},

	["buysItemFromStore"] = {
		["en-us"] = "buys an item from the store.",
		["pt-br"] = "compra um item da loja.",
	},

	["removesItemFromStore"] = {
		["en-us"] = "removes the mentioned item from the store.",
		["pt-br"] = "remove o item mencionado da loja.",
	},

	["leavesMentionedGuild"] = {
		["en-us"] = "leaves the mentioned guild.",
		["pt-br"] = "sai da guilda mencionada.",
	},

	["showsGlobalGuildsList"] = {
		["en-us"] = "shows the global list of guilds that the bot is in.",
		["pt-br"] = "mostra a lista global de guildas em que o bot está.",
	},

	["translatesYourText"] = {
		["en-us"] = "translates your text.",
		["pt-br"] = "traduz o seu texto.",
	},

	["emojifiesText"] = {
		["en-us"] = "turns your text into emojis.",
		["pt-br"] = "transforma o seu texto em emojis.",
	},

	["searchesGoogle"] = {
		["en-us"] = "searches on google for what you want.",
		["pt-br"] = "pesquisa no google pelo oque você quiser",
	},

	["createsStoreItem"] = {
		["en-us"] = "creates a new item for the store of the server.",
		["pt-br"] = "cria um novo item para a loja do servidor.",
	},

	["createsScreenshare"] = {
		["en-us"] = "creates a screenshare link for your voice-channel.",
		["pt-br"] = "cria um link de compartilhamento de tela para o seu canal-de-voz.",
	},

	["getRoleInfo"] = {
		["en-us"] = "gets information about a role.",
		["pt-br"] = "pega informações de um cargo.",
	},

	["setsLang"] = {
		["en-us"] = "sets the default language.",
		["pt-br"] = "modifica o idioma padrão.",
	},

	["setsPrefix"] = {
		["en-us"] = "sets the default prefix.",
		["pt-br"] = "modifica o prefixo padrão.",
	},

	["setsDelCmd"] = {
		["en-us"] = "sets whether to delete commands after being ran or not.",
		["pt-br"] = "define se os comandos serão deletados após serem executados ou não.",
	},

	["purgesMessages"] = {
		["en-us"] = "bulk deletes the defined number of messages.",
		["pt-br"] = "limpa em massa o número de mensagens definidas.",
	},

	["answersYesNoMaybe"] = {
		["en-us"] = "says yes, no or maybe",
		["pt-br"] = "diz sim, não ou talvez",
	},

	["saysPong"] = {
		["en-us"] = "says pong!",
		["pt-br"] = "diz pong!",
	},

	["helpMessage"] = {
		["en-us"] = "shows a help message.",
		["pt-br"] = "mostra uma mensagem de ajuda.",
	},

	["showCat"] = {
		["en-us"] = "shows an image of a cat.",
		["pt-br"] = "mostra uma imagem de gato.",
	},

	["showDog"] = {
		["en-us"] = "shows an image of a dog.",
		["pt-br"] = "mostra uma imagem de cachorro.",
	},

	["bansUser"] = {
		["en-us"] = "bans the mentioned user.",
		["pt-br"] = "bane o usuário mencionado.",
	},

	["unbansUser"] = {
		["en-us"] = "unbans the mentioned user.",
		["pt-br"] = "desbane o usuário mencionado.",
	},

	["kicksUser"] = {
		["en-us"] = "kicks the mentioned user.",
		["pt-br"] = "expulsa o usuário mencionado.",
	},

	["modsUser"] = {
		["en-us"] = "gives the mentioned user the `Moderator` role.",
		["pt-br"] = "dá ao usuário mencionado o cargo de `Moderador`.",
	},

	["unmodsUser"] = {
		["en-us"] = "removes from the mentioned user the `Moderator` role.",
		["pt-br"] = "tira o cargo `Moderador` do usuário mencionado.",
	},

	["adminsUser"] = {
		["en-us"] = "gives the mentioned user the `Administrator` role.",
		["pt-br"] = "dá ao usuário mencionado o cargo de `Administrador`.",
	},

	["unadminsUser"] = {
		["en-us"] = "removes from the mentioned user the `Administrator` role.",
		["pt-br"] = "tira o cargo `Administrador` do usuário mencionado.",
	},

	["orgsUser"] = {
		["en-us"] = "gives the mentioned user the `Organizer` role.",
		["pt-br"] = "dá ao usuário mencionado o cargo de `Organizador`.",
	},

	["unorgsUser"] = {
		["en-us"] = "removes from the mentioned user the `Organizer` role.",
		["pt-br"] = "tira o cargo `Organizador` do usuário mencionado.",
	},

	["showsEmote"] = {
		["en-us"] = "displays the unicode for an emote.",
		["pt-br"] = "exibe o unicode para um emote.",
	},

	["mutesUser"] = {
		["en-us"] = "mutes the mentioned user.",
		["pt-br"] = "silencia o usuário mencionado.",
	},

	["unmutesUser"] = {
		["en-us"] = "unmutes the mentioned user.",
		["pt-br"] = "desmuta o usuário mencionado.",
	},

	["botSays"] = {
		["en-us"] = "makes the bot say something.",
		["pt-br"] = "faz o bot dizer sua mensagem.",
	},

	["evalsMath"] = {
		["en-us"] = "evaluates a mathematical expression.",
		["pt-br"] = "processa uma expressão matemática.",
	},

	["constructsEmbed"] = {
		["en-us"] = "begins constructing an embed.",
		["pt-br"] = "começa a construir um embed.",
	},

	["returnsUserInfo"] = {
		["en-us"] = "returns basic information about an user.",
		["pt-br"] = "retorna informações básicas sobre um usuário.",
	},

	["returnsServerInfo"] = {
		["en-us"] = "returns basic information about an user.",
		["pt-br"] = "retorna informações básicas sobre o servidor.",
	},

	["allowsLua"] = {
		["en-us"] = "allows you to run Lua commands from the bot.",
		["pt-br"] = "permite você executar códigos em Lua pelo bot.",
	},

	["setsGlobalConfig"] = {
		["en-us"] = "sets a global configuration.",
		["pt-br"] = "define uma configuração global.",
	},

	["owoifiesText"] = {
		["en-us"] = "owoifies a text.",
		["pt-br"] = "owoifica um texto.",
	},

	["savesBotDataAndEdit"] = {
		["en-us"] = "saves bot data and ends the application.",
		["pt-br"] = "salva os dados do bot e fecha o aplicativo.",
	},

	["setsBotGame"] = {
		["en-us"] = "sets the bot's playing status.",
		["pt-br"] = "modifica o status de jogando do bot.",
	},

	["updatesBotData"] = {
		["en-us"] = "forcefully updates the bot data.",
		["pt-br"] = "atualiza as informações do bot à força.",
	},

	["addsAutoRole"] = {
		["en-us"] = "set up an `Auto Role` for new members.",
		["pt-br"] = "configura um `Cargo Automático` para novos membros.",
	},

	["removesAutoRole"] = {
		["en-us"] = "removes `Auto Role` for new members.",
		["pt-br"] = "remove `Cargo Automático` para novos membros.",
	},

	["addsRoleMod"] = {
		["en-us"] = "gives `Moderator` permissions to the mentioned role.",
		["pt-br"] = "dá permissões de `Moderador` para o cargo mencionado.",
	},

	["removesRoleMod"] = {
		["en-us"] = "removes `Moderator` permissions from the mentioned role.",
		["pt-br"] = "remove as permissões de `Moderador` do cargo mencionado.",
	},

	["addsRoleAdmin"] = {
		["en-us"] = "gives `Administrator` permissions to the mentioned role.",
		["pt-br"] = "dá permissões de `Administrador` para o cargo mencionado.",
	},

	["removesRoleAdmin"] = {
		["en-us"] = "removes `Administrator` permissions from the mentioned role.",
		["pt-br"] = "remove as permissões de `Administrador` do cargo mencionado.",
	},

	["addsRoleOrganizer"] = {
		["en-us"] = "gives `Organizer` permissions to the mentioned role.",
		["pt-br"] = "dá permissões de `Organizador` para o cargo mencionado.",
	},

	["removesRoleOrganizer"] = {
		["en-us"] = "removes `Organizer` permissions from the mentioned role.",
		["pt-br"] = "remove as permissões de `Organizador` do cargo mencionado.",
	},

	["addsRoleMuted"] = {
		["en-us"] = "makes the mentioned role the main role for `Muted`.",
		["pt-br"] = "torna o cargo mencionado o cargo principal de `Mutado`.",
	},

	["removesRoleMuted"] = {
		["en-us"] = "removes the mentioned role from being the `Muted` role.",
		["pt-br"] = "remove o cargo mencionado do principal de `Mutado`.",
	},

	["listsDefinedRoles"] = {
		["en-us"] = "lists the defined roles accordingly their permissions.",
		["pt-br"] = "lista os cargos definidos de acordo com suas permissões.",
	},

	["addsPatron"] = {
		["en-us"] = "adds the mentioned user to the patrons list.",
		["pt-br"] = "adiciona o usuário mencionado à lista de patronos.",
	},

	["listsPatrons"] = {
		["en-us"] = "shows the patrons list.",
		["pt-br"] = "mostra a lista de patronos.",
	},

	["listsEconomyTopUsers"] = {
		["en-us"] = "shows the top list for the economy ranking of this server.",
		["pt-br"] = "mostra lista dos maiores no ranking de economia do servidor.",
	},

	["laranjosText"] = {
		["en-us"] = "laranjofies the text.",
		["pt-br"] = "faz o laranjo reescrever o texto.",
	},

	["withdrawsCash"] = {
		["en-us"] = "withdraws the specified amount from your bank.",
		["pt-br"] = "saca o dinheiro da sua conta do banco.",
	},

	["depositsCash"] = {
		["en-us"] = "deposits the specified amount of cash into your bank.",
		["pt-br"] = "deposita a quantia especificada para o seu banco.",
	},

	["promotesUser"] = {
		["en-us"] = "promotes the mentioned user to the next rank.",
		["pt-br"] = "promove o usuário mencionado para o próximo cargo.",
	},

	["demotesUser"] = {
		["en-us"] = "demotes the mentioned user to their previous rank.",
		["pt-br"] = "rebaixa o usuário mencionado para o cargo anterior.",
	},

	["setsUsername"] = {
		["en-us"] = "sets the bot's username.",
		["pt-br"] = "modifica o nome do bot.",
	},

	["setsNickname"] = {
		["en-us"] = "sets the bot's nickname.",
		["pt-br"] = "modifica o apelido do bot.",
	},

	["seesUserAvatar"] = {
		["en-us"] = "show your avatar or the mentioned user's avatar.",
		["pt-br"] = "mostra o seu avatar ou o avatar do usuário mencionado.",
	},

	["checksBalance"] = {
		["en-us"] = "checks your cash and bank.",
		["pt-br"] = "checa o seu dinheiro e conta bancária.",
	},

	["worksForMoney"] = {
		["en-us"] = "works for money.",
		["pt-br"] = "trabalha por dinheiro.",
	},

	["commitsCrimeForMoney"] = {
		["en-us"] = "commits a crime for money.",
		["pt-br"] = "comete um crime por dinheiro.",
	},

	["setsCashAmount"] = {
		["en-us"] = "sets the cash amount for the mentioned user.",
		["pt-br"] = "altera o valor do dinheiro do usuário mencionado.",
	},

	["setsBankAmount"] = {
		["en-us"] = "sets the bank amount for the mentioned user.",
		["pt-br"] = "altera o valor do banco do usuário mencionado.",
	},

	["setsNetAmount"] = {
		["en-us"] = "sets the networth amount for the mentioned user.",
		["pt-br"] = "altera o valor do patrimônio do usuário mencionado.",
	},

	["insultsSomeone"] = {
		["en-us"] = "insults someone.",
		["pt-br"] = "insulta alguém.",
	},

	["showsDadJoke"] = {
		["en-us"] = "shows a dad joke.",
		["pt-br"] = "faz uma piada sobre pai.",
	},

	["chuckNorrisFact"] = {
		["en-us"] = "shows a fact about Chuck Norris.",
		["pt-br"] = "mostra um fato sobre o Chuck Norris.",
	},

	["makesMeme"] = {
		["en-us"] = "makes a meme.",
		["pt-br"] = "cria um meme.",
	},

	["paysSomeone"] = {
		["en-us"] = "gives someone the amount you specify.",
		["pt-br"] = "dá para alguém a quantia que você especificar.",
	},

	["showsServerStore"] = {
		["en-us"] = "shows the store of your guild.",
		["pt-br"] = "mostra a loja de sua guilda.",
	},

	["invitesNekito"] = {
		["en-us"] = "shows Nekito's invite link.",
		["pt-br"] = "mostra o link de convite do Nekito.",
	},

	["resetsServerEconomy"] = {
		["en-us"] = "resets the server economy.",
		["pt-br"] = "reseta a economia do servidor.",
	},

	["reloadsBotModules"] = {
		["en-us"] = "reloads all modules.",
		["pt-br"] = "recarrega todas as modulas.",
	},

	["teachesToGoogle"] = {
		["en-us"] = "googles something for lazy people.",
		["pt-br"] = "procura algo no google para pessoas preguiçosas.",
	},

	["quotesMesage"] = {
		["en-us"] = "quotes a message in the chat.",
		["pt-br"] = "marca uma mensagem do chat.",
	},

	["showsClan"] = {
		["en-us"] = "shows information about your clan.",
		["pt-br"] = "mostra informações sobre o seu clã.",
	},

	["searchesYoutubeVideo"] = {
		["en-us"] = "searches for a youtube video.",
		["pt-br"] = "procura por um vídeo no youtube.",
	},

	-- Comando work
	["workedAsBartender"] = {
		["en-us"] = "You've worked as a bartender serving drinks all night and made **%s**",
		["pt-br"] = "Você trabalhou como bartender servindo bebidas à noite toda e conseguiu **%s**",
	},

	["workedAsDJ"] = {
		["en-us"] = "You've worked as DJ cheering a party all night and made **%s**",
		["pt-br"] = "Você trabalhou como DJ animando a festa durante à noite toda e conseguiu **%s**",
	},

	["workedAsUberDriver"] = {
		["en-us"] = "You've worked as a Uber driver taking people to everywhere and made **%s**",
		["pt-br"] = "Você trabalhou como motorista de Uber levando pessoas para todos os locais e conseguiu **%s**",
	},

	["workedAsAviator"] = {
		["en-us"] = "You've worked as a plane aviator taking people to their destinations and made **%s**",
		["pt-br"] = "Você trabalhou como piloto de aeronaves levando os passageiros até seus destinos e conseguiu **%s**",
	},

	["workedAsProgrammer"] = {
		["en-us"] = "You've worked as a programmer in a community project and made **%s**",
		["pt-br"] = "Você trabalhou como programador em um projeto comunitário e conseguiu **%s**",
	},

	["workedAsArchitect"] = {
		["en-us"] = "You've worked as architect developing various houses and buildings and made **%s**",
		["pt-br"] = "Você trabalhou como arquiteto desenvolvendo várias casas e prédios e conseguiu **%s**",
	},

	["workedAsBusDriver"] = {
		["en-us"] = "You've worked as a bus driver for all over the city and made **%s**",
		["pt-br"] = "Você trabalhou como motorista de ônibus por toda à cidade e conseguiu **%s**",
	},

	["workedAsButcher"] = {
		["en-us"] = "You've worked as a butcher cutting many meats and made **%s**",
		["pt-br"] = "Você trabalhou como açougueiro cortando várias carnes e conseguiu **%s**",
	},

	["workedAsElectrician"] = {
		["en-us"] = "You've worked as an electrician setting up some wires and made **%s**",
		["pt-br"] = "Você trabalhou como eletricista passando vários fios e conseguiu **%s**",
	},

	["workedAsFarmer"] = {
		["en-us"] = "You've worked as a farmer taking care of cows, pigs and chickens and made **%s**",
		["pt-br"] = "Você trabalhou como fazendeiro cuidando das vacas, porcos e galinhas e conseguiu **%s**",
	},

	["workedAsFlorist"] = {
		["en-us"] = "You've worked as a florist taking care of many roses, sunflowers and other flowers and made **%s**",
		["pt-br"] = "Você trabalhou como florista cuidando de várias rosas, girassóis e outras flores e conseguiu **%s**",
	},

	["workedAsDoctor"] = {
		["en-us"] = "You've worked as a doctor taking care of your patients in pain and other issues and made **%s**",
		["pt-br"] = "Você trabalhou como médico cuidando de seus pacientes com dores e outros problemas e conseguiu **%s**",
	},

	["workedAsFisherman"] = {
		["en-us"] = "You've worked as a fisher fishing many rare fishes and letting go of the ones in extinction and made **%s**",
		["pt-br"] = "Você trabalhou como pescador fisgando vários peixes raros e soltando os que estavam em extinção e conseguiu **%s**",
	},

	["workedAsGardener"] = {
		["en-us"] = "You've worked as a gardener taking care of the garden of a very sweet lady and made **%s**",
		["pt-br"] = "Você trabalhou como jardineiro cuidando do jardim de uma senhora bem doce e conseguiu **%s**",
	},

	["workedAsHairdresser"] = {
		["en-us"] = "You've worked as a haircutter cutting the hair of every client that would enter your sallon and made **%s**",
		["pt-br"] = "Você trabalhou como cabeleireiro cortando o cabelo de todo cliente que entrava em seu salão e conseguiu **%s**",
	},

	["workedAsLifeguard"] = {
		["en-us"] = "You've worked as a life-guard in a very populous beach during all day and made **%s**",
		["pt-br"] = "Você trabalhou como salva-vidas em uma praia bem populosa durante toda à tarde e conseguiu **%s**",
	},

	["workedAsMechanic"] = {
		["en-us"] = "You've worked as a mechanic fixing various cars and bikes during all day and made **%s**",
		["pt-br"] = "Você trabalhou como mecânico arrumando vários carros e motos durante todo o dia e conseguiu **%s**",
	},
}

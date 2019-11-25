--[[
	Como principal funcionalidade do bot, todos os arquivos foram separados
	da melhor forma possível para garantir a organização.
	Algumas partes do código geral globalizam funções e/ou variáveis para
	que elas possam ser acessadas por outras partes do bot também.

	Esse script em especial é responsável por garantir as funcionalidades
	vitais do bot e a sua inicialização.
]]

-- Agrupa as principais funcionalidades para o bot
discordia = require("discordia") -- Carrega as funcionalidades da biblioteca Discordia
emitter = discordia.Emitter() -- Função para inscrever callbacks conforme sinais forem ativados
time = discordia.Time() -- Biblioteca com funções relacionadas à tempo
enums = discordia.enums -- Dicionário de valores enumerados para serem usados via Discordia
discordia.extensions() -- Carrega as extensões disponíveis pelo autor do Discordia na memória
client = discordia.Client({ -- Inicializa o cliente conforme as configurações
	cacheAllMembers = true,
	logLevel = 3,
	logFile = ""
})

-- Atalhos string
byte = string.byte -- Retorna o número do código interno do caractér
char = string.char -- Retorna uma string com tamanho igual aos argumentos
dump = string.dump -- Retorna uma representação binária da função passada
find = string.find -- Retorna a posição de inicio e fim em uma string passada
format = string.format -- Formata um padrão e retorna o resultado
gmatch = string.gmatch -- Retorna uma função de iteração para cada captura
gsub = string.gsub -- Substitui cada valor encontrado em uma string
len = string.len -- Retorna o tamanho numérico de uma string
lower = string.lower -- Retorna a string passada em letras minúsculas
match = string.match -- Retorna uma captura
rep = string.rep -- Repete uma string x vezes
reverse = string.reverse -- Retorna a string em ordem inversa
sub = string.sub -- Retorna parte de uma string conforme x e y
upper = string.upper -- Retorna a string passada em letras maiúsculas
startsWith = string.startswith -- Retorna se uma string inicia com o argumento
endsWith = string.endswith -- Retorna se uma string finaliza-se com o argumento
split = string.split -- Divide uma string em vários valores em um vetor
trim = string.trim -- Remove todos os espaços no inicio e fim de uma string
pad = string.pad -- Alinha a string para direita, centro ou esquerda
levenshtein = string.levenshtein -- Retorna a distância entre duas strings

-- Atalhos math
abs = math.abs -- Retorna o absoluto ou valor não negativo
acos = math.acos -- Retorna o cosseno inverso
asin = math.asin -- Retorna o seno em radianos
atan = math.atan -- Retorna a tangente inversa em radianos
atan2 = math.atan2 -- Retorna o arco tangente de y/x em radianos
ceil = math.ceil -- Retorna o inteiro superior ao número decimal
cos = math.cos -- Retorna o cosseno do valor
clamp = math.clamp -- Retorna o valor dentro dos limites de x e y
deg = math.deg -- Converte radianos para gráus
exp = math.exp -- Retorna o exponencial do número
floor = math.floor -- Retorna o inteiro inferior ao número decimal
fmod = math.fmod -- Retorna o restante da divisão de x por y
frexp = math.frexp -- Retorna m e n de forma que x = m2^6 e o valor de m = 0.5-1
huge = math.huge -- Retorna um número infinito representado por math.huge
ldexp = math.ldexp -- Retorna m2^6 (m deve ser inteiro)
log = math.log -- Retorna o logaritmo natural de x
log10 = math.log10 -- Retorna a base-10 do logaritmo de x
max = math.max -- Retorna o maior número dentre os que forem passados
min = math.min -- Retorna o menor número dentre os que forem passados
modf = math.modf -- Retorna a parte integral e fracional de x
pow = math.pow -- Retorna o número à potencia
pi = math.pi -- Retorna pi (3.1415..)
rad = math.rad -- Converte gráus para radianos
random = math.random -- Retorna um número aleatório de 0-1 (ou entre dois)
randomSeed = math.randomseed -- Define x como a seed para o pseudo-aleatório
sin = math.sin -- Retorna o seno de x
sinh = math.sinh -- Retorna o seno hiberbólico de x
sqrt = math.sqrt -- Retorna a raiz quadrada de x
tan = math.tan -- Retorna a tangente de x
tanh = math.tanh -- Retorna a tangente hiberbólica de x

-- Atalhos table
concat = table.concat -- Concatena uma table x conforme um padrão passado y
copy = table.copy -- Retorna a copia de uma table, fundo em até uma camada
insert = table.insert -- Insere em uma table um valor ou item
remove = table.remove -- Remove de uma table o item com posição passado
unpack = table.unpack -- Retorna em multiplos argumentos os itens de uma table
sort = table.sort -- Ordena uma table; Caso uma função for passada, usa ela como base
deepCopy = table.deepcopy -- Retorna a copia completa de uma table
deepCount = table.deepcount -- Retorna a contagem completa de itens de uma table
slice = table.slice -- Retorna a table cortada de x a y
randomPair = table.randompair -- Retorna uma chave e valor de ordem aleatória
randomIpair = table.randomipair -- Retorna uma chave e valor de ordem aleatória
reverse = table.reverse -- Inverte a table passada
reversed = table.reversed -- Retorna uma copia invertida da table passada
keys = table.keys -- Retorna uma table array onde todos os valores são chaves da table original
values = table.values -- Retorna uma table array onde todos os valores são valores da table original
sorted = table.sorted -- Retorna uma copia da table original utilizando sort
search = table.search -- Procura dentre todos os valores de uma table até encontrar o item mencionado
last = function(list) return list[#list] end -- Retorna o último elemento da table (array)

-- Extensões principais
fs = require("fs") -- Extensão responsável por administrar o acesso à caminhos do sistema
http = require("coro-http") -- Extensão para fazer pedidos HTTP
json = require("json") -- Extensão de utilidades para encodificar e decodificar JSON
timer = require("timer") -- Extensão para fazer uso do sistema de tempo do Luvit
parse = require("url").parse -- Extensão para parsing de URL
spawn = require("coro-spawn") -- Extensão para executar funções dentro de novas threads
luaxp = require("luaxp") -- Extensão para avaliar expressões numéricas
url = require("url") -- Extensão para utilizar funções de encodificação e parsing para HTTP
urlParse = url.parse
urlFormat = url.format
urlResolveObject = url.resolveObject
urlResolve = url.resolve
query = require("querystring") -- Extensão para embutir chaves e valores em uma URL HTTP
urlEncode = query.urlencode
urlDecode = query.urldecode
urlStringify = query.stringify

-- Pontos pricipais de acesso
bot = {} -- Registro de informações à serem usadas para registros do bot
saves = {} -- Table que constitui todos os databases salvos
config = {} -- Pré-registro de configurações

timeUnit = { -- Registra variáveis relacionadas à tempo
	second = 1,
	minute = 60,
	hour = 3600,
	day = 86400,
	week = 604800,
	month = 2592000,
	year = 31536000,
}

randomSeed(os.time()) -- Gera um novo pseudo para aleatorização de valores

-- Funções facilitadoras essenciais
function wait(num) -- Baseado no timer.sleep que não para o processo de execução principal do Luvit (loops, while)
	return timer.sleep(num * 1000)
end

function printf(text, ...) -- Print formatado que permite exibir um texto ao mesmo tempo que há a formatação
	return print(format(text, ...))
end

function append(...)
    local args = {...}
    return format(rep("%s", #args), ...)
end

function runDOS(cmd, raw) -- Função para rodar comandos no console e retornar os resultados
  local func = assert(io.popen(cmd, 'r'))
  local result = assert(func:read('*a'))

  func:close()

  if raw then
	  return result
  end

  result = gsub(result, '^%s+', '')
  result = gsub(result, '%s+$', '')
  result = gsub(result, '[\n\r]+', ' ')

  return result
end

function loadFile(path) -- Função principal para carregar arquivos que estão presentes em um caminho pré-definido
	local file = fs.readFileSync(path)
	local fileName = path:split("/")[-1]

	if fileName then
		fileName = fileName[#fileName]
	else
		fileName = format("unknownFilename (%s)", tostring(os.time() + random()):gsub("[.]", ""))
	end

	if file then
		local code, err = loadstring(file, fileName)

		if code then
			setfenv(code, getfenv())

			local success, result = pcall(code)

			if success then
				return result
			else
				printf("Runtime Error: %s | %s", fileName, ret)
				return false
			end
		else
			printf("Syntax Error: %s | %s", fileName, err)
			return false
		end
	else
		printf("Load Error: %s | %s", code, err)
		return false
	end
end

function loadAllFiles(path, callback) -- Carrega todos os arquivos da pasta e subpastas
	for file, type in fs.scandirSync(path) do
		if type == "file" then
			local loaded = loadFile(format("%s/%s", path, file))

			if callback and loaded then
				callback(loaded)
			end
		elseif type == "directory" then
			loadAllFiles(format("%s/%s", path, file))
		end
	end
end

-- Salva todos os dados
function saveAllData()
	for name, data in next, saves do
		db.save(data:raw(), name)
	end
end

-- Inicializa a estrutura
function loadBot()
	-- Inicializa o bot
	local startMessage = format("%s %s %s\n", rep("-", 10), os.date("%m/%d/%Y %I:%M %p"), rep("-", 10))

	bot.loaded = false
	print(format("\n%s", startMessage))
	client:removeAllListeners()

	loadAllFiles("./config/") -- Carrega todos os arquivos de configuração
	loadAllFiles("./libs/") -- Carrega as extensões de facilitação
	loadAllFiles("./utils/") -- Carrega os pontos de utilidade do bot
	loadAllFiles("./events/") -- Carrega os eventos direcionados

	-- Carrega todos os comandos
	for category, type in fs.scandirSync("./addons/") do
		if type == "directory" then
			for file, type in fs.scandirSync(format("./addons/%s/", category)) do
				if type == "file" then
					local addon = loadFile(format("./addons/%s/%s", category, file))

					if addon then
						local aliases = addon.config.aliases
						addon.config.category = format("${%s}", category)
						addon.config.func = addon.func
						addon.config.aliases = nil
						commands:create(addon.config):accept(unpack(aliases))
					else
						printf("Failed to load %s of category %s", file, category)
					end
				end
			end
		end
	end

	-- Carrega todos os dados
	saves.global = cache(db.load("global") or {}) -- Informações principais de guildas
	saves.economy = cache(db.load("economy") or {}) -- Economia de servidores e itens das lojas virtuais
	saves.track = cache(db.load("track") or {}) -- Rastreadores globais de mutes e patronos
	saves.temp = cache(db.load("temp") or {}) -- Informações temporárias de utilização de comandos
	bot.loaded = true
end

-- Verifica se há atualizações disponíveis no repositório
--print("Checking for Repository Updates...")
--printf("Project status: %s", runDOS("git pull"))

-- Inicializa o processo principal
loadBot()
client:run(format("Bot %s", config.main.botToken))

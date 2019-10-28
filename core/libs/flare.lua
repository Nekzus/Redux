--[[
	Parte responsável por registrar callbacks que serão ativados por eventos
]]

-- Cria um construtor para registrar os métodos e metamétodos
local main = {}
main.__index = main

-- Cria uma nova seed para o gerador pseudo-random
randomSeed(os.time())

-- Função construtora que cria um novo objeto 'flare' para ser usado
function main:__call(first, ...)
	if self.mode == 1 then
		for _, func in next, self.tasks do
			func(first, ...)
		end
	elseif self.mode == 2 then
		for _, func in next, self.tasks do
			local ret = {func(first, ...)}

			if #ret > 0 then
				return unpack(ret)
			else
				return nil
			end
		end
	end

	return setmetatable({
		mode = max(0, min(2, first or 1)),
		tasks = {}
	}, main)
end

-- Registra um novo callback
function main:task(func)
	local index = tostring(func)
	local tasks = self.tasks
	local ret = {}

	tasks[index] = func

	function ret:close()
		tasks[index] = nil
	end

	return ret
end

-- Limpa todos os callbacks atualmente registrados
function main:flush()
	for k, v in next, self.tasks do
		self.tasks[k] = nil
	end

	self.tasks = {}
end

-- Registra o processo
flare = setmetatable({}, main)

-- Retorna o processo para confirmar que houve a execução sem erros
return flare

--[[
	Parte responsável por lidar com pedidos HTTP GET, POST e outros.
]]

-- Função base para criar os pedidos
function httpHandle(method, apiName, param, ...)
	local point
	local link = config.apiPoints[apiName]

	if access then
		if param then
			point = format(link, unpack(param))
		else
			point = link
		end
	end

	return http.request(method, point, ...)
end

-- Função de redirecionamento para métodos GET
function httpGet(apiName, param, ...)
	return httpHandle("GET", apiName, param, ...)
end

-- Função de redirecionamento para métodos POST
function httpPost(apiName, param, ...)
	return httpHandle("POST", apiName, param, ...)
end

-- Confirma que houve a execução sem erros
return true

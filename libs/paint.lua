local methods = {}
local metatable = {}
local pool = {}

function methods:getList()
	return pool
end

function metatable:__index(...)
  return rawget(methods, ...)
  or rawget(pool, ...)
end

function metatable:__newindex(...)
  return rawset(pool, ...)
end

paint = setmetatable(methods, metatable)

paint.red = {255, 0, 0}
paint.green = {0, 255, 0}
paint.blue = {0, 0, 255}
paint.white = {255, 255, 255}
paint.black = {0, 0, 0}
paint.grey = {128, 128, 128}
paint.yellow = {255, 255, 0}

paint.ok = {76, 175, 80}
paint.warn = {255, 202, 40}
paint.error = {244, 67, 54}
paint.no = {216, 67, 21}
paint.info = {33, 150, 243}

paint.robloxRed = {220, 0, 0}

return paint

local main = {}
main.__index = main

main.map = {
	red = {244, 67, 54},
	red2 = {216, 67, 21},
	red3 = {220, 0, 0},
	green = {76, 175, 80},
	yellow = {255, 202, 40},
	blue = {33, 150, 243},
	grey = {249, 239, 239},
	black = {0, 0, 0},
}

function main:__call(text)
	local color = self.map[text]

	if color then
		return unpack(color)
	end
end

paint = setmetatable({}, main)

return paint

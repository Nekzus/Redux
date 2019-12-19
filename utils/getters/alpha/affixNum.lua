function affixNum(num)
	if type(num) == "string" then
		num = tonumber(num) or 0
	elseif type(num) == "number" then
		num = num
	else
		return 0
	end

	local isNeg = false

	if num > -1000 and num < 1000 then
		return num
	end

	if num < 0 then
		isNeg = true
		num = num * -1
	end

	num = num - num % 10

	local affix = math.abs(num)
	affix = math.log(affix)
	affix = math.floor(affix / math.log(1000))
	affix = math.min(affix, #config.numAffixes)

	if isNeg then
		num = num * -1
	end

	local power = num / 1000 ^ affix
	local key = config.numAffixes[affix].key

	return string.format("%02.2f%s", power, key)
end

return affixNum

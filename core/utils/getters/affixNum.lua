function affixNum(num)
	if type(num) == "string" then
		num = tonumber(num) or 0
	elseif type(num) == "number" then
		num = num
	else
		return 0
	end

	local isNeg = false

	if num < 1000 and num > - 1000 then
		return num
	end

	if num < 0 then
		isNeg = true
		num = num * - 1
	end

	num = num - num % 10

	local affix = min(floor(log(abs(num)) / log(1000)), #config.numAffixes)

	if isNeg then
		num = num * - 1
	end

	return format("%02.2f%s", (num / 1000 ^ affix), config.numAffixes[affix].key)
end

return affixNum

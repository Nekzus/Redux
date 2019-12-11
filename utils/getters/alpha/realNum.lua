function realNum(text)
	if type(text) == "string" then
		text = text
	elseif type(text) == "number" then
		return text
	else
		return false
	end

	local num = text:match("[0-9]+[%p][0-9]+") or text:match("[0-9]+")
	local affix = text:match("%a+")
	local signal = text:match("[%+|%-]")
	local nAffix

	if signal then
		num = append(signal, num)
	end

	if num then
		num = tonumber(num)
	else
		return false
	end

	if not affix then
		return num
	end

	for affixKey, affixData in next, config.numAffixes do
		if affix:lower() == affixData.key:lower() then
			nAffix = affixKey
			break
		end
	end

	if not nAffix then
		return false
	end

	return num * (1000 ^ nAffix)
end

return realNum

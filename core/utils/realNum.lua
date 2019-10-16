function realNum(text)
	if type(text) == "string" then
		text = text
	elseif type(text) == "num" then
		return text
	else
		return false
	end

	local num = text:match("[0-9]+[%p][0-9]+") or text:match("[0-9]+")
	local affix = text:match("%a+")
	local signal = text:match("[%+|%-]")
	local numAffix

	if signal then
		num = format("%s%s", signal, num)
	end

	if num then
		num = tonumber(num)
	else
		return false
	end

	if not affix then
		return num
	end

	for affixKey, affixData in pairs(config.numAffixes) do
		if affix:lower() == affixData.key:lower() then
			numAffix = affixKey
			break
		end
	end

	if not numAffix then
		return false
	end

	return num * (1000 ^ numAffix)
end

return realNum

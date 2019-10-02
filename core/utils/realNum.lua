function realNum(text)
	if type(text) == "string" then
		text = text
	elseif type(text) == "number" then
		return text
	else
		return false
	end

	local affix = text:match("%a+")
	local num = text:match("[0-9]+[%p][0-9]+") or text:match("[0-9]+")
	local sig = text:match("[%+|%-]")
	local nAffix

	if sig then
		num = format("%s%s", sig, num)
	end

	if num then
		num = tonumber(num)
	else
		return false
	end

	if not affix then
		return num
	end

	for k, v in pairs(config.numAffixes) do
		if affix:lower() == v.key:lower() then
			nAffix = k
			break
		end
	end

	if not nAffix then
		return false
	end

	return num * (1000 ^ nAffix)
end

return realNum

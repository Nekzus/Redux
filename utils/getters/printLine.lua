function printLine(...)
	local result = {}

	for i = 1, select('#', ...) do
		insert(result, tostring(select(i, ...)))
	end

	return concat(result, '\t')
end

return printLine

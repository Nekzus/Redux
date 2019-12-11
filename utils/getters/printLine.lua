function printLine(...)
	local result = {}

	for i = 1, select('#', ...) do
		table.insert(result, tostring(select(i, ...)))
	end

	return table.concat(result, '\t')
end

return printLine

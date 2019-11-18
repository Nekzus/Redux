function runDOS(cmd, raw)
  local func = assert(io.popen(cmd, 'r'))
  local result = assert(func:read('*a'))

  func:close()

  if raw then
	  return result
  end

  result = gsub(result, '^%s+', '')
  result = gsub(result, '%s+$', '')
  result = gsub(result, '[\n\r]+', ' ')

  return result
end

return runDOS

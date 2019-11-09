function isPatron(id)
	return saves.track:get("patrons"):raw()[id] ~= nil
end

return isPatron

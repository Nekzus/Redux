function isPatron(id)
	local track = getTrackData()

	return track:get("patrons"):raw()[id] ~= nil
end

return isPatron

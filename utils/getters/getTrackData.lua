function getTrackData(duration)
	trackData = trackData or db("./saves/bot/track.bin", duration)

	return trackData
end

return getTrackData

function getTempData(duration)
	tempData = tempData or db("./saves/bot/temp.bin", duration)
	
	return tempData
end

return getTempData

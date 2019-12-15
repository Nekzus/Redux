function timeLong(seconds)
	seconds = seconds and tonumber(seconds) or 0

	local result = ""
	local days = math.floor(seconds / timeUnit.day)
	local hours = math.floor(math.fmod(seconds, timeUnit.day) / timeUnit.hour)
	local minutes = math.floor(math.fmod(seconds, timeUnit.hour) / timeUnit.minute)
	local seconds = math.floor(math.fmod(seconds, timeUnit.minute))

	if days > 0 then
		result = string.format("%s%s %s", result, tostring(days), days == 1 and "$<day>, " or "$<days>, ")
	end

	if hours > 0 then
		result = string.format("%s%s %s", result, tostring(hours), hours == 1 and "$<hour>, " or "$<hours>, ")
	end

	if minutes > 0 then
		result = string.format("%s%s %s", result, tostring(minutes), minutes == 1 and "$<minute>, " or "$<minutes>, ")
	end

	if seconds > 0 then
		result = string.format("%s%s %s", result, tostring(seconds), seconds == 1 and "$<second>, " or "$<seconds>, ")
	end

	if result == "" then
		return "0 $<seconds>"
	else
		return result:sub(1, - 3)
	end
end

return timeLong
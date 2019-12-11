--[[
client:on("memberUpdate",
	function(member)
		if member.user.bot then
			return
		end
	end
)
]]--

--[[
	Parte responsável por realizar checagens e funções quando um membro tem
	algum de seus atributos modificados (cargo, nome, etc)
]]

client:on("memberUpdate",
	function(member)
		if member.user.bot then
			return
		end
	end
)

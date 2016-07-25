SLASH_H4X1 = '/h4x'

SlashCmdList['H4X'] = function(msg)
	if h4x.slash[msg] then
		h4x.slash[msg]()
	else
		DEFAULT_CHAT_FRAME:AddMessage('h4x slash commands:')

		for k, v in pairs(h4x.slash) do
			DEFAULT_CHAT_FRAME:AddMessage(k)
		end
	end
end


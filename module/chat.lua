local ModifyChat = function()
	FriendsMicroButton.Show = function() end
	FriendsMicroButton:Hide()

	ChatFrameMenuButton.Show = function() end
	ChatFrameMenuButton:Hide()
	
	for i = 1, NUM_CHAT_WINDOWS do
		local f = _G["ChatFrame" .. i]
		f:SetMaxLines(1500)
		f:SetMaxResize(10000, 10000)
		f:SetMinResize(1, 1)

		local bf = _G["ChatFrame" .. i .. "ButtonFrame"]
		bf.Show = function() end
		bf:SetWidth(0.1)
		bf:Hide()
		
		local eb = _G["ChatFrame" .. i .. "EditBox"]
		eb:SetHeight(20)
		eb:ClearAllPoints()
		eb:SetPoint('BOTTOMLEFT', f, 'TOPLEFT', 0, 2 + eb:GetHeight() * -1)
		eb:SetPoint('BOTTOMRIGHT', f, 'TOPRIGHT', 0, 2 + eb:GetHeight() * -1)
		eb:SetAltArrowKeyMode(false)
		eb:EnableMouse(false)
		eb:Hide()

		_G["ChatFrame" .. i .. "EditBoxLeft"]:Hide()
		_G["ChatFrame" .. i .. "EditBoxRight"]:Hide()
		_G["ChatFrame" .. i .. "EditBoxMid"]:Hide()
		_G["ChatFrame" .. i .. "EditBoxFocusLeft"]:SetTexture(nil)
		_G["ChatFrame" .. i .. "EditBoxFocusRight"]:SetTexture(nil)
		_G["ChatFrame" .. i .. "EditBoxFocusMid"]:SetTexture(nil)

		local ebbg = CreateFrame("Frame", nil, eb)
		ebbg:SetFrameLevel(eb:GetFrameLevel() - 1)
		ebbg:SetAllPoints(eb)
		ebbg:SetBackdrop({
			bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
			edgeFile = "",
			insets = { bottom = 0, left = 0, right = 0, top = 0 },
			tileSize = 0
		})
		ebbg:SetBackdropColor(0, 0, 0, 1)
		ebbg:SetBackdropBorderColor(0, 0, 0, 1)

		-- Hide editbox to force background to hide
		hooksecurefunc("ChatEdit_DeactivateChat", function()
			eb:Hide()
		end)
	end
	
	ChatTypeInfo["OFFICER"].sticky = 1
	ChatTypeInfo["WHISPER"].sticky = 1
	ChatTypeInfo["CHANNEL"].sticky = 1

	CHAT_GUILD_GET					= "[G] %s:\32"
	CHAT_RAID_GET					= "[R] %s:\32"
	CHAT_PARTY_GET					= "[P] %s:\32"
	CHAT_RAID_WARNING_GET			= "[W] %s:\32"
	CHAT_RAID_LEADER_GET			= "[L] %s:\32"
	CHAT_OFFICER_GET				= "[O] %s:\32"
	CHAT_BATTLEGROUND_GET			= "[B] %s:\32"
	CHAT_BATTLEGROUND_LEADER_GET	= "[L] %s:\32"
	CHAT_SAY_GET 					= "%s:\32"
	CHAT_YELL_GET 					= "%s:\32"
	CHAT_WHISPER_GET 				= "%s:\32"
	CHAT_WHISPER_INFORM_GET 		= "%s:\32"
	CHAT_FLAG_AFK 					= "[AFK] "
	CHAT_FLAG_DND 					= "[DND] "
	CHAT_FLAG_GM 					= "[GM] "

end

local f = CreateFrame("Frame")
f:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		ModifyChat()

	elseif event == "PLAYER_REGEN_DISABLED" then
		SetCVar("chatBubbles", 1)

	elseif event == "PLAYER_REGEN_ENABLED" then
		SetCVar("chatBubbles", 0)
	end
end)

f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("PLAYER_REGEN_DISABLED")
f:RegisterEvent("PLAYER_REGEN_ENABLED")


-- Set insets before blizzard has a chance to move them
for i = 1, NUM_CHAT_WINDOWS do
	_G["ChatFrame" .. i]:SetClampRectInsets(0, 0, 0, 0)
end

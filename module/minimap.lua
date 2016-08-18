local AUCTION_WON = AUCTION_WON or ERR_AUCTION_WON_S:gsub('%%s', '%.+')


local Hook = function()
	Minimap:SetScript("OnMouseUp", function(self, button, ...)
		if button == "RightButton" then
			ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, self, 0, -5)

		elseif button == "MiddleButton" then
			ToggleCalendar()

		else
			Minimap_OnClick(self, button, ...)
		end
	end)
end

local ModifyMinimap = function()
	local f = {
		MinimapZoomIn, MinimapZoomOut, MinimapBorderTop,
		MinimapToggleButton, MiniMapWorldMapButton, MiniMapVoiceChatFrame,
		MinimapNorthTag, MinimapZoneText, MinimapBorder, GameTimeFrame,
		MiniMapTracking, MiniMapInstanceDifficulty, MiniMapMailFrame
	}

	for _, f in pairs(f) do
		f:Hide()
		f.Show = function() end
	end

	-- :Hide()'ing this makes the keybinding not work
	GarrisonLandingPageMinimapButton:SetAlpha(0)

	f = Minimap

	f:SetZoom(0)
	f:SetMaskTexture(h4x.minimapmask)
	f:ClearAllPoints()
	f:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -13, -13)
	f:SetScale(.9)

	f.bg = MinimapBackdrop
	f.bg:SetBackdrop({
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		tile = false,
		tileSize = 0,
		edgeSize = 4
	})
	f.bg:SetFrameStrata("BACKGROUND")
	f.bg:SetPoint("CENTER", f, "CENTER")
	f.bg:SetParent(f)
	f.bg:SetWidth(f:GetWidth() + 4)
	f.bg:SetHeight(f:GetHeight() + 4)
	f.bg:SetBackdropBorderColor(0, 0, 0, 1)

	f.mail = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	f.mail:SetFont(h4x.font, 12)
	f.mail:SetPoint("BOTTOM", f.bg, "BOTTOM", 0, -12)
	f.mail:SetTextColor(.9, .9, .9)
	f.mail:Hide()

	TimeManagerClockTicker:ClearAllPoints()
	TimeManagerClockTicker:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -3, 3)
	TimeManagerClockTicker:SetFont(h4x.font, 11)
	TimeManagerClockTicker:SetTextColor(.9, .9, .9)
	TimeManagerClockTicker:SetJustifyH("RIGHT")

	TimeManagerClockButton:ClearAllPoints()
	TimeManagerClockButton:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -3, 3)
	TimeManagerClockButton:SetWidth(TimeManagerClockButton:GetWidth())
	TimeManagerClockButton:SetHeight(TimeManagerClockButton:GetHeight())
	select(1, TimeManagerClockButton:GetRegions()):Hide()

	QueueStatusMinimapButton:ClearAllPoints()
	QueueStatusMinimapButton:SetParent(f)
	QueueStatusMinimapButton:SetPoint("TOPLEFT", f, "BOTTOMLEFT", -8, 3)
	QueueStatusMinimapButton:SetScale(1.2)
	QueueStatusMinimapButtonBorder:SetTexture(nil)
end


local f = CreateFrame("Frame")
f:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		Hook()
		ModifyMinimap()

		self:RegisterEvent("CALENDAR_UPDATE_PENDING_INVITES")
		self:RegisterEvent("UPDATE_PENDING_MAIL")
		self:RegisterEvent("MINIMAP_PING")
		self:RegisterEvent("MAIL_SHOW")
		self:RegisterEvent("MAIL_CLOSED")
		self:RegisterEvent("CHAT_MSG_SYSTEM")

		self.lastping = {}
		self.mail_auction_spam = false
		self.mail_open = false
		self.mail_closed = 0

		self:UnregisterEvent("PLAYER_ENTERING_WORLD")

	elseif event == "MINIMAP_PING"  then
		local arg1, now = ..., time()
		self.lastping[arg1] = self.lastping[arg1] or now - 2

		if now - self.lastping[arg1] >= 2 then
			DEFAULT_CHAT_FRAME:AddMessage(UnitName(arg1) .." pinged the minimap") 
			self.lastping[arg1] = now
		end

	elseif event == "MAIL_SHOW" then
		self.mail_open = true

	elseif event == "MAIL_CLOSED" then
		self.mail_closed = time()
		self.mail_open = false

	elseif event == "CHAT_MSG_SYSTEM" then
		local message = ...

		if message == ERR_AUCTION_REMOVED or strmatch(message, AUCTION_WON) then
			self.mail_auction_spam = true
		end

 	-- UPDATE_PENDING_MAIL, CALENDAR_UPDATE_PENDING_INVITES
	else
		local f = Minimap
		local mail = HasNewMail()
		local invite = CalendarGetNumPendingInvites()
		local mailsound = true

		-- UPDATE_PENDING_MAIL triggers
		--  - When the mailbox is closed (MAIL_CLOSED) and the number of items have changed
		--	- When the user is managing the inbox
		--  - When winning/removing an auction
		if self.mail_closed + 1 > time() or self.mail_open or self.mail_auction_spam then
			mailsound = false
		end

		if invite > 0 and mail then
			if mailsound then
				PlaySoundFile(h4x.mailsound)
			end
			f.mail:SetText("Mail & Invite")
			f.mail:Show()

		elseif invite > 0 and not mail then
			f.mail:SetText("Invite")
			f.mail:Show()

		elseif invite == 0 and mail then
			if mailsound then
				PlaySoundFile(h4x.mailsound)
			end
			f.mail:SetText("Mail")
			f.mail:Show()

		else
			f.mail:Hide()
		end
	end
end)

f:RegisterEvent("PLAYER_ENTERING_WORLD")
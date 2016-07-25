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

		self.lastping = {}

	elseif event == "MINIMAP_PING"  then
		local arg1, now = ..., time()
		self.lastping[arg1] = self.lastping[arg1] or now - 2

		if now - self.lastping[arg1] >= 2 then
			DEFAULT_CHAT_FRAME:AddMessage(UnitName(arg1) .." pinged the minimap") 
			self.lastping[arg1] = now
		end

 	-- UPDATE_PENDING_MAIL, CALENDAR_UPDATE_PENDING_INVITES
	else
		local f = Minimap
		local mail = HasNewMail()
		local invite = CalendarGetNumPendingInvites()

		if invite > 0 and mail then
			PlaySoundFile(h4x.mailsound)
			f.mail:SetText("Mail & Invite")
			f.mail:Show()

		elseif invite > 0 and not mail then
			f.mail:SetText("Invite")
			f.mail:Show()

		elseif invite == 0 and mail then
			PlaySoundFile(h4x.mailsound)
			f.mail:SetText("Mail")
			f.mail:Show()

		else
			f.mail:Hide()
		end
	end
end)

f:RegisterEvent("PLAYER_ENTERING_WORLD")
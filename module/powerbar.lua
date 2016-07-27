class = select(2, UnitClass("player"))
if class ~= "HUNTER" and class ~= "DRUID" and class ~= "WARRIOR" then
	return
end


h4x.slash["powerbar lock"] = function()
	_G["h4x_powerbar"]:EnableMouse(false)
end

h4x.slash["powerbar unlock"] = function()
	_G["h4x_powerbar"]:EnableMouse(true)
end


local UnitHealthPercent = function(unit)
	return string.format("%d%%", (UnitHealth(unit) / UnitHealthMax(unit)) * 100)
end


local GetPowerColor = function()
	power = select(2, UnitPowerType("player"))
	return PowerBarColor[power].r, PowerBarColor[power].g, PowerBarColor[power].b
end


local Update = function(self, event, ...)
	if event == "UNIT_POWER_FREQUENT" then
		if UnitIsUnit(..., "player") then
			local power = UnitPower("player")
			self:SetValue(power)
			self.power:SetText(power)
		end

	elseif event == "UNIT_MAXPOWER" then
		if UnitIsUnit(..., "player") then
			self:SetMinMaxValues(0, UnitPowerMax("player"))
		end

	elseif event == "UNIT_HEALTH_FREQUENT" then
		if UnitIsUnit(..., "target") then
			self.target:SetText(UnitHealthPercent("target"))
			self.target:Show()
		end
		
	elseif event == "PLAYER_TARGET_CHANGED" then
			if not UnitExists("target") then
				self.target:Hide()
				return
			end

			self.target:SetText(UnitHealthPercent("target"))
			self.target:Show()

	elseif event == "PLAYER_REGEN_ENABLED" then
		self.target:Hide()

	elseif event == "UNIT_DISPLAYPOWER" then
		if UnitIsUnit(..., "player") then
			self:SetMinMaxValues(0, UnitPowerMax("player"))
			self:SetStatusBarColor(GetPowerColor())

			local power = UnitPower("player")
			self:SetValue(power)
			self.power:SetText(power)

			if select(2, UnitPowerType("player")) ~= "ENERGY" then
				self.cp:Hide()
			else
				self.cp:Show()
			end
		end

	elseif event == "UNIT_COMBO_POINTS" then
		if UnitIsUnit(..., "player") then
			cp = GetComboPoints("player", "target");

			self.cp:SetText(cp)
			self.cp:Show()
		end
	end
end


local CreateBar = function(self, event, ...)
	h4xDB.powerbar = h4xDB.powerbar or {}
	local db = h4xDB.powerbar

	local f = CreateFrame("Frame", "h4x_powerbar", UIParent)
	f:SetMovable(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", function(f)
		f:StopMovingOrSizing()
		db.x, db.y = f:GetLeft(), f:GetBottom()
	end)

	if db.x then
		f:SetPoint("BOTTOMLEFT", UIParent, db.x, db.y)
	else
		f:SetPoint("CENTER", UIParent)
	end

	f:SetSize(200, 20)

	f.backdrop = f:CreateTexture(nil, "BACKGROUND", f)
	f.backdrop:SetPoint("TOPLEFT", -1, 1)
	f.backdrop:SetPoint("BOTTOMRIGHT", 1, -1)
	f.backdrop:SetColorTexture(0, 0, 0, .5)

	f.bar = CreateFrame("StatusBar", nil, f)
	f.bar:SetPoint("CENTER", f)
	f.bar:SetStatusBarTexture(h4x.statusbar)
	f.bar:GetStatusBarTexture():SetHorizTile(false)
	f.bar:GetStatusBarTexture():SetVertTile(false)
	f.bar:SetMinMaxValues(0, UnitPowerMax("player"))
	f.bar:SetSize(f:GetSize())
	f.bar:SetStatusBarColor(GetPowerColor())

	f.bar.power = f.bar:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	f.bar.power:SetFont(h4x.font, 14)
	f.bar.power:SetTextColor(1, 1, 1)
	f.bar.power:SetPoint("RIGHT", f.bar, "RIGHT", -4, 0)

	f.bar.target = f.bar:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	f.bar.target:SetFont(h4x.font, 14)
	f.bar.target:SetTextColor(1, 1, 1)
	f.bar.target:SetPoint("LEFT", f.bar, "LEFT", 4, 0)

	f.bar.cp = f.bar:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	f.bar.cp:SetFont(h4x.font, 14)
	f.bar.cp:SetTextColor(1, 1, 1)
	f.bar.cp:SetPoint("CENTER", f.bar, "CENTER", 4, 0)
	f.bar.cp:SetText("0")

	f.bar:RegisterEvent("UNIT_POWER_FREQUENT")
	f.bar:RegisterEvent("UNIT_HEALTH_FREQUENT")
	f.bar:RegisterEvent("PLAYER_TARGET_CHANGED")
	f.bar:RegisterEvent("PLAYER_REGEN_ENABLED")
	f.bar:RegisterEvent("UNIT_DISPLAYPOWER")
	f.bar:RegisterEvent("UNIT_COMBO_POINTS")
	f.bar:RegisterEvent("UNIT_MAXPOWER")

	f.bar:SetScript("OnEvent", Update)

	f.bar:Show()
	f:Show()

	Update(f.bar, "UNIT_POWER_FREQUENT", "player")
	Update(f.bar, "UNIT_MAXPOWER", "player")
	Update(f.bar, "UNIT_DISPLAYPOWER", "player")
end


local f = CreateFrame("Frame")
f:SetScript("OnEvent", CreateBar)

f:RegisterEvent("PLAYER_ENTERING_WORLD")


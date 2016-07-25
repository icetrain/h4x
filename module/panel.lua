local GetXP = function()
	if UnitLevel("player") == MAX_PLAYER_LEVEL then
		return ""
	else
		return string.format("%d/%d %s",
			UnitXP("player"),
			UnitXPMax("player"),
			GetXPExhaustion() and "(+" .. GetXPExhaustion() .. ")" or ""
		)
	end
end

local GetAddonMemory = function()
	local mem = 0
	
	UpdateAddOnMemoryUsage()

	for i = 1, GetNumAddOns() do
		mem = mem + GetAddOnMemoryUsage(i)
	end
		
	return mem
end
	
local Update = function(self, elapsed)
	self.last = (self.last or 0) + elapsed

	if self.last < 1 then
		return
	end

	local gccur = collectgarbage('count')
	
	self.font:SetText(
		string.format("%2dfps  %3dms  %.1fmb (%.1fmb, %dkb/s)  %s",
			GetFramerate(),
			select(3, GetNetStats()),
			gccur / 1024,
			GetAddonMemory() / 1024,
			gccur - (self.gclast or gccur),
			GetXP()
		)
	)

	self.gclast = gccur
	self.last = 0
end

local CreatePanel = function(self, event, ...)
	local f = CreateFrame("Frame", nil, UIParent)
	f:SetHeight(15)
	f:SetWidth(350)
	f:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, 0)

	f.font = f:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	f.font:SetFont(h4x.font, 12)
	f.font:SetTextColor(.9, .9, .9)
	f.font:SetPoint("TOPLEFT", f, "TOPLEFT", 0, 0)

	f:SetScript("OnUpdate", Update)
	f:Show()
end

	
local f = CreateFrame("Frame")
f:SetScript("OnEvent", CreatePanel)

f:RegisterEvent("PLAYER_ENTERING_WORLD")
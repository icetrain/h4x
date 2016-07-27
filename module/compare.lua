local Hook = function()
	ItemRefTooltip:HookScript("OnTooltipSetItem", function(self, ...)
		GameTooltip_ShowCompareItem(self)
		self.comparing = true
	end)
end

local TameItemRefTooltip = function()
	ItemRefTooltip:SetScript("OnEnter", nil)
	ItemRefTooltip:SetScript("OnLeave", nil)
end


local f = CreateFrame("Frame")
f:SetScript("OnEvent", function(self, event, ...)
	Hook()
	TameItemRefTooltip()
end)

f:RegisterEvent("PLAYER_ENTERING_WORLD")

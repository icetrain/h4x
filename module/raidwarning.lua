local Hook = function()
	local _RaidWarningFrame_OnEvent = RaidWarningFrame_OnEvent

	RaidWarningFrame_OnEvent = function(event, message, ...)
		_RaidWarningFrame_OnEvent(event, arg2 .. ": " .. message, ...)
	end
end


local ModifyRaidWarning = function()
	RAID_NOTICE_DEFAULT_HOLD_TIME = 1.0;
	RAID_NOTICE_FADE_OUT_TIME = 1.0;
end


local f = CreateFrame("Frame")
f:SetScript("OnEvent", function(self, event, ...)
	Hook()
	ModifyRaidWarning()

	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end)

f:RegisterEvent("PLAYER_ENTERING_WORLD")
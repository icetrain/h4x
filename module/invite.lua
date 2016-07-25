local ShouldAutoAccept = function(name)
	-- Friends list
	for i = 1, GetNumFriends() do
		if GetFriendInfo(i) == name then
			return true
		end
	end
	
	-- Battle net friend
	if BNFeaturesEnabledAndConnected() then
		for i = 1, BNGetNumFriends() do
			--local presenceID, givenName, surname, toonName, toonID, client, isOnline, lastOnline, isAFK, isDND, messageText, noteText, isFriend, unknown = BNGetFriendInfo(i)
			local unknown, toonName, client, realmName, faction, race, class, unknown, zoneName, level, gameText, broadcastText, broadcastTime = BNGetToonInfo(select(1, BNGetFriendInfo(i)))
		
			if client == "WoW" and toonName == name then
				return true
			end
		end
	end
	
	-- Guild member
	for i = 1, GetNumGuildMembers() do
		if select(1, GetGuildRosterInfo(i)) == name then
			return true
		end
	end
	
	return false
end



local f = CreateFrame("Frame")
f:SetScript("OnEvent", function(self, event, ...)
	if event == "PARTY_INVITE_REQUEST" then
		local name = ...
	
		if ShouldAutoAccept(name) then
			AcceptGroup()			
			self:RegisterEvent("PARTY_MEMBERS_CHANGED")
		end
	
	-- Hide popup
	elseif event == "PARTY_MEMBERS_CHANGED" then
		local f = StaticPopup_FindVisible("PARTY_INVITE", ...)
		if f then 
			f:Hide()
			self:UnregisterEvent("PARTY_MEMBERS_CHANGED")
		end
	end
end)

f:RegisterEvent("PARTY_INVITE_REQUEST")


f = CreateFrame("Frame", nil, WorldMapFrame.BorderFrame)
f:SetHeight(15)
f:SetWidth(100)
f:SetPoint("BOTTOMLEFT", WorldMapFrame.BorderFrame, "BOTTOMLEFT", 7, 5)

f.player = f:CreateFontString(nil, "ARTWORK", "GameFontNormal")
f.player:SetFont(h4x.font, 12)
f.player:ClearAllPoints()
f.player:SetPoint("LEFT", f, "LEFT", 0, 0)

f.cursor = f:CreateFontString(nil, "ARTWORK", "GameFontNormal")
f.cursor:SetFont(h4x.font, 12)
f.cursor:ClearAllPoints()
f.cursor:SetPoint("LEFT", f.player, "RIGHT", 10, 0)

f:Show()

f:SetScript("OnUpdate", function(self)
	local width = WorldMapDetailFrame:GetWidth()
	local height = WorldMapDetailFrame:GetHeight()
	local left = WorldMapDetailFrame:GetLeft()
	local top = WorldMapDetailFrame:GetTop()
	local scale = WorldMapDetailFrame:GetEffectiveScale()

	local x, y = GetCursorPosition()
	local px, py = GetPlayerMapPosition("player")

	local cx = (x / scale - left) / width
	local cy = (top - y / scale) / height

    -- Player position not avalable in raid
	if (px and py) then
		self.player:SetText(string.format("Player: %2d.%2d", px * 100, py * 100))
	end

	if cx < 0 or cx > 1 or cy < 0 or cy > 1 then
		self.cursor:Hide()
	else
		self.cursor:SetText(string.format("Cursor: %2d.%2d", cx * 100, cy * 100))
		self.cursor:Show()
	end
end)

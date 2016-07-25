local Hook = function()
	local _BuffFrame_UpdateDuration = BuffFrame_UpdateDuration

	BuffFrame_UpdateDuration = function(button, ...)
		_BuffFrame_UpdateDuration(button, ...)

		_G[button:GetName() .. "Duration"]:SetTextColor(.9, .9, .9)
	end
end

local ModifyBuffs = function()
	TemporaryEnchantFrame:ClearAllPoints()
	TemporaryEnchantFrame:SetPoint("TOPRIGHT", Minimap, "TOPLEFT", -10, 2)
	
	BuffFrame:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -160, -10)
end


local UpdateButton = function(button)
	local f = _G[button]

	if not f.bg then
		local i = _G[button .. "Icon"]
		local b = _G[button .. "Border"]
		local d = _G[button .. "Duration"]

		f.bg = CreateFrame("Frame", nil, f)
		f.bg:ClearAllPoints()
		f.bg:SetFrameLevel(f:GetFrameLevel() - 1)
		f.bg:SetFrameStrata(f:GetFrameStrata())
  		f.bg:SetBackdrop({
  			bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
  			tile = true,
  			tileSize = 1,
  			edgeFile = "",
  			edgeSize = 0,
  			insets = { left = 0, right = 0, top = 0, bottom = 0 }
  		})

		f.bg:SetBackdropColor(0, 0, 0, 1)
		f.bg:SetAllPoints(f)
		f.bg:Show()

		i:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		i:ClearAllPoints()
		i:SetPoint("TOPLEFT", f.bg, "TOPLEFT", 2, -2)
		i:SetPoint("BOTTOMRIGHT", f.bg, "BOTTOMRIGHT", -2, 2)

		d:SetFont(h4x.font, 10)

		if b then
			b:Hide()
		end
	end
end


local UpdateAuras = function()
	local f, i
	local frame = { "BuffButton", "DebuffButton", "TempEnchant" }

	for _, f in pairs(frame) do
		i = 1

		while _G[f .. i] do
			UpdateButton(f .. i)
			i = i + 1
		end
	end
end


local f = CreateFrame("Frame")
f:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		Hook()
		ModifyBuffs()
		UpdateAuras()
		
		self:RegisterEvent("UNIT_AURA")
		
	else
		local unit = ...
		if unit == "player" then
			UpdateAuras()
		end
	end
end)

f:RegisterEvent("PLAYER_ENTERING_WORLD")

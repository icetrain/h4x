local ClassColor = function(unit)
	local _, class = UnitClass(unit)

	if class then
		return RAID_CLASS_COLORS[class].r, RAID_CLASS_COLORS[class].g, RAID_CLASS_COLORS[class].b
	else
		return 1, 1, 1
	end
end

local UpdateTarget = function(tooltip)
	local _, unit = tooltip:GetUnit()

	if unit and UnitExists(unit) then
		local target = UnitName(unit .. "target")

		GameTooltipTextLeft1:SetText(UnitName(unit))
		GameTooltipTextLeft1:SetTextColor(ClassColor(unit))

		if target and target ~= UNKNOWNOBJECT then
			if UnitIsUnit(unit .. "target", "player") then
				target = "<< YOU >>"
			end

			GameTooltipTextRight1:SetText(target)
			GameTooltipTextRight1:SetTextColor(ClassColor(unit .."target"))
			GameTooltipTextRight1:Show()
		end
	end
end

local UpdateFont = function(tooltip)
	local SetFont = function(text)
		local _, size, flags = text:GetFont()
		text:SetFont(h4x.font, size, flags)
	end

	local i = 1
	while _G["GameTooltipTextLeft" .. i] do
		SetFont(_G["GameTooltipTextLeft" .. i])
		SetFont(_G["GameTooltipTextRight" .. i])

		i = i + 1
	end
end

local Hook = function()
	local _UnitFrame_UpdateTooltip = UnitFrame_UpdateTooltip

	UnitFrame_UpdateTooltip = function(this)
		_UnitFrame_UpdateTooltip(this)
		GameTooltipTextLeft1:SetTextColor(ClassColor(this.unit))
	end

	GameTooltip:HookScript("OnTooltipSetUnit", function(...)
		UpdateTarget(...)
	end)

	GameTooltip:HookScript("OnShow", function(self, ...)
		UpdateFont(...)
		self:SetAnchorType("ANCHOR_CURSOR")
	end)
	
end

local ModifyTooltip = function()
	local f = {
		GameTooltip, ShoppingTooltip1, ShoppingTooltip2, ShoppingTooltip3,
		ItemRefTooltip, ItemRefShoppingTooltip1, ItemRefShoppingTooltip2,
		ItemRefShoppingTooltip3, WorldMapTooltip, WorldMapCompareTooltip1,
		WorldMapCompareTooltip2, WorldMapCompareTooltip3
	 }

	for _, f in pairs(f) do
		f:SetBackdrop({
			bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
			edgeFile = "",
			insets = { bottom = 3, left = 3, right = 3, top = 3 },
			tileSize = 0
		})

		f:SetBackdropBorderColor(0, 0, 0, .8)
		f:SetBackdropColor(0, 0, 0, 1)
	end

	GameTooltipStatusBar:SetStatusBarTexture(h4x.statusbar)
	GameTooltipStatusBar:SetHeight(5)
end


local f = CreateFrame("Frame")
f:SetScript("OnEvent", function(self, event, ...)
	Hook()
	ModifyTooltip()
end)

f:RegisterEvent("PLAYER_ENTERING_WORLD")

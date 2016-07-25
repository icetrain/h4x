local Repair = function()
	local cost, repair = GetRepairAllCost()

	if repair and cost > 0 then
		RepairAllItems()
	end
end

local Sell = function()
	for bag = 0, 4 do
		for slot = 0, GetContainerNumSlots(bag) do
			local link = GetContainerItemLink(bag, slot)
			if link and select(3, GetItemInfo(link)) == 0 then
				ShowMerchantSellCursor(1)
				UseContainerItem(bag, slot)
			end
		end
	end
end


local f = CreateFrame("Frame")
f:SetScript("OnEvent", function()
	Sell()
	Repair()
end)

f:RegisterEvent("MERCHANT_SHOW")
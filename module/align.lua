h4x.slash.align = function()

	if _G['h4x_align'] then
		_G['h4x_align']:Hide()
		_G['h4x_align'] = nil
		return
	end

	f = CreateFrame('Frame', 'h4x_align', UIParent) 
	f:SetAllPoints(UIParent)
		
	local w = GetScreenWidth() / 64
	local h = GetScreenHeight() / 36
		
	for i = 0, 64 do
		local t = f:CreateTexture(nil, 'BACKGROUND')
		
		if i == 32 then
			t:SetColorTexture(1, 0, 0, 0.5)
		else
			t:SetColorTexture(0, 0, 0, 0.5)
		end
			
		t:SetPoint('TOPLEFT', f, 'TOPLEFT', i * w - 1, 0)
		t:SetPoint('BOTTOMRIGHT', f, 'BOTTOMLEFT', i * w + 1, 0)
	end
		
	for i = 0, 36 do
		local t = f:CreateTexture(nil, 'BACKGROUND')
		
		if i == 18 then
			t:SetColorTexture(1, 0, 0, 0.5)
		else
			t:SetColorTexture(0, 0, 0, 0.5)
		end
			
		t:SetPoint('TOPLEFT', f, 'TOPLEFT', 0, -i * h + 1)
		t:SetPoint('BOTTOMRIGHT', f, 'TOPRIGHT', 0, -i * h - 1)
	end

end
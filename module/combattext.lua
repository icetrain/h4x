local Update = function()
	local height = GetScreenHeight()

	COMBAT_TEXT_SCROLL_FUNCTION = CombatText_StandardScroll
	COMBAT_TEXT_LOCATIONS.startY = height * 0.78
	COMBAT_TEXT_LOCATIONS.endY = height * 0.78 + 150

	CombatText:SetScale(.75)

	CombatText_ClearAnimationList()
end

local Hook = function()
	local _CombatText_UpdateDisplayedMessages = CombatText_UpdateDisplayedMessages
	local _CombatText_AddMessage = CombatText_AddMessage

	CombatText_UpdateDisplayedMessages = function()
		_CombatText_UpdateDisplayedMessages()
		Update()
	end

	CombatText_AddMessage = function(message, scrollFunction, r, g, b, displayType, isStaggered)
		message = string.gsub(message, "<", "(")
		message = string.gsub(message, ">", ")")

		if displayType == "crit" then
			displayType = ""
			message = "* " .. message .. " *"

		elseif message == MANA_LOW or message == HEALTH_LOW then
			displayType = "sticky"
		end

		_CombatText_AddMessage(message, scrollFunction, r, g, b, displayType, isStaggered)
	end
end

local ModifyCombatText = function()
	for i = 1, 20 do
		_G["CombatText" .. i]:SetFont(h4x.font, 25, "OUTLINE")
	end


	-- Globalstrings
	ENTERING_COMBAT = "+Combat"
	LEAVING_COMBAT = "-Combat"
	AURA_END = "-(%s)"


	-- Strings local to Blizzard_CombatText
	COMBAT_TEXT_STAGGER_RANGE = 400
	COMBAT_TEXT_X_ADJUSTMENT = 0

	COMBAT_TEXT_TYPE_INFO["DAMAGE"]	= 					{r = 1, g = 0, b = 0, isStaggered = 1, show = 1}
	COMBAT_TEXT_TYPE_INFO["SPELL_DAMAGE"] = 			{r = 1, g = 0, b = 0, isStaggered = 1, show = 1}
	COMBAT_TEXT_TYPE_INFO["DAMAGE_SHIELD"] = 			{r = 1, g = 0, b = 0, isStaggered = 1, show = 1}

	COMBAT_TEXT_TYPE_INFO["HEAL"] = 					{r = 0, g = 1, b = 0, isStaggered = 1, show = 1}
	COMBAT_TEXT_TYPE_INFO["PERIODIC_HEAL"] = 			{r = 0, g = 1, b = 0, isStaggered = 1, show = 1}

	COMBAT_TEXT_TYPE_INFO["ENTERING_COMBAT"] = 			{r = 1, g = 1, b = 1, show = 1}
	COMBAT_TEXT_TYPE_INFO["LEAVING_COMBAT"] = 			{r = 1, g = 1, b = 1, show = 1}

	COMBAT_TEXT_TYPE_INFO["SPELL_AURA_START"] = 		{r = 178/255, g = 178/255, b = 0, show = 1}
	COMBAT_TEXT_TYPE_INFO["SPELL_AURA_END"] = 			{r = 229/255, g = 229/255, b = 0, show = 1}

	COMBAT_TEXT_TYPE_INFO["SPELL_AURA_START_HARMFUL"] = {r = 0, g = 127/255, b = 127/255, show = 1}
	COMBAT_TEXT_TYPE_INFO["SPELL_AURA_END_HARMFUL"] = 	{r = 0, g = 216/255, b = 216/255, show = 1}
	
	COMBAT_TEXT_TYPE_INFO["HEALTH_LOW"] = 				{r = 1, g = 127/255, b = 127/255, show = 1}
	COMBAT_TEXT_TYPE_INFO["MANA_LOW"] = 				{r = 127/255, g = 127/255, b = 1, show = 1}

	CombatText_UpdateDisplayedMessages()
end


local f = CreateFrame("Frame")
f:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_ALIVE" then
		if IsAddOnLoaded("Blizzard_CombatText") then
			Hook()
			ModifyCombatText()
			Update()
		end

		f:UnregisterEvent("PLAYER_ALIVE")

	elseif event == "ADDON_LOADED" then
		local addon = ...
		
		if addon == "Blizzard_CombatText" then
			Hook()
			ModifyCombatText()
			Update()

			f:RegisterEvent("ADDON_LOADED")
		end
	end
end)

f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("PLAYER_ALIVE")



--[[
7.0.3

NUM_COMBAT_TEXT_LINES = 20;
COMBAT_TEXT_SCROLLSPEED = 1.9;
COMBAT_TEXT_FADEOUT_TIME = 1.3;
COMBAT_TEXT_HEIGHT = 25;
COMBAT_TEXT_CRIT_MAXHEIGHT = 60;
COMBAT_TEXT_CRIT_MINHEIGHT = 30;
COMBAT_TEXT_CRIT_SCALE_TIME = 0.05;
COMBAT_TEXT_CRIT_SHRINKTIME = 0.2;
COMBAT_TEXT_TO_ANIMATE = {};
COMBAT_TEXT_STAGGER_RANGE = 20;
COMBAT_TEXT_SPACING = 10;
COMBAT_TEXT_MAX_OFFSET = 130;
COMBAT_TEXT_LOW_HEALTH_THRESHOLD = 0.2;
COMBAT_TEXT_LOW_MANA_THRESHOLD = 0.2;
COMBAT_TEXT_LOCATIONS = {};
COMBAT_TEXT_X_ADJUSTMENT = 80;
COMBAT_TEXT_Y_SCALE = 1;
COMBAT_TEXT_X_SCALE = 1;

COMBAT_TEXT_TYPE_INFO["INTERRUPT"] = {r = 1, g = 1, b = 1};
COMBAT_TEXT_TYPE_INFO["DAMAGE_CRIT"] = {r = 1, g = 0.1, b = 0.1, show = 1};
COMBAT_TEXT_TYPE_INFO["DAMAGE"] = {r = 1, g = 0.1, b = 0.1, isStaggered = 1, show = 1};
COMBAT_TEXT_TYPE_INFO["MISS"] = {r = 1, g = 0.1, b = 0.1, isStaggered = 1, var = "COMBAT_TEXT_SHOW_DODGE_PARRY_MISS"};
COMBAT_TEXT_TYPE_INFO["DODGE"] = {r = 1, g = 0.1, b = 0.1, isStaggered = 1, var = "COMBAT_TEXT_SHOW_DODGE_PARRY_MISS"};
COMBAT_TEXT_TYPE_INFO["PARRY"] = {r = 1, g = 0.1, b = 0.1, isStaggered = 1, var = "COMBAT_TEXT_SHOW_DODGE_PARRY_MISS"};
COMBAT_TEXT_TYPE_INFO["EVADE"] = {r = 1, g = 0.1, b = 0.1, isStaggered = 1, var = "COMBAT_TEXT_SHOW_DODGE_PARRY_MISS"};
COMBAT_TEXT_TYPE_INFO["IMMUNE"] = {r = 1, g = 0.1, b = 0.1, var = "COMBAT_TEXT_SHOW_DODGE_PARRY_MISS"};
COMBAT_TEXT_TYPE_INFO["DEFLECT"] = {r = 1, g = 0.1, b = 0.1, var = "COMBAT_TEXT_SHOW_DODGE_PARRY_MISS"};
COMBAT_TEXT_TYPE_INFO["REFLECT"] = {r = 1, g = 0.1, b = 0.1, var = "COMBAT_TEXT_SHOW_DODGE_PARRY_MISS"};
COMBAT_TEXT_TYPE_INFO["RESIST"] = {r = 1, g = 0.1, b = 0.1, var = "COMBAT_TEXT_SHOW_RESISTANCES"};
COMBAT_TEXT_TYPE_INFO["BLOCK"] = {r = 1, g = 0.1, b = 0.1, var = "COMBAT_TEXT_SHOW_RESISTANCES"};
COMBAT_TEXT_TYPE_INFO["ABSORB"] = {r = 1, g = 0.1, b = 0.1, var = "COMBAT_TEXT_SHOW_RESISTANCES"};
COMBAT_TEXT_TYPE_INFO["SPELL_DAMAGE_CRIT"] = {r = 0.79, g = 0.3, b = 0.85, show = 1};
COMBAT_TEXT_TYPE_INFO["SPELL_DAMAGE"] = {r = 0.79, g = 0.3, b = 0.85, show = 1};
COMBAT_TEXT_TYPE_INFO["SPELL_MISS"] = {r = 1, g = 1, b = 1, var = "COMBAT_TEXT_SHOW_DODGE_PARRY_MISS"};
COMBAT_TEXT_TYPE_INFO["SPELL_DODGE"] = {r = 1, g = 1, b = 1, var = "COMBAT_TEXT_SHOW_DODGE_PARRY_MISS"};
COMBAT_TEXT_TYPE_INFO["SPELL_PARRY"] = {r = 1, g = 1, b = 1, var = "COMBAT_TEXT_SHOW_DODGE_PARRY_MISS"};
COMBAT_TEXT_TYPE_INFO["SPELL_EVADE"] = {r = 1, g = 1, b = 1, var = "COMBAT_TEXT_SHOW_DODGE_PARRY_MISS"};
COMBAT_TEXT_TYPE_INFO["SPELL_IMMUNE"] = {r = 1, g = 1, b = 1, var = "COMBAT_TEXT_SHOW_DODGE_PARRY_MISS"};
COMBAT_TEXT_TYPE_INFO["SPELL_DEFLECT"] = {r = 1, g = 1, b = 1, var = "COMBAT_TEXT_SHOW_DODGE_PARRY_MISS"};
COMBAT_TEXT_TYPE_INFO["SPELL_REFLECT"] = {r = 1, g = 1, b = 1, var = "COMBAT_TEXT_SHOW_DODGE_PARRY_MISS"};
COMBAT_TEXT_TYPE_INFO["SPELL_RESIST"] = {r = 0.79, g = 0.3, b = 0.85, var = "COMBAT_TEXT_SHOW_RESISTANCES"};
COMBAT_TEXT_TYPE_INFO["SPELL_BLOCK"] = {r = 1, g = 1, b = 1, var = "COMBAT_TEXT_SHOW_RESISTANCES"};
COMBAT_TEXT_TYPE_INFO["SPELL_ABSORB"] = {r = 0.79, g = 0.3, b = 0.85, var = "COMBAT_TEXT_SHOW_RESISTANCES"};
COMBAT_TEXT_TYPE_INFO["PERIODIC_HEAL"] = {r = 0.1, g = 1, b = 0.1, show = 1};
COMBAT_TEXT_TYPE_INFO["PERIODIC_HEAL_CRIT"] = {r = 0.1, g = 1, b = 0.1, show = 1};
COMBAT_TEXT_TYPE_INFO["ENERGIZE"] = {r = 0.1, g = 0.1, b = 1, var = "COMBAT_TEXT_SHOW_ENERGIZE"};
COMBAT_TEXT_TYPE_INFO["PERIODIC_ENERGIZE"] = {r = 0.1, g = 0.1, b = 1, var = "COMBAT_TEXT_SHOW_PERIODIC_ENERGIZE"};
COMBAT_TEXT_TYPE_INFO["SPELL_CAST"] = {r = 0.1, g = 1, b = 0.1, show = 1};
COMBAT_TEXT_TYPE_INFO["SPELL_AURA_END"] = {r = 0.1, g = 1, b = 0.1, var = "COMBAT_TEXT_SHOW_AURAS"};
COMBAT_TEXT_TYPE_INFO["SPELL_AURA_END_HARMFUL"] = {r = 1, g = 0.1, b = 0.1, var = "COMBAT_TEXT_SHOW_AURAS"};
COMBAT_TEXT_TYPE_INFO["SPELL_AURA_START"] = {r = 0.1, g = 1, b = 0.1, var = "COMBAT_TEXT_SHOW_AURAS"};
COMBAT_TEXT_TYPE_INFO["SPELL_AURA_START_HARMFUL"] = {r = 1, g = 0.1, b = 0.1, var = "COMBAT_TEXT_SHOW_AURAS"};
COMBAT_TEXT_TYPE_INFO["SPELL_ACTIVE"] = {r = 1, g = 0.82, b = 0, var = "COMBAT_TEXT_SHOW_REACTIVES"};
COMBAT_TEXT_TYPE_INFO["FACTION"] = {r = 0.1, g = 0.1, b = 1, var = "COMBAT_TEXT_SHOW_REPUTATION"};
COMBAT_TEXT_TYPE_INFO["HEAL_CRIT"] = {r = 0.1, g = 1, b = 0.1, show = 1};
COMBAT_TEXT_TYPE_INFO["HEAL"] = {r = 0.1, g = 1, b = 0.1, show = 1};
COMBAT_TEXT_TYPE_INFO["DAMAGE_SHIELD"] = {r = 0.79, g = 0.3, b = 0.85, show = 1};
COMBAT_TEXT_TYPE_INFO["SPELL_DISPELLED"] = {r = 1, g = 1, b = 1};
COMBAT_TEXT_TYPE_INFO["EXTRA_ATTACKS"] = {r = 1, g = 1, b = 1};
COMBAT_TEXT_TYPE_INFO["SPLIT_DAMAGE"] = {r = 1, g = 1, b = 1, show = 1};
COMBAT_TEXT_TYPE_INFO["HONOR_GAINED"] = {r = 0.1, g = 0.1, b = 1, var = "COMBAT_TEXT_SHOW_HONOR_GAINED"};
COMBAT_TEXT_TYPE_INFO["HEALTH_LOW"] = {r = 1, g = 0.1, b = 0.1, var = "COMBAT_TEXT_SHOW_LOW_HEALTH_MANA"};
COMBAT_TEXT_TYPE_INFO["MANA_LOW"] = {r = 1, g = 0.1, b = 0.1, var = "COMBAT_TEXT_SHOW_LOW_HEALTH_MANA"};
COMBAT_TEXT_TYPE_INFO["ENTERING_COMBAT"] = {r = 1, g = 0.1, b = 0.1, var = "COMBAT_TEXT_SHOW_COMBAT_STATE"};
COMBAT_TEXT_TYPE_INFO["LEAVING_COMBAT"] = {r = 1, g = 0.1, b = 0.1, var = "COMBAT_TEXT_SHOW_COMBAT_STATE"};
COMBAT_TEXT_TYPE_INFO["COMBO_POINTS"] = {r = 0.1, g = 0.1, b = 1, var = "COMBAT_TEXT_SHOW_COMBO_POINTS"};
COMBAT_TEXT_TYPE_INFO["RUNE"] = {r = 0.1, g = 0.1, b = 1, var = "COMBAT_TEXT_SHOW_ENERGIZE"};
COMBAT_TEXT_TYPE_INFO["PERIODIC_HEAL_ABSORB"] = {r = 0.1, g = 1, b = 0.1, show = 1};
COMBAT_TEXT_TYPE_INFO["HEAL_CRIT_ABSORB"] = {r = 0.1, g = 1, b = 0.1, show = 1};
COMBAT_TEXT_TYPE_INFO["HEAL_ABSORB"] = {r = 0.1, g = 1, b = 0.1, show = 1};
COMBAT_TEXT_TYPE_INFO["ABSORB_ADDED"] = {r = 0.1, g = 1, b = 0.1, show = 1};
]]
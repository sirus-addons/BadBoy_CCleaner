
local function removeIconTag(tag)
	if ICON_TAG_LIST[strlower(tag:sub(2, -2))] then return "" end
end
local replace = string.gsub
BadBoyConfig:RegisterEvent("ADDON_LOADED")
BadBoyConfig:SetScript("OnEvent", function(frame, evt, addon)
	if addon ~= "BadBoy_CCleaner" then return end
	if type(BADBOY_CCLEANER) ~= "table" then
		BADBOY_CCLEANER = {
			"rape",
			"anal",
			"murloc",
		}
	end
	local text
	for i=1, #BADBOY_CCLEANER do
		if not text then
			text = BADBOY_CCLEANER[i]
		else
			text = text.."\n"..BADBOY_CCLEANER[i]
		end
	end
	BadBoyCCleanerEditBox:SetText(text or "")
	BadBoyCCleanerNoIconButton:SetChecked(BADBOY_NOICONS)

	--main filtering function
	ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", function(_,_,msg,player,...)
		local chanid = select(5, ...)
		if chanid == 0 then return end --Only scan official custom channels (gen/trade)
		--if not CanComplainChat(player) then return end --Don't filter ourself
		local lowered = (msg):lower() --lower all text
		for i=1, #BADBOY_CCLEANER do --scan DB for matches
			if lowered:find(BADBOY_CCLEANER[i], nil, true) then
				return true --found a trigger, filter
			end
		end
		if BADBOY_NOICONS then
			local stripped = replace(msg, "%b{}", removeIconTag)
			if stripped ~= msg then --only modify message if we removed an icon
				return false, stripped, player, ...
			end
		end
	end)

	frame:SetScript("OnEvent", nil)
	frame:UnregisterEvent("ADDON_LOADED")
end)


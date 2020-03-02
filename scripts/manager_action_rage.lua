-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	GameSystem.actions["rage"] = { bUseModStack = false };
    ActionsManager.registerResultHandler("rage", onRage);
    ActionsManager.registerModHandler("rage", modRage);
end

function performRoll(draginfo, rActor, rageDice)
    local rRoll = {};
	rRoll.sType = "rage";	
	rRoll.sDesc = "[RAGE]";
	rRoll.aDice = {};
    rRoll.nMod = 0;
    
    -- get all dice from the rage dice
    for _,die in pairs(rageDice) do
        table.insert(rRoll.aDice, die)
    end

    if #rRoll.aDice > 0 then
        ActionsManager.performAction(draginfo, rActor, rRoll);
    end
end

function modRage(rSource, rTarget, rRoll)
    local aAddDesc = {};
    local bHeal = ModifierStack.getModifierKey("HEAL");
    if bHeal and not string.match(rRoll.sDesc, "%[HEAL%]") then
		table.insert(aAddDesc, "[HEAL]");
    end
    
    local aStatFilter = { "RAGE" };
    local nEffectCount;
	local aAddDice = {};
	local nAddMod = 0;
    aAddDice, nAddMod, nEffectCount = EffectManagerICRPG.getEffectsBonus(rSource, aStatFilter, false);
    if nEffectCount > 0 then
		bEffects = true;
    end
    
    -- If effects happened, then add note
	if bEffects then
		local sEffects = "";
		local sMod = StringManager.convertDiceToString(aAddDice, nAddMod, true);
		if sMod ~= "" then
			sEffects = "[" .. Interface.getString("effects_tag") .. " " .. sMod .. "]";
		else
			sEffects = "[" .. Interface.getString("effects_tag") .. "]";
		end
		table.insert(aAddDesc, sEffects);
    end
    
    if #aAddDesc > 0 then
		rRoll.sDesc = rRoll.sDesc .. " " .. table.concat(aAddDesc, " ");
    end
    
    rRoll.nMod = rRoll.nMod + nAddMod;
	if #aAddDice > 0 then
		for _,v in pairs(aAddDice) do
			table.insert(rRoll.aDice, v);
		end
	end
end

function onRage(rSource, rTarget, rRoll)
    local rMessage = ActionsManager.createActionMessage(rSource, rRoll);
    local nTotal = ActionsManager.total(rRoll);
    rMessage.icon = "action_rage";

    Comm.deliverChatMessage(rMessage);

    ActionEffort.notifyApplyDamage(rSource, rTarget, rRoll.bTower, rMessage.text, nTotal)
end


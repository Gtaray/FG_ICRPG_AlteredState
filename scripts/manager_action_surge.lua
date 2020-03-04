-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--
function onInit()
	GameSystem.actions["surge"] = { bUseModStack = false };
    ActionsManager.registerResultHandler("surge", onSurge);
    ActionsManager.registerModHandler("surge", modSurge);
end

function performRoll(draginfo, rActor, surgeDie)
    local rRoll = {};
	rRoll.sType = "surge";	
	rRoll.sDesc = "[SURGE]";
	rRoll.aDice = { surgeDie };
    rRoll.nMod = 0;

    if #rRoll.aDice > 0 then
        ActionsManager.performAction(draginfo, rActor, rRoll);
    end
end

function modSurge(rSource, rTarget, rRoll)
    local aAddDesc = {};
    local bHeal = ModifierStack.getModifierKey("HEAL");
    if bHeal and not string.match(rRoll.sDesc, "%[HEAL%]") then
		table.insert(aAddDesc, "[HEAL]");
    end
    
    local aStatFilter = { "SURGE" };
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

function onSurge(rSource, rTarget, rRoll)
    local rMessage = ActionsManager.createActionMessage(rSource, rRoll);
    rMessage.icon = "action_surge";

    Comm.deliverChatMessage(rMessage);
end
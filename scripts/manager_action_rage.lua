function onInit()
	GameSystem.actions["rage"] = { bUseModStack = false };
	ActionsManager.registerResultHandler("rage", onRage);
end

function getRoll(draginfo)
    local rRoll = {};
    
    -- Rage rolls should always come from drag
    if sDragType == "dice" then
        local w = list.addEntry(true);
        for _, vDie in ipairs(draginfo.getDieList()) do
            w.dice.addDie(vDie.type);
        end
    end

    return rRoll;
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
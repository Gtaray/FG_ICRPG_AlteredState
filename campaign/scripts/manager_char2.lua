-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function resolveRefNode(sRecord)
	local nodeSource = DB.findNode(sRecord);
	if not nodeSource then
		local sRecordSansModule = StringManager.split(sRecord, "@")[1];
		nodeSource = DB.findNode(sRecordSansModule .. "@*");
		if not nodeSource then
			outputUserMessage("char_error_missingrecord");
		end
	end
	return nodeSource;
end

function addCharTypeRef(nodeChar, sClass, sRecord)
	local nodeSource = resolveRefNode(sRecord);
	if not nodeSource then
		return;
    end
    
    -- Determine race to display on sheet and in notifications
    local sType = DB.getValue(nodeSource, "name", "");
    
    -- Notify
	outputUserMessage("char_message_typeadd", sType, DB.getValue(nodeChar, "name", ""));
	
	-- Add the name and link to the main character sheet
	DB.setValue(nodeChar, "type", "string", sType);
	DB.setValue(nodeChar, "typelink", "windowreference", sClass, nodeSource.getNodeName());
end

function addCharConsciousnessRef(nodeChar, sClass, sRecord)
	local nodeSource = resolveRefNode(sRecord);
	if not nodeSource then
		return;
    end
    
    -- Determine race to display on sheet and in notifications
    local sConsciousness = DB.getValue(nodeSource, "name", "");
    
    -- Notify
	outputUserMessage("char_message_consciousnessadd", sConsciousness, DB.getValue(nodeChar, "name", ""));
	
	-- Add the name and link to the main character sheet
	DB.setValue(nodeChar, "consciousness", "string", sConsciousness);
	DB.setValue(nodeChar, "consciousnesslink", "windowreference", sClass, nodeSource.getNodeName());
end

function addCharSkinRef(nodeChar, sClass, sRecord)
	local nodeSource = resolveRefNode(sRecord);
	if not nodeSource then
		return;
    end
    
    -- Determine race to display on sheet and in notifications
    local sSkin = DB.getValue(nodeSource, "name", "");
    
    -- Notify
	outputUserMessage("char_message_skinadd", sSkin, DB.getValue(nodeChar, "name", ""));
	
	-- Add the name and link to the main character sheet
	DB.setValue(nodeChar, "skin", "string", sSkin);
	DB.setValue(nodeChar, "skinlink", "windowreference", sClass, nodeSource.getNodeName());
end

function outputUserMessage(sResource, ...)
	local sFormat = Interface.getString(sResource);
	local sMsg = string.format(sFormat, ...);
	ChatManager.SystemMessage(sMsg);
end

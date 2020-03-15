-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
    DataCommon.addStat("augmented", "AUG", "AUGMENTED", "effort.augmented");
    DataCommon.addStat("gun", "GUN", "GUN", "effort.gun");
    DataCommon.addStat("healing", "HEALING", "HEALING", "effort.healing");
    DataCommon.overwriteEffortType("d6", "augmented");
    DataCommon.overwriteEffortType("d8", "gun");
    DataCommon.addEffortType("d10", "healing");
end
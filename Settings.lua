local DMW = DMW
DMW.Rotations.SHAMAN = {}
local Shaman = DMW.Rotations.SHAMAN
local UI = DMW.UI

function Shaman.Settings()
    UI.AddHeader("Totems", "use totems for 2+ mobs", true)
    UI.AddToggle("Searing Totem", nil, true)
	UI.AddHeader("Utility")
	UI.AddToggle("Lightning Shield", nil, true)	
    UI.AddToggle("Weapon Enchant", nil, true)
    UI.AddToggle("ES Interrupt", "use earth shock to interrupt regardless of mana", nil, true)
	UI.AddHeader("Defensives")
	UI.AddToggle("Stoneskin Totem", nil, true)
	UI.AddHeader("Self healing")	
	UI.AddToggle("Healing Wave", nil, false)
	UI.AddRange("Healing Wave Percent", nil, 0, 100, 1, 29)	
	UI.AddToggle("OOC Healing", nil, true)
	UI.AddRange("OOC Healing Percent HP", nil, 0, 100, 1, 50)
	UI.AddRange("OOC Healing Percent Mana", nil, 0, 100, 1, 50, true)	
	UI.AddHeader("Opener")
	UI.AddToggle("Lightning Bolt", nil, true)
	UI.AddHeader("DPS")
	UI.AddToggle("Earth Shock", nil, true)
	UI.AddRange("Earth Shock Mana", nil, 0, 100, 1, 50)	
	UI.AddToggle("Flame Shock", nil, false)
	UI.AddRange("Flame Shock Mana", nil, 0, 100, 1, 50)	
	UI.AddToggle("Stormstrike",nil,true)
end
local DMW = DMW
local Shaman = DMW.Rotations.SHAMAN
local Rotation = DMW.Helpers.Rotation
local Setting = DMW.Helpers.Rotation.Setting
local Player, Pet, Buff, Debuff, Spell, Target, Talent, Item, GCD, CDs, HUD, Enemy40Y, Enemy40YC, ComboPoints, HP, Enemy8YC, Enemy8Y, Enemy60Y, Enemy60YC, Enemy5Y, Enemy5YC
local hasMainHandEnchant,_ ,_ , _, hasOffHandEnchant = GetWeaponEnchantInfo()

local function Locals()
    Player = DMW.Player
    Pet = DMW.Player.Pet
    Buff = Player.Buffs
	HP = Player.HP
    Debuff = Player.Debuffs
    Spell = Player.Spells
    Talent = Player.Talents
    Item = Player.Items
	Power = Player.PowerPct
    Target = Player.Target or false
    HUD = DMW.Settings.profile.HUD
    CDs = Player:CDs() and Target and Target.TTD > 5 and Target.Distance < 5
	Enemy60Y, Enemy60YC = Player:GetEnemies(60)
    Enemy40Y, Enemy40YC = Player:GetEnemies(40)
	Enemy8Y, Enemy8YC = Player:GetEnemies(8)
	Enemy5Y, Enemy5YC = Player:GetEnemies(5)
end
----------------
--Smart Recast--
----------------
local function smartRecast(spell,unit,rank)
    if rank == 0 then
        rank = nil
    end
    if (not Spell[spell]:LastCast() or (DMW.Player.LastCast[1].SuccessTime and (DMW.Time - DMW.Player.LastCast[1].SuccessTime) > 0.7) or 
        not UnitIsUnit(Spell[spell].LastBotTarget, unit.Pointer)) then 
            return Spell[spell]:Cast(unit,rank)
    end
end


--------------
--5 Sec Rule--
--------------
local function FiveSecond()
    if FiveSecondRuleTime == nil then
        FiveSecondRuleTime = DMW.Time 
    end
    local FiveSecondRuleCount = DMW.Time - FiveSecondRuleTime
    if FiveSecondRuleCount > 6.5 then
        FiveSecondRuleTime = DMW.Time 
    end
    if Setting("Five Second Rule") and ((FiveSecondRuleCount) >= Setting("Five Second Cutoff") or (FiveSecondRuleCount <= 0.4)) then return true end
    --print(FiveSecondRuleCount)
end

local function Totems()
	------------------
	--- Totems ---
	------------------
-- Stoneskin Totem for 2+ mobs Defensive	
	if Target and Target.ValidEnemy and Setting("Stoneskin Totem") and Player.Combat and GetTotemInfo(2) == false and Enemy5YC > 1 then 
		if Spell.StoneskinTotem:Cast(Player) then
			return true 
		end
	end
-- Stone Claw Totem for 2+ mobs	
	if Target and Target.ValidEnemy and Setting("Ston Claw Totem") and Player.Combat and GetTotemInfo(2) == false and Enemy5YC > 1 then 
		if Spell.StoneclawTotem:Cast(Player) then
			return true 
		end
	end	
--Magma Totem
	if Spell.MagmaTotem:Known() and Setting("Magma Totem") and Player.Combat and GetTotemInfo(1) == false and Enemy8YC > 1 and Player.PowerPct > Setting("Magma Totem Mana") and  Target and Target.ValidEnemy and  Target.TTD > 5 then 
		if Spell.MagmaTotem:Cast(Player) then
			return true 
		end
	end		
--Fire Nova Totem	
	if Spell.FireNovaTotem:Known() and Setting("Fire Nova Totem") and Target and Target.ValidEnemy and Player.Combat and GetTotemInfo(1) == false and Enemy5YC > 1 and Player.PowerPct > Setting("Fire Nova Totem Mana") and Target.TTD > 5 then 
		if Spell.FireNovaTotem:Cast(Player) then
			return true 
		end
	end
--Searing Totem
	if Setting("Searing Totem") and Player.Combat and GetTotemInfo(1) == false and Player.PowerPct > Setting("Searing Totem Mana") and Target and Target.ValidEnemy and Target.TTD > 10 then 
		if Spell.SearingTotem:Cast(Player) then
			return true
		end
	end
-- StrengthOfEarthTotem 
	if Spell.StrengthOfEarthTotem:Known() and Setting("Strength Of Earth Totem") and Player.Combat and GetTotemInfo(2) == false and Enemy40YC > 0 then 
		if Spell.StrengthOfEarthTotem:Cast(Player) then
			return true
		end
	end
--GraceOfAirTotem
	if Spell.GraceOfAirTotem:Known() and Setting("Grace Of Air Totem") and Player.Combat and GetTotemInfo(4) == false and Enemy40YC > 0 then 
		if Spell.GraceOfAirTotemm:Cast(Player) then
			return true
		end
	end
-- WindfuryTotem
	if Spell.WindfuryTotem:Known() and Setting("Windfury Totem") and Player.Combat and GetTotemInfo(4) == false and Enemy40YC > 0 then 
		if Spell.WindfuryTotem:Cast(Player) then
			return true
		end
	end
end
	
local function Utility()
	------------------
	--- Utility ---
	------------------
--Orc Racial
	if  Spell.BloodFury:Known() and Setting("Orc Racial") and Player.HP > 60 and Target and Target.ValidEnemy and Target.HP > 70 and Player.Combat then
		if Spell.BloodFury:Cast(Player) then
			return true
		end
	end
	
--Lightning Shield
    if Setting("Lightning Shield") and Spell.LightningShield:Known() then
        if Buff.LightningShield:Remain() < 30 and Spell.LightningShield:Cast(Player) then
            return true
        end
    elseif Setting("LightningShield") and Spell.ImprovedLightningShield:Known() then
        if Buff.ImprovedLightningShield:Remain() < 300 and Spell.ImprovedLightningShield:Cast(Player) then
            return true
        end
    end
--Weapon Enchant
    if Setting("Weapon Enchant") and  not GetWeaponEnchantInfo() then
        if Spell.WindfuryWeapon:Known() then 
			if Spell.WindfuryWeapon:Cast(Player) then 
				return true
            end
        elseif Spell.RockbiterWeapon:Cast(Player) then
            return true
        end
     end
			
-- Earth Shock Interrupt
if Setting("Earth Shock Interrupt") and	Target and Target.ValidEnemy and Target.Distance < 20 and Target:Interrupt() then
		if Spell.EarthShock:Cast(Target, 1) then
			return
		end
	end	
-- Frost Shock Slow Runner
if Setting("Frost Shock Runner") and Target and Target.ValidEnemy and Target.Distance < 20 and Target.CreatureType == "Humanoid" and Target.HP <= 20 then
		if Spell.FrostShock:Cast(Target) then
			return
		end
	end			
end	
	
local function DEF()
	------------------
	--- Defensives ---
	------------------
	--In Combat healing
	if Setting("In Combat Heal") and HP < Setting("Lesser Heal HP") and Player.Combat and not Player.Moving then
		if Spell.LesserHealingWave:Known() then 
			if Spell.LesserHealingWave:Cast(Player) then
				return true
		end
		elseif  Spell.HealingWave:Cast(Player) then
			return true
		end
	end	
	if Setting("OOC Healing") and not Player.Combat and not Player.Moving and HP <= Setting("OOC Healing Percent HP") and Player.PowerPct > Setting("OOC Healing Percent Mana") then
		if  Spell.HealingWave:Cast(Player) then
			return true
		end
	end
-- Cure Poison
	if Setting("Cure Poison") and Player:Dispel(Spell.CurePoison) and Player.PowerPct > 20 then
	if Spell.CurePoison:Cast(Player) then return true end
	end
-- Cure Disease
	if Setting("Cure Disease") and Player:Dispel(Spell.CureDisease) and Player.PowerPct > 20 then
	if Spell.CureDisease:Cast(Player) then return true end
	end	
end

function Shaman.Rotation()
    Locals()
	if  Utility() then
		return true
	end
	if  Totems() then
		return true
	end
	if DEF() then
		return true
	end
	-----------------
	-- Targetting --
	-----------------		
    if Setting("Auto Target Quest Units") then
       if Player:AutoTargetQuest(20, true) then
			return true
        end
    end
    if Player.Combat and Setting("Auto Target") then
        if Player:AutoTarget(20, true) then
            return true
        end
	end
	-----------------
	-- DPS --
	-----------------	
-- EarthShock
	if Setting("Earth Shock") and Target and Target.ValidEnemy and Target.Distance < 20 and Target.Facing and Player.PowerPct > Setting("Earth Shock Mana") and Target.TTD > 1 then
		if Spell.EarthShock:Cast(Target) then
			return
		end
	end
-- Flame Shock
	if Setting("Flame Shock") and Target and Target.ValidEnemy and Target.Distance < 20 and Target.Facing and Player.PowerPct > Setting("Flame Shock Mana") and Target.TTD > 8  and not Debuff.FlameShock:Exist(Target) and Target.CreatureType ~= "Totem" and Target.CreatureType ~= "Elemental" and Target.Facing then
		if Spell.FlameShock:Cast(Target) then
			return 
		end
	end
-- Stormstrike
    if Setting("Stormstrike") and Target and Target.ValidEnemy and Target.Distance <= 5 then
       if Spell.Stormstrike:Cast(Target) then
			return true
		end	
	end
	-- Autoattack
    if  Target and Target.ValidEnemy and Target.Distance <= 5 then
        StartAttack()
	end
	--Lightning Bolt
	if Setting("Lightning Bolt") and Target and Target.ValidEnemy and Target.Distance >= 20 and not Player.Moving and Target.Facing and not Spell.LightningBolt:LastCast() then 
		if Spell.LightningBolt:Cast(Target, 1) then
		return true
		end
	end	
end
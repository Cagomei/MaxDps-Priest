local _, addonTable = ...
local Priest = addonTable.Priest
local MaxDps = _G.MaxDps
if not MaxDps then return end
local setSpell

local UnitPower = UnitPower
local UnitHealth = UnitHealth
local UnitAura = C_UnitAuras.GetAuraDataByIndex
local UnitAuraByName = C_UnitAuras.GetAuraDataBySpellName
local UnitHealthMax = UnitHealthMax
local UnitPowerMax = UnitPowerMax
local SpellHaste
local SpellCrit
local GetSpellInfo = C_Spell.GetSpellInfo
local GetSpellCooldown = C_Spell.GetSpellCooldown
local GetSpellCount = C_Spell.GetSpellCastCount

local ManaPT = Enum.PowerType.Mana
local RagePT = Enum.PowerType.Rage
local FocusPT = Enum.PowerType.Focus
local EnergyPT = Enum.PowerType.Energy
local ComboPointsPT = Enum.PowerType.ComboPoints
local RunesPT = Enum.PowerType.Runes
local RunicPowerPT = Enum.PowerType.RunicPower
local SoulShardsPT = Enum.PowerType.SoulShards
local LunarPowerPT = Enum.PowerType.LunarPower
local HolyPowerPT = Enum.PowerType.HolyPower
local MaelstromPT = Enum.PowerType.Maelstrom
local ChiPT = Enum.PowerType.Chi
local InsanityPT = Enum.PowerType.Insanity
local ArcaneChargesPT = Enum.PowerType.ArcaneCharges
local FuryPT = Enum.PowerType.Fury
local PainPT = Enum.PowerType.Pain
local EssencePT = Enum.PowerType.Essence
local RuneBloodPT = Enum.PowerType.RuneBlood
local RuneFrostPT = Enum.PowerType.RuneFrost
local RuneUnholyPT = Enum.PowerType.RuneUnholy

local fd
local ttd
local timeShift
local gcd
local cooldown
local buff
local debuff
local talents
local targets
local targetHP
local targetmaxHP
local targethealthPerc
local curentHP
local maxHP
local healthPerc
local timeInCombat
local classtable
local LibRangeCheck = LibStub('LibRangeCheck-3.0', true)

local Insanity
local InsanityMax
local InsanityDeficit
local Mana
local ManaMax
local ManaDeficit
local ManaPerc

local Holy = {}

function Holy:st()
    if (MaxDps:CheckSpellUsable(classtable.ShadowWordPain, 'Shadow Word: Pain')) and (not MaxDps:FindADAuraData(classtable.ShadowWordPain).up or MaxDps:FindADAuraData(classtable.ShadowWordPain).refreshable) and cooldown[classtable.ShadowWordPain].ready then
        if not setSpell then setSpell = classtable.ShadowWordPain end
    end
    if (MaxDps:CheckSpellUsable(classtable.InnerFocus, 'InnerFocus')) and cooldown[classtable.MindBlast].ready and cooldown[classtable.InnerFocus].ready then
        if not setSpell then setSpell = classtable.InnerFocus end
    end
    if (MaxDps:CheckSpellUsable(classtable.Smite, 'Smite')) and cooldown[classtable.Smite].ready then
        if not setSpell then setSpell = classtable.Smite end
    end
end

local function ClearCDs()
end

function Holy:callaction()
    Holy:st()
end
function Priest:Holy()
    fd = MaxDps.FrameData
    ttd = (fd.timeToDie and fd.timeToDie) or 500
    timeShift = fd.timeShift
    gcd = fd.gcd
    cooldown = fd.cooldown
    buff = fd.buff
    debuff = fd.debuff
    talents = fd.talents
    targets = MaxDps:SmartAoe()
    Mana = UnitPower('player', ManaPT)
    ManaMax = UnitPowerMax('player', ManaPT)
    ManaDeficit = ManaMax - Mana
    targetHP = UnitHealth('target')
    targetmaxHP = UnitHealthMax('target')
    targethealthPerc = (targetHP >0 and targetmaxHP >0 and (targetHP / targetmaxHP) * 100) or 100
    curentHP = UnitHealth('player')
    maxHP = UnitHealthMax('player')
    healthPerc = (curentHP / maxHP) * 100
    timeInCombat = MaxDps.combatTime or 0
    classtable = MaxDps.SpellTable
    SpellHaste = UnitSpellHaste('player')
    SpellCrit = GetCritChance()
    Insanity = UnitPower('player', InsanityPT)
    InsanityMax = UnitPowerMax('player', InsanityPT)
    InsanityDeficit = InsanityMax - Insanity
    ManaPerc = (Mana / ManaMax) * 100

    classtable.ShadowWordPain = 10894
    classtable.InnerFocus = 14751
    classtable.MindBlast = 10947
    classtable.Smite = 10934

    local function debugg()
    end


    --if MaxDps.db.global.debugMode then
    --   debugg()
    --end

    setSpell = nil
    ClearCDs()

    Holy:callaction()
    if setSpell then return setSpell end
end

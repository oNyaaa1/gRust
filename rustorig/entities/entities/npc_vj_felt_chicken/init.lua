AddCSLuaFile("shared.lua")
include('shared.lua')
--[[-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------]]
ENT.Model = {
	"models/chicken/wisard_chicken.mdl" -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
}

ENT.StartHealth = 50
ENT.Bleeds = true -- Does the SNPC bleed? (Blood decal, particle, etc.)
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.HasBloodParticle = true -- Does it spawn a particle when damaged?
ENT.HasBloodDecal = true -- Does it spawn a decal when damaged?
ENT.HasBloodPool = false -- Does it have a blood pool?
ENT.chicken_Level = 0
ENT.HasRangeAttack = true
ENT.HasDeathRagdoll = false
ENT.RangeAttackEntityToSpawn = "" -- The entity that is spawned when range attacking
ENT.RangeAttackPos_Up = 1
ENT.RangeDistance = 500
ENT.RangeToMeleeDistance = 300
ENT.RangeAttackAnimationDelay = 2
ENT.NextRangeAttackTime = 0.5
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.MeleeAttackDamage = 35
ENT.MeleeAttackDamageType = DMG_SLASH -- Type of Damage
ENT.MeleeAttackAnimationDelay = 0 -- It will wait certain amount of time before playing the animation
ENT.MeleeAttackAnimationFaceEnemy = false -- Should it face the enemy while playing the melee attack animation?
ENT.MeleeAttackAnimationDecreaseLengthAmount = 2 -- This will decrease the time until starts chasing again. Use it to fix animation pauses until it chases the enemy.
ENT.MeleeAttackDistance = 90 -- How close does it have to be until it attacks?
ENT.MeleeAttackAngleRadius = 100 -- What is the attack angle radius? | 100 = In front of the SNPC | 180 = All around the SNPC
ENT.MeleeAttackDamageDistance = 80 -- How far does the damage go?
ENT.MeleeAttackDamageAngleRadius = 100 -- What is the damage angle radius? | 100 = In front of the SNPC | 180 = All around the SNPC
ENT.TimeUntilLeapAttackDamage = 0.60 -- How much time until it runs the leap damage code?
ENT.NextLeapAttackTime = 0.1 -- How much time until it can use a leap attack?
ENT.NextLeapAttackTime_DoRand = false -- False = Don't use random time | Number = Picks a random number between the regular timer and this timer
ENT.NextAnyAttackTime_Leap = 0.1 -- How much time until it can use any attack again? | Counted in Seconds
ENT.NextAnyAttackTime_Leap_DoRand = false -- False = Don't use random time | Number = Picks a random number between the regular timer and this timer
ENT.LeapAttackReps = 1 -- How many times does it run the leap attack code?
ENT.StopLeapAttackAfterFirstHit = true -- Should it stop the leap attack from running rest of timers when it hits an enemy?
ENT.TimeUntilLeapAttackVelocity = 0.1 -- How much time until it runs the velocity code?
ENT.LeapAttackUseCustomVelocity = false -- Should it disable the default velocity system?
ENT.LeapAttackVelocityForward = 120 -- How much forward force should it apply?
ENT.LeapAttackVelocityUp = 210 -- How much upward force should it apply?
ENT.LeapAttackVelocityRight = 0 -- How much right force should it apply?
ENT.LeapAttackDamage = 5
ENT.LeapAttackDamageDistance = 100 -- How far does the damage go?
ENT.LeapAttackDamageType = DMG_SLASH -- Type of Damage
ENT.DisableLeapAttackAnimation = false -- if true, it will disable the animation code
ENT.RunAwayOnUnknownDamage = true -- Should run away on damage
ENT.AttackProps = false
ENT.GibOnDeathDamagesTable = {
	"UseDefault" -- Damages that it gibs from | "UseDefault" = Uses default damage types | "All" = Gib from any damage
}

ENT.VJ_NPC_Class = {
	"CLASS_ECHICKEN" -- NPCs with the same class with be allied to each other
}

ENT.HasSounds = true -- Put to false to disable ALL sound
ENT.SoundTbl_Alert = {"killer_chicken/alert.wav"}
ENT.SoundTbl_LeapAttackJump = {"killer_chicken/leap1.wav", "killer_chicken/leap2.wav", "killer_chicken/leap3.wav", "killer_chicken/leap4.wav", "killer_chicken/leap5.wav", "killer_chicken/leap6.wav", "killer_chicken/leap7.wav", "killer_chicken/leap8.wav", "killer_chicken/leap9.wav", "killer_chicken/leap10.wav", "killer_chicken/leap11.wav", "killer_chicken/leap12.wav"}
ENT.SoundTbl_LeapAttackDamage = {"killer_chicken/peck.wav"}
ENT.SoundTbl_Idle = {"killer_chicken/idle1.wav", "killer_chicken/idle2.wav", "killer_chicken/idle3.wav", "killer_chicken/idle4.wav", "killer_chicken/idle5.wav", "killer_chicken/idle6.wav"}
ENT.SoundTbl_Pain = {"killer_chicken/pain1.wav", "killer_chicken/pain2.wav", "killer_chicken/pain3.wav"}
ENT.SoundTbl_Death = {"killer_chicken/death.wav"}
ENT.SoundTbl_MeleeAttack = {"ambient/voices/citizen_punches2.wav"}
ENT.GeneralSoundPitch1 = 95
ENT.GeneralSoundPitch2 = 100
ENT.MovementType = VJ_MOVETYPE_GROUND
ENT.HasDeathRagdoll = true
-- ====== Death Animation Variables ====== --
ENT.HasDeathAnimation = false -- Does it play an animation when it dies?
ENT.AnimTbl_Death = {
	"die" -- Death Animations
}

-- To let the base automatically detect the animation duration, set this to false:
ENT.DeathAnimationTime = false -- Time until the SNPC spawns its corpse and gets removed
ENT.DeathAnimationChance = 1 -- Put 1 if you want it to play the animation all the time
ENT.DeathAnimationDecreaseLengthAmount = 0 -- This will decrease the time until it turns into a corpse
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.DeathCorpseFade = false -- Fades the ragdoll on death
ENT.DeathCorpseFadeTime = 5 * 60-- How much time until the ragdoll fades | Unit = Seconds
ENT.DeathCorpseSetBoneAngles = true -- This can be used to stop the corpse glitching or flying on death
ENT.DeathCorpseApplyForce = true -- If false, force will not be applied to the corpse
ENT.WaitBeforeDeathTime = 5 * 60 -- Time until the SNPC spawns its corpse and gets removed
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetModelScale(1.5, 0)
	self:SetCollisionBounds(Vector(10, 10, 10), Vector(-10, -10, 0))
end

---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_AfterDamage(dmginfo, hitgroup)
	if self.chicken_Level == 0 and (self:Health() < (self:GetMaxHealth() * 0.5)) then
		timer.Simple(1.2, function()
			if IsValid(self) and self.Dead ~= true then
				self:SetSkin(1)
				VJ_EmitSound(self, "chicken_spawner/spawn.wav", 80)
				effects.BeamRingPoint(self:GetPos() + self:GetForward() * 20, 0.3, 2, 600, 60, 0, Color(0, 0, 255), {
					framerate = 20,
					flags = 0
				})

				util.ScreenShake(self:GetPos(), 10, 10, 1, 1000)
				util.VJ_SphereDamage(self, self, self:GetPos(), 500, 20, DMG_SONIC, true, true, {
					DisableVisibilityCheck = true,
					Force = 80
				})
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
-- All functions and variables are located inside the base files. It can be found in the GitHub Repository: https://github.com/DrVrej/VJ-Base
--[[-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------]]
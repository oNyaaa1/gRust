AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_anim"
function ENT:Initialize()
	if CLIENT then return end
	self:SetModel("models/environment/misc/barrel_v2.mdl")
	self:PhysicsInitStatic(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetHealth(50)
	self:SetMaxHealth(50)
	self:SetColor(Color(255, 255, 255))
	self:SetBodygroup(1, math.random(0, 1))
	self:PrecacheGibs()
end

function ENT:OnTakeDamage(dmg)
	if SERVER then self:GibBreakServer(dmg:GetDamageForce()) end
end
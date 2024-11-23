AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Turret"
ENT.Category = ""
ENT.Spawnable = true
ENT.AdminOnly = false
ENT.BaseModel = "models/deployable/turret_base.mdl"
ENT.PitchModel = "models/deployable/turret_pitch.mdl"
ENT.YawModel = "models/deployable/turret_yaw.mdl"
ENT.PitchPos = Vector(0, 0, 5)
ENT.YawPos = Vector(0, 0, 30)
ENT.GunPos = Vector(0, 0, -5)
ENT.Range = 384
if SERVER then
	function ENT:Initialize()
		self.Entity:SetModel("models/deployable/turret_base.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
			phys:EnableMotion(false)
		end
	end

	function ENT:Think()
		local targ = self:GetTarget()
		if targ == NULL then return end
		local AimSpot = targ:GetBonePosition(targ:LookupBone("ValveBiped.Bip01_Head1")) - Vector(0, 0, 5)
		local bullet = {}
		bullet.Num = 1
		bullet.Src = self:GetPos()
		bullet.Dir = AimSpot - self:GetPos()
		bullet.Spread = Vector(0, 0, 0)
		bullet.Tracer = 5
		bullet.Force = 2
		bullet.Damage = 0
		self:FireBullets(bullet)
		//self:NextThink(CurTime() + 0.5)
		//return true
	end

	function ENT:OnTakeDamage(dmg)
		return
		--[[local ply = dmg:GetAttacker()
		local inflictor = dmg:GetInflictor()
		--if type(inflictor) == "Entity" then return end
		--if self.PropOwned != ply then return end
		self.Ent_Health = self.Ent_Health - dmg:GetDamage()
		if self.Ent_Health <= 0 then self:Remove() end
		self:SetNWInt("health_" .. self:GetClass(), self.Ent_Health)]]
	end

	function ENT:OnRemove()
		self:EmitSound("zohart/building/wood_gib-4.wav")
	end

	function ENT:Use(btn, ply)
	end

	function ENT:StartTouch(entity)
		return false
	end

	function ENT:EndTouch(entity)
		return false
	end

	function ENT:Touch(entity)
		return false
	end
end

function ENT:isVisible(v)
	local ply = self
	local pos = v:LocalToWorld(v:OBBCenter())
	local trace = {
		start = ply:EyePos(),
		endpos = pos,
		filter = {ply, v},
		mask = MASK_SHOT
	}

	local tr = util.TraceLine(trace)
	if not tr.Hit then return true end
	return false
end

function ENT:GetTarget()
	for k, v in pairs(player.GetAll()) do
		if self:GetPos():Distance(v:GetPos()) <= 300 and v:IsPlayer() and self:isVisible(v) then return v end
	end
	return NULL
end

function ENT:GetRotateSpeed()
	if IsValid(self:GetTarget()) then
		return 10
	else
		return 1
	end
end

function ENT:GetTargetRotation()
	local target = self:GetTarget()
	if IsValid(target) then
		return (target:GetPos() - self:GetPos()):Angle() - self:GetAngles()
	else
		self.TargetIdleYaw = math.max(math.min(2 * math.sin(0.2 * (CurTime() + self.IdleOffset) * math.pi), 1), -1) * 45
		return Angle(0, self.TargetIdleYaw, 0)
	end
end

function ENT:UpdateRotation()
	local rotation = self:GetTargetRotation()
	self.Rotation = self.Rotation or rotation
	self.Rotation = LerpAngle(FrameTime() * self:GetRotateSpeed(), self.Rotation, rotation)
end

if CLIENT then
	ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
	function ENT:Initialize()
		self.YawEntity = ClientsideModel(self.YawModel)
		self.YawEntity:SetParent(self)
		self.YawEntity:SetLocalPos(self.YawPos)
		self.YawEntity:SetLocalAngles(Angle(0, 0, 0))
		self.PitchEntity = ClientsideModel(self.PitchModel)
		self.PitchEntity:SetParent(self.YawEntity)
		self.PitchEntity:SetLocalPos(self.PitchPos)
		self.PitchEntity:SetLocalAngles(Angle(0, 0, 0))
		self.IdleOffset = self:EntIndex()
	end

	function ENT:UpdateEntities()
		local weaponID = 0
		if weaponID ~= 0 then
			local weapon = "hello" --...
			if weapon then
				if not IsValid(self.WeaponEntity) then
					self.WeaponEntity = ClientsideModel(weapon:GetModel())
					self.WeaponEntity:SetParent(self.PitchEntity)
					self.WeaponEntity:SetLocalPos(self.GunPos)
					self.WeaponEntity:SetLocalAngles(Angle(0, 0, 0))
					self.WeaponData = weapons.GetStored(weapon:GetWeapon())
				elseif self.LastWeaponID ~= weaponID then
					self.WeaponEntity:SetModel(weapon:GetModel())
					self.WeaponData = weapons.GetStored(weapon:GetWeapon())
				end
			end
		else
			if IsValid(self.WeaponEntity) then
				self.WeaponEntity:Remove()
				self.WeaponEntity = nil
				self.WeaponData = nil
			end
		end

		if IsValid(self.WeaponEntity) then
			self.WeaponEntity:SetParent(self.PitchEntity)
			self.WeaponEntity:SetLocalPos(self.GunPos)
			self.WeaponEntity:SetLocalAngles(Angle(0, 0, 0))
		end

		if not IsValid(self.YawEntity) then
			self.YawEntity = ClientsideModel(self.YawModel)
			self.YawEntity:SetParent(self)
			self.YawEntity:SetLocalPos(self.YawPos)
			self.YawEntity:SetLocalAngles(Angle(0, 0, 0))
		end

		if not IsValid(self.PitchEntity) then
			self.PitchEntity = ClientsideModel(self.PitchModel)
			self.PitchEntity:SetParent(self.YawEntity)
			self.PitchEntity:SetLocalPos(self.PitchPos)
			self.PitchEntity:SetLocalAngles(Angle(0, 0, 0))
		end

		self.YawEntity:SetParent(self)
		self.YawEntity:SetLocalPos(self.YawPos)
		self.YawEntity:SetLocalAngles(Angle(0, 0, 0))
		self.PitchEntity:SetParent(self.YawEntity)
		self.PitchEntity:SetLocalPos(self.PitchPos)
		self.PitchEntity:SetLocalAngles(Angle(0, 0, 0))
	end

	function ENT:Think()
		if not self.NextEntitiesUpdate or self.NextEntitiesUpdate < CurTime() then
			self:UpdateEntities()
			self.NextEntitiesUpdate = CurTime() + 5
		end

		self:UpdateRotation()
		local yaw = self.Rotation.y
		local pitch = self.Rotation.p
		self.YawEntity:SetLocalAngles(Angle(0, yaw, 0))
		self.PitchEntity:SetLocalAngles(Angle(pitch, 0, 0))
		self:SetNextClientThink(CurTime())
		return true
	end

	function ENT:OnRemove()
		if IsValid(self.YawEntity) then self.YawEntity:Remove() end
		if IsValid(self.PitchEntity) then self.PitchEntity:Remove() end
		if IsValid(self.WeaponEntity) then self.WeaponEntity:Remove() end
	end

	function ENT:Draw()
		self:DrawModel()
	end
end
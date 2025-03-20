WepHolster = {}
WepHolster.defData = {}
WepHolster.HolsteredWeps = WepHolster.HolsteredWeps or {}
WepHolster.wepInfo = WepHolster.wepInfo or {}
local function CalcOffset(pos, ang, off)
	return pos + ang:Right() * off.x + ang:Forward() * off.y + ang:Up() * off.z
end

hook.Add("InitPostEntity", "wepreg", function()
	for k, v in pairs(weapons.GetList()) do
		WepHolster.defData[v.ClassName] = {}
		WepHolster.defData[v.ClassName].Model = v.WorldModel
		WepHolster.defData[v.ClassName].Bone = "ValveBiped.Bip01_Spine"
		WepHolster.defData[v.ClassName].BoneOffset = {Vector(5, 6, 0), Angle(0, 0, 0)}
		WepHolster.HolsteredWeps[v.ClassName] = WepHolster.defData[v.ClassName]
	end
end)

local model = nil
hook.Add("PlayerSwitchWeapon", "plebwep", function(ply, oldwep, newwep)
	print("test)")
	if not IsValid(ply) then return end
	if ply:Health() > 0 then
		model = ClientsideModel(oldwep:GetWeaponWorldModel())
	elseif ply:Health() <= 0 and IsValid(model) then
		model:Remove()
		model = nil
	end
end)

hook.Add("PostPlayerDraw", "WeaponHolster", function(ply)
	if IsValid(ply) and ply:Alive() then
		if model == nil then return end
		for class, wep in pairs(WepHolster.HolsteredWeps) do
			local bone = ply:LookupBone(wep.Bone)
			if not bone then return end
			local matrix = ply:GetBoneMatrix(bone)
			if not matrix then return end
			local pos = matrix:GetTranslation()
			local ang = matrix:GetAngles()
			pos = CalcOffset(pos, ang, wep.BoneOffset[1])
			model:SetRenderOrigin(pos)
			ang:RotateAroundAxis(ang:Forward(), wep.BoneOffset[2].p)
			ang:RotateAroundAxis(ang:Up(), wep.BoneOffset[2].y)
			ang:RotateAroundAxis(ang:Right(), wep.BoneOffset[2].r)
			model:SetRenderAngles(ang)
			model:DrawModel()
		end
	end
end)
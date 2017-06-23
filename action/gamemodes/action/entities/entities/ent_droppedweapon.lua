AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_entity"

ENT.PrintName = "Thrown Weapon"

ENT.Spawnable = false
ENT.Model = "models/weapons/w_rif_ak47.mdl"

if SERVER then
	function ENT:Initialize()
		self:SetModel(self.Model)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:PhysWake()

		self.Ammo = 30
		self.Creation = CurTime()
		self.Class = "weapon_pistol"
		self.Thrower = NULL
	end

	function ENT:PhysicsCollide(data, phys)
		if data.Speed > 50 then
			self.HitGround = true
			self:EmitSound(Sound("HEGrenade.Bounce"))
		end
	end

	function ENT:StartTouch(ent)
		-- print("Thrown gun velocity: " .. tostring(self:GetVelocity())
		print("Thrown gun velocity length: " .. self:GetVelocity():Length())
		if IsValid(ent) and (ent:IsPlayer() or ent:IsNPC()) then
			if (CurTime() - self.Creation) > 1 and self:GetVelocity():Length() < 200 then
				local wep = ent:Give(self.Class)
				if g_GunTypeWeapons[self.Class] then
					ent:SetAmmo(self.Ammo, wep.Primary.Ammo)
				end
				self:Remove()
			elseif self:GetVelocity():Length() > 200 and not self.HitGround then
				local dmg = DamageInfo()
				dmg:SetDamageType(DMG_CLUB)
				dmg:SetDamage(self:GetVelocity():Length() / 2)
				dmg:SetAttacker(self.Thrower)
				dmg:SetInflictor(self)
				ent:TakeDamageInfo(dmg)
			end
		end
	end

	function ENT:Think()
		if (CurTime() - self.Creation) > 1 then
			self:SetOwner(NULL)
		end
	end
else -- CLIENT
	function ENT:Draw()
		self:DrawModel()
	end
end

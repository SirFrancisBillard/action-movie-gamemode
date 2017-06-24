AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_entity"

ENT.PrintName = "Thrown Grenade"

ENT.Spawnable = false
ENT.Model = "models/weapons/w_eq_fraggrenade.mdl"

local time = CreateConVar("action_grenade_timer", "3", FCVAR_REPLICATED, "How long a grenade takes to explode.")

if SERVER then
	function ENT:Initialize()
		self:SetModel(self.Model)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:PhysWake()

		timer.Simple(time:GetInt(), function()
			if IsValid(self) then
				self:Explode()
			end
		end)
	end

	function ENT:PhysicsCollide(data, phys)
		if data.Speed > 50 then
			self:EmitSound(Sound("HEGrenade.Bounce"))
		end
	end

	function ENT:Explode()
		util.BlastDamage(self, self:GetOwner(), self:GetPos(), 750, 250)

		local boom = EffectData()
		boom:SetOrigin(self:GetPos())
		util.Effect("Explosion", boom, true, true)

		self:Remove()
	end
else -- CLIENT
	function ENT:Draw()
		self:DrawModel()
	end
end

SYS.FullName = "Weapons"
SYS.SGUIName = "weapons"

SYS.Powered = true

if SERVER then
    -- resource.AddFile("materials/systems/weapons.png")

    function SYS:CalculatePowerNeeded()
        local tot = 0
        for slot = moduletype.weapon1, moduletype.weapon3 do
            local mdl = self:GetRoom():GetModule(slot)
            if mdl and not mdl:IsFullyCharged() then
                local weapon = mdl:GetWeapon()
                tot = tot + weapon:GetMaxPower()
            end
        end
        return tot
    end

    function SYS:FireWeapon(slot, target, rot)
        local mdl = self:GetRoom():GetModule(slot)
        if mdl and mdl:CanShoot() then
            mdl:RemoveCharge(mdl:GetWeapon():GetShotCharge())
            mdl:GetWeapon():OnShoot(self:GetShip(), target, rot)
            sound.Play(mdl:GetWeapon().LaunchSound, self:GetRoom():GetPos())
        end
    end

    function SYS:Think(dt)
        local power = self:GetPower()
        local needed = self:GetPowerNeeded()
        if needed > 0 then
            local ratio = power / needed
            for slot = moduletype.weapon1, moduletype.weapon3 do
                local mdl = self:GetRoom():GetModule(slot)
                if mdl then mdl:AddCharge(ratio * dt) end
            end
        end
    end
elseif CLIENT then
    -- SYS.Icon = Material("systems/weapons.png", "smooth")
end

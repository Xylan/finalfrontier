local sparkSounds = {
    "ambient/energy/spark1.wav",
    "ambient/energy/spark2.wav",
    "ambient/energy/spark3.wav",
    "ambient/energy/spark4.wav",
    "ambient/energy/spark5.wav",
    "ambient/energy/spark6.wav"
}

function EFFECT:Init(data)
    local origin = data:GetOrigin()
    local mag = data:GetMagnitude()
    local radius = data:GetScale()

    local count = math.Clamp(math.sqrt(mag) * 8, 4, 64)
        
    local emitter = ParticleEmitter(origin)
    for i = 1, count do
        local ang = math.random() * math.pi * 2
        local rad = math.random() * radius
        local pos = Vector(
            origin.x + math.cos(ang) * rad,
            origin.y + math.sin(ang) * rad,
            origin.z
        )

        local particle = emitter:Add("effects/spark", pos)
        if particle then
            particle:SetVelocity((pos - origin + Vector(0, 0, math.random() * 16))
                * (5 + math.random() * 5))

            particle:SetGravity(Vector(0, 0, -600))
            particle:SetAirResistance(100)
            particle:SetDieTime(math.Rand(0.5, 1.5))

            particle:SetLifeTime(0)
            particle:SetStartAlpha(math.Rand(191, 255))
            particle:SetEndAlpha(0)
            particle:SetStartSize(2)
            particle:SetEndSize(0)
            particle:SetRoll(math.Rand(0, 360))
            particle:SetRollDelta(0)
            
            particle:SetCollide(true)
            particle:SetBounce(0.3)
        end
    end
    emitter:Finish()

    sound.Play(table.Random(sparkSounds), origin, 85 + (30 / 16 * mag), 100)
end

function EFFECT:Think( )
    return false
end

function EFFECT:Render()
    return
end

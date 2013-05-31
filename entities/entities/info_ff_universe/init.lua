universe = nil

ENT.Type = "point"
ENT.Base = "base_point"

ENT._width = 0
ENT._height = 0

ENT._horzSectors = 0
ENT._vertSectors = 0

ENT._sectors = nil

ENT._nwdata = nil

function ENT:KeyValue(key, value)
    if not self._nwdata then self._nwdata = {} end
    if key == "width" then
        self._nwdata.width = tonumber(value)
    elseif key == "height" then
        self._nwdata.height = tonumber(value)
    elseif key == "horzSectors" then
        self._nwdata.horzSectors = tonumber(value)
    elseif key == "vertSectors" then
        self._nwdata.vertSectors = tonumber(value)
    end
end

function ENT:Initialize()
    self._sectors = {}

    if not self._nwdata then self._nwdata = {} end

    self:_UpdateNWData()
end

function ENT:GetHorizontalSectors()
    return self._nwdata.horzSectors
end

function ENT:GetVerticalSectors()
    return self._nwdata.vertSectors
end

function ENT:GetWorldWidth()
    return self._nwdata.width
end

function ENT:GetWorldHeight()
    return self._nwdata.height
end

function ENT:WrapCoordinates(x, y)
    return x - math.floor(x / self:GetHorizontalSectors()) * self:GetHorizontalSectors(),
        y - math.floor(y / self:GetVerticalSectors()) * self:GetVerticalSectors()
end

function ENT:GetWorldPos(x, y)
    x, y = ((x / self:GetHorizontalSectors()) - 0.5) * self:GetWorldWidth(),
        ((y / self:GetVerticalSectors()) - 0.5) * self:GetWorldHeight()
    return Vector(x, y, 0) + self:GetPos()
end

function ENT:GetUniversePos(vec)
    local diff = (vec - self:GetPos())
    return ((diff.x / self:GetWorldWidth()) + 0.5) * self:GetHorizontalSectors(),
        ((diff.y / self:GetWorldHeight()) + 0.5) * self:GetVerticalSectors()
end

function ENT:GetSectorPos(vec)
    local x, y = self:GetUniversePos(vec)
    return math.floor(x) + 0.5, math.floor(y) + 0.5
end

function ENT:GetSectorIndex(x, y)
    local xi, yi = self:WrapCoordinates(math.floor(x), math.floor(y))
    return xi + yi * self:GetHorizontalSectors() + 1, xi, yi
end

function ENT:GetSector(x, y)
    local sector, xi, yi = self._sectors[self:GetSectorIndex(x, y)]

    if not sector then
        sector = Sector(self, xi, yi)
    end

    return sector
end

function ENT:InitPostEntity()
    for x = 0, self:GetHorizontalSectors() - 1 do
        for y = 0, self:GetVerticalSectors() - 1 do
            local sector = ents.Create("info_ff_sector")
            local index, xi, yi = self:GetSectorIndex(x, y)
            sector:SetCoordinates(xi, yi)
            sector:SetPos(self:GetWorldPos(xi + 0.5, yi + 0.5))
            -- print(sector:GetSectorName() .. ": " .. tostring(sector:GetPos()))
            sector:Spawn()
            self._sectors[index] = sector
        end
    end

    universe = self
end

function ENT:_UpdateNWData()
    SetGlobalTable("universe", self._nwdata)
end
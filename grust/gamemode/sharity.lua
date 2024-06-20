local meta = FindMetaTable("Player")
function meta:HasEnoughVood(amt)
    print(self:GetNWFloat("wood", 0))
    local wood = self:GetNWFloat("wood", 0) >= amt or 0
    return wood
end

function meta:GetEnoughVood()
    return math.Round(self:GetNWFloat("wood", 0))
end

function meta:SetEnoughVood(amt)
    return self:SetNWFloat("wood", self:GetNWFloat("wood", 0) + amt)
end

function meta:DeductVood(amt)
    return self:SetNWFloat("wood", self:GetNWFloat("wood", 0) - amt)
end

function meta:GetEnoughMetal()
    return math.Round(self:GetNWFloat("metal", 0))
end

function meta:SetEnoughMetal(amt)
    return self:SetNWFloat("metal", self:GetNWFloat("metal", 0) + amt)
end

function meta:DeductMetal(amt)
    return self:SetNWFloat("metal", self:GetNWFloat("metal", 0) - amt)
end

function meta:GetEnoughStone()
    return math.Round(self:GetNWFloat("stone", 0))
end

function meta:SetEnoughStone(amt)
    return self:SetNWFloat("stone", self:GetNWFloat("stone", 0) + amt)
end

function meta:DeductStone(amt)
    return self:SetNWFloat("stone", self:GetNWFloat("stone", 0) - amt)
end

function meta:GetEnoughSulfur()
    return math.Round(self:GetNWFloat("sulfur", 0))
end

function meta:SetEnoughSulfur(amt)
    return self:SetNWFloat("sulfur", self:GetNWFloat("sulfur", 0) + amt)
end

function meta:DeductSulfur(amt)
    return self:SetNWFloat("sulfur", self:GetNWFloat("sulfur", 0) - amt)
end
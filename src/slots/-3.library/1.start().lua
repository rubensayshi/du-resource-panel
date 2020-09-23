-- !DU: start()
local CONTAINER_VOLUME_MULTIPLIER = 1.0

if false then
    for key, id in pairs(core) do
        system.print("core: " .. key)
    end  
    
    for key, id in pairs(unit) do
        system.print("unit: " .. key)
    end  
end

function newResource(name, massPerLiter)
    local resource = {}
    resource.name = name
    resource.massPerLiter = massPerLiter
    
    return resource
end

-- global
resources = {
    hematite = newResource("Hematite", 5.04),
    coal = newResource("Coal", 2.7),
    bauxite = newResource("Bauxite", 2.7),
    quartz = newResource("Quartz", 2.65),
    iron = newResource("Iron", 7.85),
    carbon = newResource("Carbon", 2.7),
    aluminium = newResource("Aluminium", 2.7),
    silicon = newResource("Silicon", 2.7),
    steel = newResource("Steel", 8.05),
    silumin = newResource("Silumin", 2.7),
    alfe_alloy = newResource("Al-fe Alloy", 2.7),
    basic_screw = newResource("Basic Screw", 8.05),
    basic_pipe = newResource("Basic Pipe", 2.7),
    basic_hydraulics = newResource("Basic Hydraulics", 2.7),
}
resourceKeyCache = {}

function makeResourceKey(name)
    return name:lower():gsub(" ", "_"):gsub("-", "")
end

function findResource(name)
    local knownResourceKey = resourceKeyCache[makeResourceKey(name)]
    if knownResourceKey ~= nil then
        return resources[knownResourceKey]
    end

    local findResourceKey = makeResourceKey(name)
    local tryKeys = {
        makeResourceKey(name),
        trimSuffix(findResourceKey, "s"),
        trimPrefix(findResourceKey, "pure_")
    }

    for k, tryKey in ipairs(tryKeys) do
        for resourceKey, resource in pairs(resources) do
            if startsWith(resourceKey, tryKey) or startsWith(tryKey, resourceKey) then
                resourceKeyCache[findResourceKey] = resourceKey

                return resource
            end
        end
    end

    return nil
end

function newContainer(id, name)
    system.print("newContainer: " .. name)

    local resource = findResource(name)
    local containerType = nil
    if resource ~= nil then
        local hp = core.getElementMaxHitPointsById(id)
        containerType = guessContainerTypeByHp(hp)
    end
    
    return {
        id = id,
        name = name,
        resource = resource,
        containerType = containerType,
    }
end

function guessContainerTypeByMass(mass, massPerLiter)
    -- @TODO: DELETE, DEPRECATED

    for k, containerType in pairs(containerTypes) do
        local contentMass = mass - containerType.mass
        if contentMass % massPerLiter < 0.01 then
            return containerType
        end
    end

    for k, containerType in ipairs(containerTypesAsc) do
        -- skip the first, XS is very unlikely to be used ...
        if k > 1 then
            local liters = math.floor(mass / massPerLiter)
            if containerType.liters >= liters then
                return containerType
            end
        end
    end

    -- default to S, should be impossible?
    return containerTypes.S
end

function newContainerType(name, mass, volume, hp)
    local containerType = {
    	name= name,
        mass = mass,
        volume = volume * CONTAINER_VOLUME_MULTIPLIER,
        hp = hp,
    }
    return containerType
end

-- global
-- @TODO: are these really tbe base HP?
containerTypes = {
    XS = newContainerType("XS", 229.09, 1000, 124),
    S = newContainerType("S", 1281.31, 8000, 999),
    M = newContainerType("M", 7421.35, 64000, 7997),
    L = newContainerType("L", 14842.7, 128000, 17316),
}
-- global
containerTypesByHPDesc = {}
for k, v in pairs(containerTypes) do
    containerTypesByHPDesc[#containerTypesByHPDesc + 1] = v
end
table.sort(containerTypesByHPDesc, function(a, b) return a.hp > b.hp end)

function guessContainerTypeByHp(hp)
    for i, containerType in ipairs(containerTypesByHPDesc) do
        if hp >= containerType.hp then
            return containerType
        end
    end

    return nil
end

function findAllContainers()
    system.print("findAllContainers")
    
    local containers = {}

    for k, id in pairs(core.getElementIdList()) do
        if core.getElementTypeById(id) == "container" then
            local container = newContainer(id, core.getElementNameById(id))
            
            if container.resource ~= nil then
            	containers[#containers + 1] = container
            end
        end
    end
    
    return containers
end

local containers = findAllContainers()

-- global
refreshContainers = function() containers = findAllContainers() end

-- global
getContainers = function() return containers end

-- global
getContainersByResource = function()
    local containersByResource = {}

    for k, container in ipairs(containers) do
        if container.resource ~= nil then
            local resourceKey = container.resource.name:lower()

            if containersByResource[resourceKey] == nil then
                containersByResource[resourceKey] = {}
            end

            containersByResource[resourceKey][#containersByResource[resourceKey] + 1] = container
        end
    end

    return containersByResource
end

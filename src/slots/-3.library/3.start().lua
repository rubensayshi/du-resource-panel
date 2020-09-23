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

local resources = {
    hematite = newResource("Hematite", 6.5),
    coal = newResource("Coal", 2.7),
}
library["resources"] = resources

function newContainer(id, name)
    system.print("newContainer: " .. name)
    
    -- local containerType = determineContainerType(container)

    local resource = resources[name:lower()]
    if resource ~= nil then
        system.print("container with resource: " .. resource.name)
    end
    
    return {
        id = id,
        name = name,
        resource = resource,
    }
end

function newContainerType(name, mass, volume)
    local containerType = {
    	name= name,
        mass = mass,
        volume = volume * CONTAINER_VOLUME_MULTIPLIER,
    }
    return containerType
end

local containerTypes = {
    XS = newContainerType("XS", 229.09, 1000),
    S = newContainerType("S", 1281.31, 8000),
    M = newContainerType("M", 7421.35, 64000),
    L = newContainerType("L", 14842.7, 128000),
}
local containerTypesDesc = {}
for k, v in pairs(containerTypes) do
    containerTypesDesc[#containerTypesDesc + 1] = v
end
table.sort(containerTypesDesc, function(a, b) return a.mass > b.mass end)

function determineContainerType(container)
    if container.duObj ~= nil then
        container = container.duObj
    end
--    system.print("determineContainerType: " .. type(container) .. ", " .. type(container.getSelfMass)) 
   
    local mass = container.getSelfMass()
    for i, containerType in ipairs(containerTypesDesc) do
        if containerType.mass <= mass then
	        return containerType
        end
    end
end

function initContainer()
    system.print("getContainers")
    
    local containers = {}

    -- if false then
    for k, id in pairs(core.getElementIdList()) do
        if core.getElementTypeById(id) == "container" then
            local container = newContainer(id, core.getElementNameById(id))
            
            if container.resource ~= nil then
            	containers[#containers + 1] = container
            end
        end
    end 
    -- end
--    for key, value in pairs(resources) do
--        system.print("resource: " .. key)
--    end
    
    
    if false then
        for key, value in pairs(unit) do        
            -- detect if it's an object
            if type(value) == "table" and type(value.export) == "table" then
                -- detect if it's an container
                if value.getSelfMass ~= nil then
                    local name = core.getElementNameById(value.getId())
                    containers[#containers + 1] = newContainer(key, name, value)
                end
            end
        end
    end
    
    return containers
end

local containers = initContainer()

library.getContainers = function() return containers end

library.getContainersByResource = function() 
    local containersByResource = {}
    for k, container in ipairs(containers) do
        if container.resource ~= nil then
            containersByResource[container.resource.name:lower()] = container
        end
    end
    return containersByResource
end

library["init"] = function()
end


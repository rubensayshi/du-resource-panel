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

    -- return resources[findResourceKey]

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
    local resource = findResource(name)
    local hp = core.getElementMaxHitPointsById(id)
    local containerType = guessContainerTypeByHp(hp)

    return {
        id = id,
        name = name,
        resource = resource,
        containerType = containerType,
    }
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

local containers = {}
local containersByResource = {}
local notAContainer = {}
function refreshContainers(ids)
    for k, id in ipairs(ids) do
        if notAContainer[id] == nil then
            if containers[id] == nil then
                -- new container
                if core.getElementTypeById(id) == "container" then
                    local container = newContainer(id, core.getElementNameById(id))
                    containers[id] = container

                    setContainerByResource(container)
                else
                    notAContainer[id] = true
                end
            else
                -- update 
                local container = containers[id]
                local name = core.getElementNameById(id)

                -- check if name was changed
                if name ~= container.name then
                    container.name = name
                    container.resource = findResource(name)

                    setContainerByResource(container)
                end
            end
        end
    end
end

function setContainerByResource(container)
    if container.resource ~= nil then
        local resourceKey = container.resource.name:lower()

        if containersByResource[resourceKey] == nil then
            containersByResource[resourceKey] = {}
        end

        containersByResource[resourceKey][container.id] = container
    end
end

function getContainers() 
    return containers 
end

function getContainersByResource() 
    return containersByResource 
end

REFRESH_PAYLOAD_SIZE = 1
local work = {}

function queueRefreshContainers()
    ids = core.getElementIdList()

    system.print("queueRefreshContainers: " .. #ids)

    local payload = {}
    for i = 1, #ids do
        payload[#payload + 1] = ids[i]

        if #payload >= REFRESH_PAYLOAD_SIZE then
            table.insert(work, {
                workType = "refreshContainers",
                payload = payload,
            })
        end
    end

    if #payload > 0 then
        table.insert(work, {
            workType = "refreshContainers",
            payload = payload,
        })
    end

    table.insert(work, {
        workType = "queueRefreshContainers",
    })

    return #work
end

function refresh()
    system.print("work: " .. #work)

    if #work > 0 then
        local job = table.remove(work, 1)

        if job.workType == "refreshContainers" then
            refreshContainers(job.payload)
        elseif job.workType == "queueRefreshContainers" then
            queueRefreshContainers()
        else
            -- unknown job type
        end
    else
        -- wtf no work?
    end
end
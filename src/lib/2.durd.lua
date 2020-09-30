-- !DU: start()

-- this could be set to some value affected by talents, but we're not using it atm ...
local CONTAINER_VOLUME_MULTIPLIER = 1.0

function newContainerType(name, mass, volume, hp)
    local containerType = {
        name= name,
        mass = mass,
        volume = volume * CONTAINER_VOLUME_MULTIPLIER,
        hp = hp,
    }
    return containerType
end

-- @TODO: are these really tbe base HP?
containerTypes = {
    XS = newContainerType("XS", 229.09, 1000, 124),
    S = newContainerType("S", 1281.31, 8000, 999),
    M = newContainerType("M", 7421.35, 64000, 7997),
    L = newContainerType("L", 14842.7, 128000, 17316),
}
containerTypesByHPDesc = {}
for k, v in pairs(containerTypes) do
    containerTypesByHPDesc[#containerTypesByHPDesc + 1] = v
end
table.sort(containerTypesByHPDesc, function(a, b) return a.hp > b.hp end)

-- we can guess the container type by its HP value
function guessContainerTypeByHp(hp)
    for i, containerType in ipairs(containerTypesByHPDesc) do
        if hp >= containerType.hp then
            return containerType
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

local containers = {}
local containersByResource = {}
local notAContainer = {}
function refreshContainerContents(ids)
    for k, id in ipairs(ids) do
        -- skip any ids explicitly marked as not being an container 
        if notAContainer[id] == nil then
            if containers[id] == nil then
                -- new object, maybe a container?
                if core.getElementTypeById(id) == "container" then
                    local container = newContainer(id, core.getElementNameById(id))
                    containers[id] = container

                    -- add it to the containersByResource
                    setContainerByResource(container)
                else
                    notAContainer[id] = true
                end
            else
                -- update 
                local container = containers[id]
                local name = core.getElementNameById(id)

                -- check if name of the container was changed, otherwise ignore
                if name ~= container.name then
                    -- remove if it had a resource already
                    removeContainerByResource(container)

                    container.name = name
                    container.resource = findResource(name)

                    -- add it to the containersByResource
                    setContainerByResource(container)
                end
            end
        end
    end
end

function setContainerByResource(container)
    if container.resource ~= nil then
        if containersByResource[container.resource.key] == nil then
            containersByResource[container.resource.key] = {}
        end

        containersByResource[container.resource.key][container.id] = container
    end
end

function removeContainerByResource(container)
    if container.resource ~= nil then
        containersByResource[container.resource.key][container.id] = nil
    end
end

function getContainers() 
    return containers 
end

function getContainersByResource() 
    return containersByResource 
end

-- REFRESH_PAYLOAD_SIZE controls how many containers we'll refresh per tick 
REFRESH_PAYLOAD_SIZE = 50
-- our work queue
local work = {}

function queueRefreshContainers()
    local ids = core.getElementIdList()

    -- pop jobs off the ids list and enqueue work
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

    -- queue any remainder
    if #payload > 0 then
        table.insert(work, {
            workType = "refreshContainers",
            payload = payload,
        })
    end

    -- finally queue a job to rebuild the queue
    table.insert(work, {
        workType = "queueRefreshContainers",
    })
    -- and to slow down the tick rate
    table.insert(work, {
        workType = "slowdownRefreshTimer",
    })

    return #work
end

function slowdownRefreshTimer()
    local numOfElements = #core.getElementIdList()
    local jobsForFullRefresh = numOfElements / REFRESH_PAYLOAD_SIZE
    local refreshTickRate = math.max(math.ceil(60 / jobsForFullRefresh), 1)

    system.print("jobsForFullRefresh: " .. jobsForFullRefresh .. " refreshTickRate: " .. refreshTickRate)

    -- stop old timer
    unit.stopTimer("refresh")
    -- start throttled timer
    unit.setTimer("refresh", refreshTickRate)
end

function workRefreshQueue()
    if #work > 0 then
        -- pop a job
        local job = table.remove(work, 1)

        -- and work it
        if job.workType == "refreshContainers" then
            refreshContainerContents(job.payload)
        elseif job.workType == "queueRefreshContainers" then
            queueRefreshContainers()
        elseif job.workType == "slowdownRefreshTimer" then
            slowdownRefreshTimer()
        else
            -- unknown job type
        end
    else
        -- err no work?
    end
end
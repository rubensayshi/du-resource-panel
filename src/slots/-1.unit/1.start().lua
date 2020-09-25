-- !DU: start()

local numOfContainers = queueRefreshContainers()

local jobsForFullRefresh = numOfContainers / REFRESH_PAYLOAD_SIZE
local refreshTickRate = math.max(math.ceil(60 / jobsForFullRefresh), 1)

system.print("jobsForFullRefresh: " .. jobsForFullRefresh .. " refreshTickRate: " .. refreshTickRate)

unit.setTimer("refresh", refreshTickRate)
unit.setTimer("redraw", 10)

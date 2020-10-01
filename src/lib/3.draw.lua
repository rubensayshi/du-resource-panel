-- !DU: start()

local drawScreen = nil
if screen ~= nil then
    drawScreen = screen
end
if drawScreen == nil and screen1 ~= nil then
    drawScreen = screen1
end
if drawScreen == nil then
    drawScreen = findFirstElementOfType("Screen")
end
if drawScreen == nil then
    system.print("ERROR: There's no screen linked! Some LUA errors will follow ...")
end

local DISPLAY_CONTAINERS = true
local DISPLAY_TIERS = {1, 2}

-- set later, for readability
local DRAW_RULER
local DRAW_HTML_START
local DRAW_HTML_END
local DRAW_HTML_TABLE_START1
local DRAW_HTML_TABLE_START2
local DRAW_HTML_TABLE_END

function drawResourceDisplay()
    local containersByResource = getContainersByResource()

    local data = {}
    for k, tier in ipairs(DISPLAY_TIERS) do
        data[tier] = {}

        for cat, resourcesInCat in pairs(resourcesForDisplay[tier]) do
            data[tier][cat] = {}

            for k, resource in pairs(resourcesInCat) do
                local containers = containersByResource[resource.key]
                if containers ~= nil then
                    local status = "OK"
                    local statusStyle = "color: green;"

                    local totalVolume = 0
                    local totalContainers = ""
                    local totalAvailableVolume = 0

                    for i, container in pairs(containers) do
                        local containerType = container.containerType

                        local mass = core.getElementMassById(container.id)
                        mass = mass - containerType.mass

                        local volume = math.floor(mass / resource.massPerLiter)

                        totalVolume = totalVolume + volume
                        totalAvailableVolume = totalAvailableVolume + containerType.volume
                        totalContainers = totalContainers .. ", " .. containerType.name
                    end

                    -- strip trailing ", "
                    if totalVolume > 0 then
                        totalContainers = totalContainers:sub(3)
                    end

                    if totalVolume <= 2000 then
                        status = "LOW"
                        statusStyle = "color: red;"
                    end

                    local displayName = item
                    if DISPLAY_CONTAINERS then
                        displayName = resource.name .. "[" .. totalContainers .. "]"
                    end

                    data[tier][cat][resource.key] = {
                        name = displayName,
                        volume = totalVolume,
                        availableVolume = totalAvailableVolume,
                        status = status,
                        statusStyle = statusStyle,
                    }
                else
                    data[tier][cat][resource.key] = {
                        name = resource.name,
                        volume = 0,
                        availableVolume = 0,
                        status = "NaN",
                        statusStyle = "color: orange;",
                    }
                end
            end
        end
    end

    local body = ""


    for k, tier in ipairs(DISPLAY_TIERS) do
        body = body .. DRAW_HTML_TABLE_START1 .. "T" .. tier .. DRAW_HTML_TABLE_START2

        for c, cat in ipairs(categories) do
            local resourcesInCat = resourcesForDisplay[tier][cat]

            for k, resource in pairs(resourcesInCat) do
                local resourceInfo = data[tier][cat][resource.key]
                --local percentage = math.ceil(resourceInfo.volume / resourceInfo.availableVolume)

                body = body .. [[
    	     <tr>
    			<td style="overflow: hidden;  text-overflow: ellipsis; white-space: nowrap;">]] .. resourceInfo.name .. [[</td>
    			<td style="]] .. resourceInfo.statusStyle .. [[">]] .. resourceInfo.volume .. [[L</td>
    		</tr>]]
            end

            body = body .. DRAW_RULER
        end

        body = body .. DRAW_HTML_TABLE_END
    end

    drawScreen.setHTML(DRAW_HTML_START .. body .. DRAW_HTML_END)
end

DRAW_HTML_START = [[<div class="bootstrap">]]
DRAW_HTML_END = [[</div>]]

DRAW_RULER = [[<tr><td colspan=2><hr /></td></tr>]]

DRAW_HTML_TABLE_START1 = [[
<div style="width: 50%; float: left;">
<h1 style="font-size: 4em;">]]

DRAW_HTML_TABLE_START2 = [[</h1>
<table style="
	margin-top: 5px;
	margin-left: auto;
	margin-right: auto;
	font-size: 1.5em;
    width: 100%;
">
	<tr style="
		margin-bottom: 30px;
		background-color: blue;
		color: white;
	">
		<th width="80%">Resource</th>
		<th width="20%">Levels</th>
     </tr>
]]

DRAW_HTML_TABLE_END = [[
</table>
</div>
]]

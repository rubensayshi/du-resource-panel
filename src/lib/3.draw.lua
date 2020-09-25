-- !DU: start()

local DISPLAY_CONTAINERS = true

local tier1 = {
    ores = {"bauxite", "coal", "hematite", "quartz"},
    refined = {"pure_aluminium", "pure_carbon", "pure_iron", "pure_silicon"},
    alloys = {"steel", "silumin", "alfe_alloy"},
    metalworks = {"basic_screw", "basic_pipe", "basic_hydraulics"},
}
local cats = {"ores", "refined", "alloys", "metalworks"}

-- set later, for readability
local DRAW_RULER
local DRAW_HTML_START
local DRAW_HTML_END

function drawResourceDisplay()
    local containersByResource = getContainersByResource()

    local resourcesInfo = {}
    for k, cat in ipairs(cats) do
        items = tier1[cat]
        resourcesInfo[cat] = {}

        for k, item in pairs(items) do
            local containers = containersByResource[item]
            if containers ~= nil then
                local status = "OK"
                local statusStyle = "color: green;"
                local resource = containers[1].resource

                local totalVolume = 0
                local totalContainers = ""

                for i, container in ipairs(containers) do
                    local containerType = container.containerType

                    local mass = core.getElementMassById(container.id)
                    mass = mass - containerType.mass

                    local volume = math.floor(mass / resource.massPerLiter)

                    totalVolume = totalVolume + volume
                    totalContainers = totalContainers .. ", " .. containerType.name
                end

                if totalVolume > 0 then
                    totalContainers = totalContainers:sub(3)
                end

                if totalVolume <= 2000 then
                    status = "LOW"
                    statusStyle = "color: red;"
                end

                local displayName = item
                if DISPLAY_CONTAINERS then
                    displayName = item .. "[" .. totalContainers .. "]"
                end

                resourcesInfo[cat][item] = {
                    name = displayName,
                    volume = totalVolume,
                    status = status,
                    statusStyle = statusStyle,
                }
            else
                resourcesInfo[cat][item] = {
                    name = item,
                    volume = 0,
                    status = "NaN",
                    statusStyle = "color: orange;",
                }
            end
        end
    end

    local body = ""


    for k, cat in ipairs(cats) do
        items = tier1[cat]
        for k, item in pairs(items) do
            local resourceInfo = resourcesInfo[cat][item]

            body = body .. [[
	     <tr>
			<td colspan=2>]] .. resourceInfo.name .. [[</td>
			<td style="]] .. resourceInfo.statusStyle .. [[">]] .. resourceInfo.volume .. [[L</td>
		</tr>]]
        end

        body = body .. DRAW_RULER
    end

    screen1.setHTML(DRAW_HTML_START .. body .. DRAW_HTML_END)
end

DRAW_RULER = [[<tr><td colspan=3><hr /></td></tr>]]

DRAW_HTML_START = [[
<div class="bootstrap">
<h1 style="font-size: 5em;">T1 Ore & Pure Status</h1>
<table style="
	margin-top: 5px;
	margin-left: auto;
	margin-right: auto;
	width: 80%;
	font-size: 2em;
">
	<tr style="
		width: 100%;
		margin-bottom: 30px;
		background-color: blue;
		color: white;
	">
		<th>Resource</th>
		<th></th>
		<th>Levels</th>
     </tr>
]]

DRAW_HTML_END = [[
</table>
</div>
]]

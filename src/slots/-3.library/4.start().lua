-- !DU: start()

local tier1 = {
	ores = {"bauxite", "coal", "hematite", ""},
	refined = {"aluminium", "carbon", "iron", ""},
	alloys = {"steel", "silumin", "al-fe alloy"},
	metalworks = {"basic screw", "basic pipe", "basic hydraulics"},
}

library.draw = function()    
	local containers = library.getContainersByResource()

	local resourcesInfo = {}
	for t, items in pairs(tier1) do
		resourcesInfo[t] = {}

		for k, item in pairs(items) do
			local container = containers[item]
			if container ~= nil then
		        local status = "OK"
		        local statusStyle = "color: green;" 
		        local mass = core.getElementMassById(container.id)
		        local resource = container.resource
		        local volume = math.floor(mass / resource.massPerLiter)
		        if volume <= 2000 then
		        	status = "LOW"
		        	statusStyle = "color: red;"
		        end

				resourcesInfo[t][item] = {
					name = item,
					volume = volume,
					status = status,
					statusStyle = statusStyle,
				}
			else
				resourcesInfo[t][item] = {
					name = item,
					volume = 0,
					status = "NaN",
					statusStyle = "color: orange;",
				}
			end	
		end
	end
    
    local body = ""


	for t, items in pairs(tier1) do
		for k, item in pairs(items) do
			local resourceInfo = resourcesInfo[t][item]

	        body = body .. [[
	     <tr>
			<td>]] .. resourceInfo.name .. [[</td>
			<td style="]] .. resourceInfo.statusStyle .. [[">]] .. resourceInfo.volume .. [[L</td>
		</tr>]]
		end
	end

    screen1.setHTML(library.DRAW_HTML_START .. body .. library.DRAW_HTML_END)
end


library.DRAW_HTML_START = [[
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

library.DRAW_HTML_END = [[
</table>
</div>
]]
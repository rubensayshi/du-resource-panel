-- !DU: start()
system.print("listing containers ... " .. #getContainers())

for _, container in ipairs(getContainers()) do
	local resource = ""
	if container.resource ~= nil then
		resource = container.resource.name
	end
    system.print("container:" .. container.name .. ": " .. resource .. ": " .. core.getElementMassById(container.id))
end

drawResourceDisplay()

unit.setTimer("redraw", 10)
unit.setTimer("refresh", 60)

system.print("start done")


-- !DU: start()
library.init()

system.print("listing containers ... " .. #getContainers())

for _, container in ipairs(getContainers()) do
	local resource = ""
	if container.resource ~= nil then
		resource = container.resource.name
	end
    system.print("container:" .. container.name .. ": " .. resource .. ": " .. core.getElementMassById(container.id))
end

drawResourceDisplay()

system.print("start done")

unit.exit()

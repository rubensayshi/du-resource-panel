-- !DU: start()
library.init()

system.print("listing containers ... " .. #library.getContainers())

for _, container in ipairs(library.getContainers()) do
	local resource = ""
	if container.resource ~= nil then
		resource = container.resource.name
	end
    system.print("container:" .. container.name .. ": " .. resource .. ": " .. core.getElementMassById(container.id))
end

library.draw()

system.print("start done")

unit.exit()
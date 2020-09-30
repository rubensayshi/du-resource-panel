-- !DU: start()

queueRefreshContainers()

unit.setTimer("refresh", 1)
unit.setTimer("redraw", 3)

-- draw instantly, to set everything to 0
drawResourceDisplay()
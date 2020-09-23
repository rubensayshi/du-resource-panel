-- !DU: start()
library.startsWith = function(str, start)
   return str:sub(1, #start) == start
end

library.round = function(number, decimals)
    local power = 10 ^ decimals
    return math.floor((number/1000) * power) / power
end

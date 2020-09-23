-- !DU: start()
function startsWith(str, start)
   return str:sub(1, #start) == start
end

function round(number, decimals)
    local power = 10 ^ decimals
    return math.floor((number/1000) * power) / power
end

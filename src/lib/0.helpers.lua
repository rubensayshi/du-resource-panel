function startsWith(str, start)
    return str:sub(1, #start) == start
end

function trimSuffix(str, suffix)
    if #str < #suffix then
        return str
    end

    if str:sub(-#suffix) == suffix then
        return str:sub(1, -#suffix - 1)
    else
        return str
    end
end

function trimPrefix(str, prefix)
    if #str < #prefix then
        return str
    end

    if str:sub(1, #prefix) == prefix then
        return str:sub(#prefix + 1)
    else
        return str
    end
end

function round(number, decimals)
    local power = 10 ^ decimals
    return math.floor((number/1000) * power) / power
end

function findFirstElementOfType(findType)
    -- `value` is an element and `key` is the slot name
    for key, value in pairs(unit) do
        if type(value) == "table" and type(value.export) == "table" then
            if value.getElementClass then
                if value.getElementClass() == findType then
                    return value
                end
            end
        end
    end
end

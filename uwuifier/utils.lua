local utils = {}

function utils.split(str, delimiter)
    local result = {}
    local pattern = string.format("([^%s]+)", delimiter)
    str:gsub(pattern, function(c) result[#result + 1] = c end)
    return result
end

function utils.isUri(word)
    return string.match(word, "^https?://")
end

function utils.getCapitalPercentage(str)
    local totalChars = #str
    local uppercaseChars = str:gsub("[^A-Z]", "")
    return #uppercaseChars / totalChars
end

return utils

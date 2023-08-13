local DEFAULTS = {
    SPACES = {
        faces = 0.05,
        actions = 0.075,
        stutters = 0.1
    },
    WORDS = 1,
    EXCLAMATIONS = 1
}

local Uwuifier = {}
Uwuifier.__index = Uwuifier

function Uwuifier:new(config)
    config = config or {}
    local spaces = config.spaces or DEFAULTS.SPACES
    local words = config.words or DEFAULTS.WORDS
    local exclamations = config.exclamations or DEFAULTS.EXCLAMATIONS

    local instance = {
        _spacesModifier = spaces,
        _wordsModifier = words,
        _exclamationsModifier = exclamations,
        faces = {
            "(・`ω´・)",
            ";;w;;",
            "OwO",
            "UwU",
            ">w<",
            "^w^",
            "ÚwÚ",
            "^-^",
            ":3",
            "x3"
        },
        exclamations = {
            "!?",
            "?!!",
            "?!?1",
            "!!11",
            "?!?!"
        },
        actions = {
            "*blushes*",
            "*whispers to self*",
            "*cries*",
            "*screams*",
            "*sweats*",
            "*twerks*",
            "*runs away*",
            "*screeches*",
            "*walks away*",
            "*sees bulge*",
            "*looks at you*",
            "*notices buldge*",
            "*starts twerking*",
            "*huggles tightly*",
            "*boops your nose*"
        },
        uwuMap = {
            { "(r)", "w" },
            { "(l)", "w" },
            { "(R)", "W" },
            { "(L)", "W" },
            { "n([aeiou])", "ny%1" },
            { "N([aeiou])", "Ny%1" },
            { "N([AEIOU])", "Ny%1" },
            { "ove", "uv" }
        }
    }
    setmetatable(instance, self)
    return instance
end

function Uwuifier:uwuifyWords(sentence)
    local words = {}
    for word in sentence:gmatch("%S+") do
        local shouldUwuify = math.random() <= self._wordsModifier
        if not shouldUwuify then
            table.insert(words, word)
        else
            local uwuWord = word
            for _, mapping in pairs(self.uwuMap) do
                local oldWord, newWord = mapping[1], mapping[2]

                uwuWord = uwuWord:gsub(oldWord, newWord)
            end
            table.insert(words, uwuWord)
        end
    end
    return table.concat(words, " ")
end

function Uwuifier:uwuifySpaces(sentence)
    local words = {}
    local wordList = utils.split(sentence, " ")
    local faceThreshold = self._spacesModifier.faces
    local actionThreshold = self._spacesModifier.actions + faceThreshold
    local stutterThreshold = self._spacesModifier.stutters + actionThreshold

    local function checkCapital(word, firstCharacter, i, wordList)
        if firstCharacter:upper() ~= firstCharacter then
            return word
        end

        local capitalPercentage = utils.getCapitalPercentage(word)
        if capitalPercentage > 0.5 then
            return word
        end

        if i == 1 then
            return firstCharacter:lower() .. word:sub(2)
        else
            local prevWord = wordList[i - 1]
            local prevLastChar = prevWord:sub(#prevWord)
            local prevEndsWithPunctuation = string.match(prevLastChar, "[.!?\\-]")

            if not prevEndsWithPunctuation then
                return word
            end

            return firstCharacter:lower() .. word:sub(2)
        end
    end

    for i, word in ipairs(wordList) do
        local random = math.random()
        local firstCharacter = word:sub(1, 1)
        
        if random <= faceThreshold and #self.faces > 0 then
            word = word .. " " .. self.faces[math.random(1, #self.faces)]
            word = checkCapital(word, firstCharacter, i, wordList)
        elseif random <= actionThreshold and #self.actions > 0 then
            word = word .. " " .. self.actions[math.random(1, #self.actions)]
            word = checkCapital(word, firstCharacter, i, wordList)
        elseif random <= stutterThreshold and not utils.isUri(word) then
            local stutter = math.random(0, 2)
            word = (firstCharacter .. "-"):rep(stutter) .. word
        end

        table.insert(words, word)
    end

    return table.concat(words, " ")
end


function Uwuifier:uwuifyExclamations(sentence)
    local words = {}
    local wordList = utils.split(sentence, " ")
    local pattern = "[?!]+$"

    for _, word in ipairs(wordList) do

        if not string.match(word, pattern) or math.random() > self._exclamationsModifier then
            table.insert(words, word)
        else
            word = word:gsub(pattern, "")
            word = word .. self.exclamations[math.random(1, #self.exclamations)]
            table.insert(words, word)
        end
    end

    return table.concat(words, " ")
end

function Uwuifier:uwuifySentence(sentence)
    local uwuifiedString = sentence
    uwuifiedString = self:uwuifyWords(uwuifiedString)
    uwuifiedString = self:uwuifyExclamations(uwuifiedString)
    uwuifiedString = self:uwuifySpaces(uwuifiedString)
    return uwuifiedString
end
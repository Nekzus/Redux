local methods = {}
local metatable = {}

function metatable:__index(key)
	return rawget(methods, key)
end

function metatable:__call(key)
	return setmetatable({
		key = key or newKey(),
	}, metatable)
end

local function encrypt(text, key)
    local keyBytes

    if type(key) == "string" then
        keyBytes = {}

        for keyIndex = 1, #key do
            keyBytes[keyIndex] = string.byte(key, keyIndex)
        end
    else
        keyBytes = key
    end

    local textLength = #text
    local keyLength = #keyBytes
    local textBytes = {}

    for textIndex = 1, textLength do
        textBytes[textIndex] = string.byte(text, textIndex)
    end

    local resultBytes = {}
    local randomSeed = 0

    for keyIndex = 1, keyLength do
        randomSeed = (randomSeed + keyBytes[keyIndex] * keyIndex) * 1103515245 + 12345
        randomSeed = (randomSeed - randomSeed % 65536) / 65536% 4294967296
    end

    for textIndex = 1, textLength do
        local textByte = textBytes[textIndex]

        for keyIndex = 1, keyLength do
            local keyByte = keyBytes[keyIndex]
            local resultIndex = textIndex + keyIndex -1
            local resultByte = textByte + (resultBytes[resultIndex] or 0)

            if resultByte > 255 then
                resultByte = resultByte - 256
            end

            resultByte = resultByte + keyByte

            if resultByte > 255 then
                resultByte = resultByte - 256
            end

            randomSeed = (randomSeed % 4194304 * 1103515245 + 12345)
            resultByte = resultByte + (randomSeed - randomSeed % 65536) / 65536 % 256

            if resultByte > 255 then
                resultByte = resultByte - 256
            end

            resultBytes[resultIndex] = resultByte
        end
    end

    local resultBuffer = {}
    local resultBufferIndex = 1

    for resultIndex = 1, #resultBytes do
        local resultByte = resultBytes[resultIndex]

        resultBuffer[resultBufferIndex] = string.format("%02x", resultByte)
        resultBufferIndex = resultBufferIndex + 1
    end

    return table.concat(resultBuffer)
end

local function decrypt(cipher, key)
    local keyBytes

    if type(key) == "string" then
        keyBytes = {}

        for keyIndex = 1, #key do
            keyBytes[keyIndex] = string.byte(key, keyIndex)
        end
    else
        keyBytes = key
    end

    local cipherRawLength = #cipher
    local keyLength = #keyBytes
    local cipherBytes = {}
    local cipherLength = 0
    local cipherBytesIndex = 1

    for byteStr in string.gmatch(cipher, "%x%x") do
        cipherLength = cipherLength + 1
        cipherBytes[cipherLength] = tonumber(byteStr, 16)
    end

    local randomBytes = {}
    local randomSeed = 0

    for keyIndex = 1, keyLength do
        randomSeed = (randomSeed + keyBytes[keyIndex] * keyIndex) * 1103515245 + 12345
        randomSeed = (randomSeed - randomSeed % 65536) / 65536% 4294967296
    end

    for randomIndex = 1, (cipherLength - keyLength + 1) * keyLength do
        randomSeed = (randomSeed % 4194304 * 1103515245 + 12345)
        randomBytes[randomIndex] = (randomSeed - randomSeed % 65536) / 65536 % 256
    end

    local randomIndex = #randomBytes
    local lastKeyByte = keyBytes[keyLength]
    local resultBytes = {}

    for cipherIndex = cipherLength, keyLength, -1 do
        local resultByte = cipherBytes[cipherIndex] - lastKeyByte

        if resultByte < 0 then
            resultByte = resultByte + 256
        end

        resultByte = resultByte - randomBytes[randomIndex]
        randomIndex = randomIndex -1

        if resultByte < 0 then
            resultByte = resultByte + 256
        end

        for keyIndex = keyLength -1, 1, -1 do
            cipherIndex = cipherIndex -1

            local cipherByte = cipherBytes[cipherIndex] - keyBytes[keyIndex]

            if cipherByte < 0 then
                cipherByte = cipherByte + 256
            end

            cipherByte = cipherByte - resultByte

            if cipherByte < 0 then
                cipherByte = cipherByte + 256
            end

            cipherByte = cipherByte - randomBytes[randomIndex]
            randomIndex = randomIndex -1

            if cipherByte < 0 then
                cipherByte = cipherByte + 256
            end

            cipherBytes[cipherIndex] = cipherByte
        end

        resultBytes[cipherIndex] = resultByte
    end

    local resultCharacters = {}

    for resultIndex = 1, #resultBytes do
        resultCharacters[resultIndex] = string.char(resultBytes[resultIndex])
    end

    return table.concat(resultCharacters)
end

function methods:encrypt(text)
	assert(self.key, "Must create object first")

	return encrypt(text, self.key)
end

function methods:decrypt(text)
	assert(self.key, "Must create object first")

	return decrypt(text, self.key)
end

function methods:setKey(text)
	assert(self.key, "Must create object first")

	self.key = text

	return self
end

whisper = setmetatable(methods, metatable)

return whisper

local afker = {}
local ConfigData = Config.Afk
local afkZones = {}

for i = 1, #ConfigData.Polyzones do
    afkZones[i] = lib.zones.poly({
        points = ConfigData.Polyzones[i].points,
        thickness = ConfigData.Polyzones[i].thickness,
        debug = ConfigData.Polyzones[i].debug,
    })
end

local function isPlayerInAnyZone(coords)
    for i = 1, #afkZones do
        local zone = afkZones[i]

        if zone:contains(coords) then
            return true
        end
    end

    return false
end

RegisterNetEvent('cy_afk:server:enter', function()
    local _source <const> = source
    
    if afker[_source] and not isPlayerInAnyZone(_source) then
        ConfigData.BanFunction(_source)
        return
    end

    afker[_source] = {
        startTime = os.time(),
        lastRewardTime = os.time(),
        totalMinutes = 0
    }
end)

RegisterNetEvent('cy_afk:server:leave', function()
    local _source <const> = source

    if not afker[_source] and not isPlayerInAnyZone(_source) then
        ConfigData.BanFunction(_source)
        return
    end

    afker[_source] = nil
end)

RegisterNetEvent('cy_afk:server:addReward', function()
    local _source <const> = source

    if not afker[_source] and not isPlayerInAnyZone(_source) then
        ConfigData.BanFunction(_source)
        return
    end

    local playerData = afker[_source]

    local currentTime = os.time()
    local timeDiff = currentTime - (playerData.lastRewardTime or playerData.startTime)

    if timeDiff < 30 then
        ConfigData.BanFunction(_source)
        afker[_source] = nil
        return
    end

    playerData.lastRewardTime = currentTime
    playerData.totalMinutes += ConfigData.Data.RewardMinutes

    local reward = ConfigData.Data.Reward.Min

    if ConfigData.Data.Reward.Random then
        math.randomseed(os.time())
        reward = math.random(ConfigData.Data.Reward.Min, ConfigData.Data.Reward.Max)
    end

    math.randomseed(os.time())
    local randomItem = ConfigData.Data.Reward.Items[math.random(1, #ConfigData.Data.Reward.Items)]

    if ConfigData.Data.RewardFor1Hour then
        if playerData.totalMinutes >= 60 then
            TriggerClientEvent('ox_lib:notify', _source, {
                title = 'AFK Zone',
                description = 'You getting reward for being AFK for 1 hour',
                type = 'success',
            })

            exports.ox_inventory:AddItem(_source, randomItem, reward)
        end
    end

    exports.ox_inventory:AddItem(_source, randomItem, reward)

    TriggerClientEvent('ox_lib:notify', _source, {
        title = 'AFK Zone',
        description = 'You got ' .. reward .. ' ' .. randomItem .. ' for being AFK',
        type = 'success',
    })
end)

AddEventHandler('playerDropped', function(source)
    if not afker[source] then
        return
    end

    afker[source] = nil
end)
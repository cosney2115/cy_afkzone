local ConfigData = Config.Afk
local isInside = false

local function disableCombat()
    Citizen.CreateThread(function()
        while isInside do
            SetEntityInvincible(cache.ped, true)
            SetPlayerInvincible(cache.playerId, true)
            SetEntityProofs(cache.ped, false, false, false, false, false, false, true, false)
            SetPedCanBeKnockedOffVehicle(cache.ped, 1)

            SetPedCanRagdoll(cache.ped, false)

            SetEntityCanBeDamaged(cache.ped, false)

            DisablePlayerFiring(cache.playerId, true)

            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 47, true)
            DisableControlAction(0, 58, true)
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 141, true)
            DisableControlAction(0, 142, true)
            DisableControlAction(0, 143, true)
            Citizen.Wait(0)
        end

        SetEntityInvincible(cache.ped, false)
        SetPlayerInvincible(cache.playerId, false)
        SetEntityProofs(cache.ped, false, false, false, false, false, false, false, false)
        SetPedCanBeKnockedOffVehicle(cache.ped, 0)
        SetPedCanRagdoll(cache.ped, true)
        SetEntityCanBeDamaged(cache.ped, true)
    end)
end

local function tick()
    Citizen.CreateThread(function()
        local startTime = GetGameTimer()

        while isInside do
            local currentTime = GetGameTimer()
            
            if currentTime - startTime >= 30000 then
                TriggerServerEvent('cy_afk:server:addReward')
                startTime = currentTime
            end

            Citizen.Wait(1000)
        end
    end)
end

function onEnter(self)
    if isInside then return end

    lib.notify({
        title = 'AFK Zone',
        description = 'You are now in AFK Zone u will get reward every 30 seconds',
        type = 'info',
    })

    isInside = true
    TriggerServerEvent('cy_afk:server:enter')
    tick()
    disableCombat()
end
 
function onExit(self)
    if not isInside then return end
    
    lib.notify({
        title = 'AFK Zone',
        description = 'You are now outside AFK Zone',
        type = 'error',
    })

    isInside = false
    TriggerServerEvent('cy_afk:server:leave')
end

for i = 1, #ConfigData.Polyzones do
    lib.zones.poly({
        points = ConfigData.Polyzones[i].points,
        thickness = ConfigData.Polyzones[i].thickness,
        debug = ConfigData.Polyzones[i].debug,
        onEnter = onEnter,
        onExit = onExit
    })
end

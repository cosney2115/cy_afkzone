local ConfigData = Config.Afk
local isInside = false

local function tick()
    Citizen.CreateThread(function()
        local startTime = GetGameTimer()

        while isInside do
            local currentTime = GetGameTimer()
            
            if currentTime - startTime >= 30000 then
                TriggerServerEvent('cy_afk:server:addReward')
                print('reward added')
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
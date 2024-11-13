Config = Config or {}

Config.Afk = {
    Polyzones = {
        {
            points = {
                vec3(2039.0, 3195.0, 44.0),
                vec3(2066.0, 3180.0, 44.0),
                vec3(2074.0, 3192.0, 44.0),
                vec3(2046.0, 3209.0, 44.0),
            },
            thickness = 5.0,
            debug = true,
        },
        {
            points = {
                vec3(2861.0, 2809.0, 30.0),
                vec3(2863.0, 2811.0, 30.0),
            },
            thickness = 100.0,
            debug = true,
        },
        -- More zones here
    },
    Data = {
        Radius = 50.0,
        RewardMinutes = 1,
        Location = vec3(2955.3525, 2784.8955, 41.2381),
        RewardFor1Hour = true,
        Reward = {
            Items = {
                'money',
            },
            Random = true,
            Min = 1000,
            Max = 2000,
        }
    },
    BanFunction = function(source)
        DropPlayer(source, 'Cheater')
    end
}
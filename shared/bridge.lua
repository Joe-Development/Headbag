Bridge = {}

local function tryLoadOxLib()
    if GetResourceState('ox_lib') ~= 'started' then return false end
    local chunk = LoadResourceFile('ox_lib', 'init.lua')
    if not chunk then return false end
    local fn = load(chunk, '@@ox_lib/init.lua')
    if not fn then return false end
    local ok = pcall(fn)
    return ok and type(lib) == 'table'
end

Bridge.oxLib = tryLoadOxLib()

if Bridge.oxLib then
    print('[jd-headbag] ox_lib detected, using ox_lib features')
else
    print('[jd-headbag] ox_lib not found, using standalone mode')
end

if IsDuplicityVersion() then
    local callbacks = {}

    if Bridge.oxLib then
        function Bridge.registerCallback(name, cb)
            lib.callback.register(name, cb)
        end
    else
        RegisterNetEvent('bridge:callback')
        AddEventHandler('bridge:callback', function(name, id, ...)
            local src = source
            if callbacks[name] then
                local result = callbacks[name](src, ...)
                TriggerClientEvent('bridge:callbackResponse', src, id, result)
            end
        end)

        function Bridge.registerCallback(name, cb)
            callbacks[name] = cb
        end
    end

    Bridge.hasOxInventory = GetResourceState('ox_inventory') == 'started'
else

    if Bridge.oxLib then
        function Bridge.callbackAwait(name, ...)
            return lib.callback.await(name, false, ...)
        end

        function Bridge.notify(data)
            lib.notify(data)
        end
    else
        local pending = {}
        local nextId = 0

        RegisterNetEvent('bridge:callbackResponse')
        AddEventHandler('bridge:callbackResponse', function(id, result)
            if pending[id] then
                pending[id] = { done = true, result = result }
            end
        end)

        function Bridge.callbackAwait(name, ...)
            nextId = nextId + 1
            local id = nextId
            pending[id] = { done = false }
            TriggerServerEvent('bridge:callback', name, id, ...)
            while not pending[id].done do Wait(50) end
            local result = pending[id].result
            pending[id] = nil
            return result
        end

        function Bridge.notify(data)
            BeginTextCommandThefeedPost("STRING")
            AddTextComponentSubstringPlayerName(data.title .. "\n" .. data.description)
            EndTextCommandThefeedPostTicker(false, true)
        end
    end

    Bridge.hasOxTarget = GetResourceState('ox_target') == 'started'
end

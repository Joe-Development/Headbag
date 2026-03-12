local function loadLocale(lang)
    local content = LoadResourceFile(GetCurrentResourceName(), ('locales/%s.json'):format(lang))
    if not content then
        print(('Locale "%s" not found, falling back to "en"'):format(lang))
        content = LoadResourceFile(GetCurrentResourceName(), 'locales/en.json')
    end
    local decoded = json.decode(content)
    if not decoded then
        print('ERROR: Failed to parse locale JSON')
    end
    return decoded or {}
end

local Locales = loadLocale(Config.defaultLocale)
print(('Loaded locale "%s"'):format(Config.defaultLocale))

local headbagStates = {}

Bridge.registerCallback('jd-headbag:check', function(src)
    return IsPlayerAceAllowed(src, Config.AcePermission)
end)

Bridge.registerCallback('jd-headbag:getConfig', function(source)
    return {
        useAce = Config.useAce,
        acePermission = Config.AcePermission,
        maxDistance = Config.maxDistance,
        locales = Locales,
        useCommand = Config.useCommand,
        useOxTarget = Config.useOxTarget,
        headbagItem = Config.headbagItem,
    }
end)

RegisterNetEvent('jd-headbag:upstream')
AddEventHandler('jd-headbag:upstream', function(data)
    local source = source
    local ped = (data.ped == -1 and source or data.ped)

    if data.maxDist ~= Config.maxDistance then return Config.exploitTriggered(source, Locales["exploit:triggered"]) end

    if ped == -1 then return Config.exploitTriggered(source, Locales["exploit:triggered"]) end

    if Config.useAce then
        if not IsPlayerAceAllowed(source, Config.AcePermission) then return Config.exploitTriggered(source, Locales["exploit:triggered"]) end
    end

    local currentState = headbagStates[ped] or false
    local applying = not currentState

    if applying then
        -- Applying headbag: remove item from the applier
        if Config.headbagItem and Config.headbagItem ~= "" and Bridge.hasOxInventory then
            local removed = exports.ox_inventory:RemoveItem(source, Config.headbagItem, 1)
            if not removed then
                TriggerClientEvent("jd-headbag:noItem", source)
                return
            end
        end
    else
        -- Removing headbag: return item to whoever is removing it
        if Config.headbagItem and Config.headbagItem ~= "" and Bridge.hasOxInventory then
            exports.ox_inventory:AddItem(source, Config.headbagItem, 1)
        end
    end

    headbagStates[ped] = applying
    Player(ped).state:set('headbag', applying and "true" or "false", true)
    TriggerClientEvent("jd-headbag:downstream", ped)
end)

-- Clean up state when player disconnects
AddEventHandler('playerDropped', function()
    headbagStates[source] = nil
end)

local function loadLocale(lang)
    local content = LoadResourceFile(GetCurrentResourceName(), ('locales/%s.json'):format(lang))
    if not content then
        print(('^3[jd-headbag] Locale "%s" not found, falling back to "en"^0'):format(lang))
        content = LoadResourceFile(GetCurrentResourceName(), 'locales/en.json')
    end
    local decoded = json.decode(content)
    if not decoded then
        print('^1[jd-headbag] error: Failed to parse locale JSON^0')
    end
    return decoded or {}
end

local Locales = loadLocale(Config.defaultLocale)
print(('^2[jd-headbag] Loaded locale "%s"^0'):format(Config.defaultLocale))

CreateThread(function ()
    local name = GetCurrentResourceName()
    if name ~= 'jd-headbag' then
        print(('^1[jd-headbag] error: Resource must be named "jd-headbag" (currently: "%s")^0'):format(name))
        print('^3[jd-headbag] This resource name is enforced for the following reasons:^0')
        print('^3[jd-headbag] > respect the developer and contributors ^0')
        print('^3[jd-headbag] > distinguish this resource from unofficial copies, forks or other resources in general ^0')
        print('^3[jd-headbag] > ensure compatibility with exports, events, and integrations^0')
        print('^3[jd-headbag] Please rename this resource to "jd-headbag" and restart.^0')
    end
end)

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
        useInventory = Config.useInventory,
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
        if Config.useInventory and Config.headbagItem and Config.headbagItem ~= "" and Bridge.hasOxInventory then
            local removed = exports.ox_inventory:RemoveItem(source, Config.headbagItem, 1)
            if not removed then
                TriggerClientEvent("jd-headbag:noItem", source)
                return
            end
        end
    else
        if Config.useInventory and Config.headbagItem and Config.headbagItem ~= "" and Bridge.hasOxInventory then
            exports.ox_inventory:AddItem(source, Config.headbagItem, 1)
        end
    end

    headbagStates[ped] = applying
    Player(ped).state:set('headbag', applying and "true" or "false", true)
    TriggerClientEvent("jd-headbag:downstream", ped)
end)

AddEventHandler('playerDropped', function()
    headbagStates[source] = nil
end)

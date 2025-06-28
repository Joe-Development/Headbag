lib.callback.register('jd-headbag:check', function(source, ace)
    return IsPlayerAceAllowed(source, Config.AcePermission)
end)

lib.callback.register('jd-headbag:getConfig', function(source)
    return {
        useAce = Config.useAce,
        acePermission = Config.AcePermission,
        maxDistance = Config.maxDistance,
        defaultLocale = Config.defaultLocale,
        locales = Config.locales[Config.defaultLocale]
    }
end)

RegisterNetEvent('jd-headbag:upstream')
AddEventHandler('jd-headbag:upstream', function(data)
    local ped = (data.ped == -1 and source or data.ped)

    if data.maxDist ~= Config.maxDistance then return Config.exploitTriggered(source, Config.locales[Config.defaultLocale]["exploit:triggered"]) end

    if ped == -1 then return Config.exploitTriggered(source, Config.locales[Config.defaultLocale]["exploit:triggered"]) end

    if Config.useAce then
        if not IsPlayerAceAllowed(source, Config.AcePermission) then return Config.exploitTriggered(source, Config.locales[Config.defaultLocale]["exploit:triggered"]) end
    end

    TriggerClientEvent("jd-headbag:downstream", ped)
end)

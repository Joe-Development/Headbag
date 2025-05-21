local Config = lib.callback.await('jd-headbag:getConfig', false)
local toggled = false
local maxDist = Config.maxDistance
local HeadbagEntity = nil

local function showHeadbag(boolean)
    LocalPlayer.state.headbag = (boolean and "true" or "false")
    SendNuiMessage(json.encode({
        action = "headbag",
        state = boolean
    }))
end

RegisterNetEvent('jd-headbag:downstream')
AddEventHandler('jd-headbag:downstream', function()
    showHeadbag(not toggled)
    toggled = not toggled

    if toggled then
        HeadbagEntity = CreateObject(GetHashKey("prop_headbag"), 0, 0, 0, true, true, true)
        AttachEntityToEntity(HeadbagEntity, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 12844), 0.26, 0.02, 0, 0, 270.0, 75.0, true, true, false, true, 1, true)
    else
        DeleteEntity(HeadbagEntity)
        SetEntityAsNoLongerNeeded(HeadbagEntity)
    end
end)

RegisterCommand("headbag", function()
    local ped, distance = GetClosestPlayer(true)

    if Config.useAce then
        local ace = lib.callback.await('jd-headbag:check', false, Config.AcePermission)
        if not ace then
            lib.notify({
                title = Config.locales["permission:denied:title"],
                description = Config.locales["permission:denied:description"],
                type = "error",
                duration = 3000,
                position = "center-right"
            })
            return
        end
    end

    if distance > maxDist then
        lib.notify({
            title = Config.locales["headbag:title"],
            description = Config.locales["headbag:no:player:nearby"],
            type = "error",
            duration = 3000,
            position = "center-right"
         })
        return
    end

    TriggerServerEvent("jd-headbag:upstream", {
        ped = (GetPlayerServerId(ped) and GetPlayerServerId(ped) or -1),
        distance = distance,
        maxDist = maxDist
    })
end, false)

function GetClosestPlayer(ignoreSelf)
    local players = GetActivePlayers()
    local closestPlayer = -1
    local closestDistance = math.huge
    local plyPed = PlayerPedId()
    local plyCoords = GetEntityCoords(plyPed)

    for i = 1, #players do
        local targetPed = GetPlayerPed(players[i])
        if not ignoreSelf or targetPed ~= plyPed then
            local targetCoords = GetEntityCoords(targetPed)
            local distance = #(plyCoords - targetCoords)
            if distance < closestDistance then
                closestDistance = distance
                closestPlayer = players[i]
            end
        end
    end

    return closestPlayer, closestDistance
end

local types = {
    ["on"] = true,
    ["off"] = false
}

function ForceHeadbag(type)
    if type ~= "off" and type ~= "on" then
        return print(string.format(Config.locales["headbag:invalid:type"], "on", "off"))
    end

    showHeadbag(types[type])
end

function GetHeadbagStatus()
    return LocalPlayer.state.headbag == "true"
end

exports('ForceHeadbag', ForceHeadbag)

exports('GetHeadbagStatus', GetHeadbagStatus)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        if HeadbagEntity ~= nil then
            DeleteEntity(HeadbagEntity)
            SetEntityAsNoLongerNeeded(HeadbagEntity)
        end
        showHeadbag(false)
    end
end)
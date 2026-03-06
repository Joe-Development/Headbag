Config = {}

Config.useAce = false

Config.AcePermission = "jd.headbag" -- [ACE] Only works if useAce is true

Config.maxDistance = 2.0

Config.useCommand = false       -- Enable or disable /headbag command
Config.useOxTarget = true       -- Enable or disable ox_target on players
Config.headbagItem = "headbag"  -- Inventory item name, set this to "" to disable the item requirement

Config.exploitTriggered = function (ped, reason)
    DropPlayer(ped, reason)
end

Config.defaultLocale = "en"
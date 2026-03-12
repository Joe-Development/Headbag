Config = {}

Config.useAce = false

Config.AcePermission = "jd.headbag" -- [ACE] Only works if useAce is true

Config.maxDistance = 2.0

Config.useCommand = true       -- Enable or disable /headbag command

Config.useOxTarget = true       -- Enable or disable ox_target on players
Config.useInventory = true      -- Enable or disable ox_inventory integration (if false, no items will be taken/given)

Config.headbagItem = "headbag"  -- Inventory item name, set this to "" to disable the item requirement

Config.exploitTriggered = function (ped, reason)
    DropPlayer(ped, reason)
end

Config.defaultLocale = "en"
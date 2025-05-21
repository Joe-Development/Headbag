Config = {}

Config.useAce = false

Config.AcePermission = "jd.headbag" -- [ACE] Only works if useAce is true

Config.maxDistance = 2.0

Config.exploitTriggered = function (ped, reason)
    DropPlayer(ped, reason)
end

Config.defaultLocale = "en"

Config.locales = {
    ["en"] = {
        ["permission:denied:title"] = "Permission Denied",
        ["permission:denied:description"] = "You don't have permission",
        ["headbag:title"] = "Headbag",
        ["headbag:no:player:nearby"] = "No player nearby",
        ["headbag:invalid:type"] = "Invalid type passed for function ForceHeadbag {%s, %s}",
        ["exploit:triggered"] = "Exploiting Headbag Event"
    }
}
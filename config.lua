Config = {}

Config.useAce = false

Config.AcePermission = "jd.headbag" -- [ACE] Only works if useAce is true

Config.maxDistance = 2.0

Config.exploitTriggered = function (ped, reason)
    DropPlayer(ped, reason)
end
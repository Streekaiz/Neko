local Environment : {[any] : any} = getgenv() or _G or {}
local Author : string = "Streekaiz"
local Repository : string = "Neko"
local LoadTick : number = tick()

local Notification : {[any] : any}

Environment["Neko"] = {
    ["Dependencies"] = {
        ["Interface"] = {},
        ["Clients"] = {},
        ["Instances"] = {},
        ["Miscallaenous"] = {},
        ["Services"] = {},
        ["Signals"] = {},
        ["String"] = {}
    }
}

local Games : {[number] : string} = {
    [17574618959] = "Baseplate"
}

for Index, Dependency in pairs({
    "Interface",
    "Clients",
    "Instances",
    "Miscallaenous",
    "Services",
    "Signals",
    "String"
}) do 
    local Success : boolean = false 
    local Source : ((any) -> any) 
    local ContinueLoading : boolean = true 
    local AnsweredPrompt : boolean = false 
    
    Success, Source = pcall(function(...)  
        return loadstring(
            game:HttpGet(
                string.format(
                    "https://raw.githubusercontent.com/%s/%s/main/Dependencies/%s.luau", 
                    Author, 
                    Repository, 
                    Dependency
                )
            ),
            Dependency
        )
    end)

    if not Success then
        if Index ~= 1 then 
            if not Environment["Neko"]["Dependencies"]["Interface"]["Window"] then 
                Environment["Neko"]["Dependencies"]["Interface"]["Window"] = Environment["Neko"]["Dependencies"]["Interface"]["Library"]:Window({
                    Name = "neko.hook"
                })
            end 

            Notification = Environment["Neko"]["Dependencies"]["Interface"]["Library"]:Notification({
                Name = string.format(
                    "Failed to load %s - Error: %s - Do you wish to continue loading?",
                    Dependency, 
                    tostring(Source)
                ),
                Type = "Fading"
            })

            Notification:NotificationButton({
                Name = "Yes",
                Callback = function(... : any)
                    AnsweredPrompt = true 
                    Notification.DestroyNotif()
                end
            })

            Notification:NotificationButton({
                Name = "No",
                Callback = function(... : any)
                    AnsweredPrompt = true 
                    ContinueLoading = false 
                    Notification.DestroyNotif()
                end
            })

            repeat 
                task.wait()
            until AnsweredPrompt 

            if not ContinueLoading then 
                Environment["Neko"]["Dependencies"]["Interface"]["Library"]:Unload()
                break 
            end

            Source = function(... : any) end
        else 
            warn("failed to load interface, msg: " .. tostring(Source))
        end 
    end

    Environment["Neko"]["Dependencies"][Dependency] = Source() 
    
    if not Environment["Neko"]["Dependencies"]["Interface"]["Window"] then 
        Environment["Neko"]["Dependencies"]["Interface"]["Window"] = Environment["Neko"]["Dependencies"]["Interface"]["Library"]:Window({
            Name = "neko.hook"
        })
    end 

    local CurrentTick = tick()

    Environment["Neko"]["Dependencies"]["Interface"]["Library"]:Notification({
        Name = string.format(
            "Loaded %s dependency in %sms",
            Dependency,
            tostring(CurrentTick - LoadTick)
        ),
        Lifetime = 7.5,
        Type = "Fading"
    })

    LoadTick = CurrentTick
end  

local Game = nil 

for i, v in next, Games do 
    if i == game.PlaceId then 
        Game = v 
        break
    end
end

loadstring(game:HttpGet(
    string.format(
        "https://raw.githubusercontent.com/%s/%s/main/Games/%s.luau",
        Author,
        Repository,
        (Game ~= nil and Game) or "Universal"
    )
), "neko")

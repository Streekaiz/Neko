local Environment : {[any] : any} = getgenv() or _G or {}
local Author : string = "Streekaiz"
local Repository : string = "Femboy"
local LoadTick : number = tick()

Environment["Femboy"] = {
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

Environment["Femboy"]["Print"] = function(Data : string, Duration : number) : {any}?
    if Environment["Femboy"]["Dependencies"]["Interface"]["Library"] then 
        return Environment["Femboy"]["Dependencies"]["Interface"]["Library"]:Notification({
            Name = Data, 
            Lifetime = Duration or 3
        })
    else 
        return warn(Data)
    end
end

for Name, Dependency in next, Environment["Femboy"]["Dependencies"] do 
    local Success : boolean = false 
    local Source : ((any) -> any) 
    local PromptAnswered : boolean = true
    local ContinueLoading : boolean = true 
    
    Success, Source = pcall(function(...)  
        return loadstring(
            game:HttpGet(
                string.format(
                    "https://raw.githubusercontent.com/%s/%s/main/Dependencies/%s.luau", 
                    Author, 
                    Repository, 
                    Name
                )
            ),
            Name
        )
    end)

    if not Success then
        local Notification = Environment["Femboy"]["Print"](string.format(
            "Failed to load %s\nMessage: %s\nDo you wish to continue loading dependencies?",
            Name,
            tostring(Source)
        ), 10)

        Notification:NotificationButton({Name = "Yes", Callback = function(... : any)
            PromptAnswered = true
            Notification.DestroyNotif()
        end})

        Notification:NotificationButton({Name = "No", Callback = function(... : any)
            PromptAnswered = true 
            ContinueLoading = false 
            Notification.DestroyNotif()
        end})
    end

    repeat
        task.wait()
    until PromptAnswered

    if not ContinueLoading then 
        break 
    end

    Environment["Femboy"]["Dependencies"][Name] = Source() 
    Environment["Femboy"]["Print"](string.format(
        "Loaded %s in %sms",
        Name,
        tostring(tick() - LoadTick)
    ))
end 


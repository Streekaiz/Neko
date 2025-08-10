local Environment : {[any] : any} = getgenv() or _G or {}
local Neko : {[any] : any} = Environment["Neko"]

local Lighting : Lighting = Environment["Neko"]["Dependencies"]["Services"]:Get("Lighting") -- any : any smh
local Players : Players = Environment["Neko"]["Dependencies"]["Services"]:Get("Players")

local Camera : Camera = workspace.CurrentCamera 

local BloomEffect : {[any] : any} = Environment["Neko"]["Dependencies"]["Instances"]:Create("BloomEffect", {Enabled = false, Parent = Lighting})
local ColorCorrectionEffect : {[any] : any} = Environment["Neko"]["Dependencies"]["Instances"]:Create("ColorCorrectionEffect", {Enabled = false, Parent = Lighting})

local Old : {[any] : any} = {
    TimeOfDay = Lighting.TimeOfDay,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    FogStart = Lighting.FogStart,
    FogEnd = Lighting.FogEnd,
    GlobalShadows = Lighting.GlobalShadows,
    FieldOfView = Camera.FieldOfView
} 

Environment["Neko"]["Dependencies"]["Interface"]["Panel"] = Environment["Neko"]["Dependencies"]["Interface"]["Window"]:Panel({
    Name = "CHAIN",
    Size = UDim2.fromOffset(600, 710)
}); do 
    local Pages : {[string] : {[any] : any}} = {
        ["Main"] = Environment["Neko"]["Dependencies"]["Interface"]["Panel"]:Tab({
            Name = "Main"
        }),
        ["Visual"] = Environment["Neko"]["Dependencies"]["Interface"]["Panel"]:Tab({
            Name = "Visual"
        }),
        ["Settings"] = Environment["Neko"]["Dependencies"]["Interface"]["Library"]:Configs(Environment["Neko"]["Dependencies"]["Interface"]["Window"], Environment["Neko"]["Dependencies"]["Interface"]["Panel"]:Tab({
            Name = "Settings"
        }))
    }

    local Page : {[any] : any}
    local Collumn : {[any] : any}
    local Section : {[any] : any}
    local Element : {[any] : any}
    local Tab : {[any] : any}

    Page = Pages["Main"]; do 
        Collumn = Page:Column({Fill = true}); do 
            Section = Collumn:Section({Name = "Gameplay"}); do 
                Section:Toggle({Flag = "GameplayQTE", Name = "Complete QTE", Tooltip = {Title = "Quick Time Events", Text = "Plays quick time events for you.", Width = 100}}):Keybind({Flag = "GameplayQTEKey", Name = "Auto QTE", Mode = "Toggle"})
                Section:Dropdown({Flag = "GameplayQTEInput", Options = {"Signal", "Keyboard", "VirtualInputManager"}, Default = "VirtualInputManager"})
                Section:Slider({Flag = "GameplayQTEDelay", Name = "Delay", Min = 0, Max = 1, Decimals = 0.025, Suffix = "ms"})
                Section:Toggle({Flag = "GameplayDodge", Name = "Auto Dodge", Tooltip = {Title = "Dodging", Text = "Dodges CHAIN's attacks for you."}}):Keybind({Flag = "GameplayDodgeKey", Name = "Auto Dodge", Mode = "Toggle"})
                Section:Toggle({Flag = "GameplayStamina", Name = "Infinite Stamina"})
                Section:Toggle({Flag = "GameplayCombatStamina", Name = "Infinite Combat Stamina", Tooltip = {Title = "Combat Stamina", Text = "Combat stamina is used for melees."}})
                Section:Toggle({Flag = "GameplayRecoil", Name = "No Recoil", Tooltip = {Title = "Gun Recoil", Text = "Removes recoil from ranged weapons."}})
                Section:Label({Name = "Shop", Alignment = "Center"})
                Section:Toggle({Flag = "GameplayRefillXSaw", Name = "Refill XSaw", Tooltip = {Title = "Usage", Text = "This can drain your money."}})
                Section:Toggle({Flag = "GameplayRefillAK47", Name = "Refill AK47", Tooltip = {Title = "Usage", Text = "This can drain your money."} })
                Section:Toggle({Flag = "GameplayRefillPistol", Name = "Refill Pistol", Tooltip = {Title = "Usage", Text = "You need scrap to refill."}})
                Section:Toggle({Flag = "GameplayRefillDB", Name = "Refill DB", Tooltip = {Title = "Usage", Text = "You need scrap to refill."}})
                Section:Button({Flag = "GameplayOpenShop", Name = "Open Shop Menu"})
            end
        end

        Collumn = Page:Column({Fill = true}); do 
            Section = Collumn:Section({Name = "Aim Assist"}); do 
                Section:Toggle({Flag = "AssistEnabled", Name = "Enabled", Tooltip = {Title = "Aim Assist", Text = "Curves your mouse towards CHAIN"}}):Keybind({Flag = "AssistKey", Name = "Aim Assist", Mode = "Hold"})
                Section:Toggle({Flag = "AssistClosest", Name = "Target Closest Part", Tooltip = {Title = "Closest Part", Text = "Only targets the closest limb to your mouse."}})
                Section:Toggle({Flag = "AssistSmoothing", Name = "Use Smoothing"})
                Section:Slider({Flag = "AssistSmoothingX", Prefix = "X Factor: ", Suffix = "%", Default = 100})
                Section:Slider({Flag = "AssistSmoothingY", Prefix = "Y Factor: ", Suffix = "%", Default = 100})
                Section:Toggle({Flag = "AssistFovUse", Name = "Limit to FOV", Tooltip = {Title = "Field Of View", Text = "Only aims at CHAIN if he's in the radius."}})
                Section:Slider({Flag = "AssistFovRadius", Max = 360, Default = 180, Suffix = "°"})
            end
        end
    end

    Page = Pages["Visual"]; do 
        Collumn = Page:Column({Fill = true}); do 
            Section = Collumn:Section({Name = "Extrasensory Perception"}); do
                Element = Section:EspPreview({}); do 
                    Tab = Element:AddTab({Name = "Players", Model = "rbxassetid://14966982841", Chams = true}); do 
                        Tab.AddBar({Name = "Healthbar", Prefix = "Healthbar"})
                        Tab.AddText({Name = "Name", Prefix = "Name"})
                        Tab.AddText({Name = "Display", Prefix = "Display"})
                        Tab.AddText({Name = "Distance", Prefix = "Distance"})
                        Tab.AddText({Name = "Tool", Prefix = "Tool"})
                        Tab.AddBox({Name = "Box"})
                    end
                    Tab = Element:AddTab({Name = "CHAIN", Model = "rbxassetid://14966982841"}); do 
                        Tab.AddBar({Name = "Healthbar", Prefix = "Healthbar"})
                        Tab.AddText({Name = "Distance", Prefix = "Distance"})
                        Tab.AddBox({Name = "Box"})
                    end
                    Tab = Element:AddTab({Name = "Scrap", Model = "rbxassetid://14966982841"}); do 
                        Tab.AddText({Name = "Distance", Prefix = "Distance"})
                        Tab.AddBox({Name = "Box"})
                    end
                end
                Collumn = Tab:Column({Fill = true}); do 
            Section = Collumn:Section({Name = "World", Side = "Right"}); do 
                Element = Section:Toggle({Flag = "worldAmbient", Name = "Ambience", Callback = function(State : boolean)
                    if State then 
                        Lighting.Ambient = Environment["Neko"]["Dependencies"]["Interface"]["Library"].Flags["worldAmbientPicker1"].Color 
                        Lighting.OutdoorAmbient = Environment["Neko"]["Dependencies"]["Interface"]["Library"].Flags["worldAmbientPicker2"].Color 
                    else 
                        Lighting.Ambient = Old.Ambient
                        Lighting.OutdoorAmbient = Old.OutdoorAmbient
                    end
                end})
                Element:Colorpicker({Flag = "worldAmbientPicker1", Name = "Indoor Ambience", Callback = function(Color : Color3)
                    if not Environment["Neko"]["Dependencies"]["Interface"]["Library"].Flags["worldAmbient"] then return end 
                    Lighting.Ambient = Color 
                end})
                Element:Colorpicker({Flag = "worldAmbientPicker2", Name = "Outdoor Ambience", Callback = function(Color : Color3)
                    if not Environment["Neko"]["Dependencies"]["Interface"]["Library"].Flags["worldAmbient"] then return end 
                    Lighting.OutdoorAmbient = Color 
                end})
                Element:Toggle({Flag = "worldGlobalShadows", Name = "Global Shadows", Default = Old.GlobalShadows, Callback = function(State : boolean)
                    Lighting.GlobalShadows = State 
                end})
                Element:Dropdown({Flag = "worldTechnology", Options = {"Compatibility", "Voxel", "ShadowMap", "Future", "Unified"}, Default = Lighting.Technology.Name, Callback = function(State : string)
                    sethiddenproperty(Lighting, "Technology", Enum.Technology[State])
                end})
                Section:Toggle({ Flag = "worldTime", Name = "Time of Day", Callback = function(Boolean : boolean)
                    if Boolean then 
                        Lighting.TimeOfDay = Environment["Neko"]["Dependencies"]["Interface"]["Library"].Flags["worldTimeValue"]
                    else 
                        Lighting.TimeOfDay = Old.TimeOfDay
                    end
                end})
                Section:Slider({Flag = "worldTimeValue", Min = -12, Max = 12, Default = 0, Decimal = 0.05, Callback = function(Value : number)
                    if not Environment["Neko"]["Dependencies"]["Interface"]["Library"].Flags["worldTime"] then return end 
                    Lighting.TimeOfDay = Value
                end})
                Section:Toggle({Name = "No Fog", Flag = "worldFog", Callback = function(Boolean : boolean)
                    if Boolean then 
                        Lighting.FogEnd = 9e9
                        Lighting.FogStart = 9e9 
                    else 
                        Lighting.FogEnd = Old.FogEnd
                        Lighting.FogStart = Old.FogStart
                    end
                end})
                Section:Dropdown({Name = "Custom Skybox", Flag = "worldSkybox", Options = {}})
            end
            Section = Collumn:Section({Name = "Bloom"}); do 
                Section:Toggle({Flag = "bloomEnabled", Name = "Enabled", Callback = function(State : boolean)
                    BloomEffect.Instance.Enabled = State 
                end})
                Section:Slider({Flag = "bloomIntensity", Name = "Intensity", Max = 25, Default = 1, Callback = function(Value : number)
                    BloomEffect.Instance.Intensity = Value 
                end})
                Section:Slider({Flag = "bloomThreshold", Name = "Threshold", Max = 1, Default = 1, Decimal = 0.005, Callback = function(Value : number)
                    BloomEffect.Instance.Threshold = Value 
                end})
                Section:Slider({Flag = "bloomSize", Name = "Size", Max = 10, Default = 1, Callback = function(Value : number)
                    BloomEffect.Instance.Size = Value 
                end})
            end
            Section = Collumn:Section({Name = "Color Correction"}); do 
                Section:Toggle({Flag = "colorCorrectionEnabled", Name = "Enabled", Callback = function(State : boolean)
                    ColorCorrectionEffect.Instance.Enabled = State 
                end}):Colorpicker({Name = "Tint", Flag = "colorCorrectionTint", Callback = function(Value : Color3)
                    ColorCorrectionEffect.Instance.TintColor = Value 
                end})
                Section:Slider({Flag = "colorCorrectionBrightness", Name = "Brightness", Max = 1, Min = -1, Default = 0, Decimal = 0.005, Callback = function(Value : number)
                    ColorCorrectionEffect.Instance.Brightness = Value 
                end})
                Section:Slider({Flag = "colorCorrectionContrast", Name = "Contrast", Max = 25, Min = -25, Default = 0, Decimal = 0.1, Callback = function(Value : number)
                    ColorCorrectionEffect.Instance.Contrast = Value 
                end})
                Section:Slider({Flag = "colorCorrectionSaturation", Name = "Saturation", Max = 10, Min = -1, Default = 0, Decimal = 0.1, Callback = function(Value : number)
                    ColorCorrectionEffect.Instance.Saturation = Value 
                end})
            end
        end
            end
        end
    end
end
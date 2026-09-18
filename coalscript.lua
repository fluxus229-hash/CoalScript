--// COAL HUB • DOORS
--// HOTEL + MINES • FULL UPDATED
--// Door ESP: interactive doors only / correct green / wrong red
--// Figure Book ESP: glowing Figure books only
--// Entity notifications: top-right, stacked, smooth in/out

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LP = Players.LocalPlayer
local PG = LP:WaitForChild("PlayerGui")

local S = {
    Width=590, Height=410, Transparency=.08,
    WalkSpeed=16, JumpPower=50,
    ThirdPerson=false, CameraDistance=12, LockCamera=false,
    Fullbright=false, Noclip=false, InfiniteJump=false,
    DoorESP=false, ItemESP=false, KeyESP=false, GoldESP=false,
    LeverESP=false, HidingSpotESP=false, FigureBookESP=false,

    Entities={
        Rush=false,
        Ambush=false,
        Screech=false,
        Eyes=false,
        Seek=false,
        Figure=false,
        Halt=false,
        Dupe=false,
        Dread=false,
        Glitch=false,
        Giggle=false,
        Grumble=false,
        Gloombats=false,
        QueenGrumble=false,
        Louie=false,
        Jack=false,
        Hide=false
    },

    HUD={
        FPS=true,
        Ping=true,
        Room=true,
        Time=true,
        Players=true
    }
}

local Theme={
    Main=Color3.fromRGB(25,27,35),
    Secondary=Color3.fromRGB(32,35,45),
    Accent=Color3.fromRGB(65,145,255),
    Text=Color3.fromRGB(240,240,245),
    Muted=Color3.fromRGB(155,160,175)
}

local Colors={
    Rush=Color3.fromRGB(255,60,60),
    Ambush=Color3.fromRGB(255,100,100),
    Screech=Color3.fromRGB(190,100,255),
    Eyes=Color3.fromRGB(170,80,255),
    Seek=Color3.fromRGB(255,130,40),
    Figure=Color3.fromRGB(70,120,255),
    Halt=Color3.fromRGB(255,210,50),
    Dupe=Color3.fromRGB(80,220,120),
    Dread=Color3.fromRGB(130,70,40),
    Glitch=Color3.fromRGB(80,255,255),
    Giggle=Color3.fromRGB(80,255,140),
    Grumble=Color3.fromRGB(255,70,120),
    QueenGrumble=Color3.fromRGB(255,50,160),
    Gloombats=Color3.fromRGB(180,80,255),
    Louie=Color3.fromRGB(255,180,80),
    Jack=Color3.fromRGB(180,70,255),
    Hide=Color3.fromRGB(255,150,60),

    FigureBook=Color3.fromRGB(255,240,80),

    Correct=Color3.fromRGB(70,255,110),
    Wrong=Color3.fromRGB(255,60,60),

    Key=Color3.fromRGB(255,220,60),
    Gold=Color3.fromRGB(255,190,40),
    Lever=Color3.fromRGB(170,100,255),
    HideSpot=Color3.fromRGB(100,255,160)
}

--========================================================
-- GUI
--========================================================

local old=PG:FindFirstChild("CoalHub_DOORS")
if old then
    old:Destroy()
end

local Gui=Instance.new("ScreenGui")
Gui.Name="CoalHub_DOORS"
Gui.ResetOnSpawn=false
Gui.IgnoreGuiInset=true
Gui.Parent=PG

local Main=Instance.new("Frame",Gui)
Main.Size=UDim2.fromOffset(S.Width,S.Height)
Main.Position=UDim2.new(.5,-S.Width/2,.5,-S.Height/2)
Main.BackgroundColor3=Theme.Main
Main.BackgroundTransparency=S.Transparency
Main.BorderSizePixel=0

Instance.new("UICorner",Main).CornerRadius=UDim.new(0,12)

local Stroke=Instance.new("UIStroke",Main)
Stroke.Color=Theme.Accent
Stroke.Transparency=.55

--========================================================
-- TOP
--========================================================

local Top=Instance.new("Frame",Main)
Top.Size=UDim2.new(1,0,0,50)
Top.BackgroundColor3=Theme.Secondary
Top.BorderSizePixel=0

Instance.new("UICorner",Top).CornerRadius=UDim.new(0,12)

local Title=Instance.new("TextLabel",Top)
Title.BackgroundTransparency=1
Title.Position=UDim2.fromOffset(18,5)
Title.Size=UDim2.new(1,-80,0,25)
Title.Font=Enum.Font.GothamBold
Title.Text="COAL HUB"
Title.TextColor3=Theme.Text
Title.TextSize=18
Title.TextXAlignment=Enum.TextXAlignment.Left

local Sub=Instance.new("TextLabel",Top)
Sub.BackgroundTransparency=1
Sub.Position=UDim2.fromOffset(19,27)
Sub.Size=UDim2.new(1,-80,0,18)
Sub.Font=Enum.Font.Gotham
Sub.Text="DOORS • HOTEL + MINES"
Sub.TextColor3=Theme.Muted
Sub.TextSize=11
Sub.TextXAlignment=Enum.TextXAlignment.Left

local Close=Instance.new("TextButton",Top)
Close.BackgroundTransparency=1
Close.Position=UDim2.new(1,-45,0,7)
Close.Size=UDim2.fromOffset(35,35)
Close.Font=Enum.Font.GothamBold
Close.Text="×"
Close.TextColor3=Theme.Text
Close.TextSize=25

--========================================================
-- TABS
--========================================================

local Tabs=Instance.new("Frame",Main)
Tabs.Position=UDim2.fromOffset(10,60)
Tabs.Size=UDim2.new(0,120,1,-70)
Tabs.BackgroundTransparency=1

local tl=Instance.new("UIListLayout",Tabs)
tl.Padding=UDim.new(0,6)

local Content=Instance.new("Frame",Main)
Content.Position=UDim2.fromOffset(140,60)
Content.Size=UDim2.new(1,-150,1,-70)
Content.BackgroundTransparency=1

local Pages={}

local function page(n)

    local p=Instance.new("ScrollingFrame",Content)

    p.Name=n
    p.Size=UDim2.fromScale(1,1)
    p.BackgroundTransparency=1
    p.BorderSizePixel=0
    p.ScrollBarThickness=3
    p.Visible=false
    p.AutomaticCanvasSize=Enum.AutomaticSize.Y

    local l=Instance.new("UIListLayout",p)
    l.Padding=UDim.new(0,7)

    Pages[n]=p

    return p
end

local Home=page("Home")
local Player=page("Player")
local Visual=page("Visuals")
local Entities=page("Entities")
local Camera=page("Camera")
local HUDPage=page("HUD")
local Settings=page("Settings")

--========================================================
-- UI HELPERS
--========================================================

local function section(p,t)

    local x=Instance.new("TextLabel",p)

    x.Size=UDim2.new(1,-8,0,28)
    x.BackgroundTransparency=1
    x.Font=Enum.Font.GothamBold
    x.Text=t
    x.TextColor3=Theme.Accent
    x.TextSize=14
    x.TextXAlignment=Enum.TextXAlignment.Left
end

local function toggle(p,text,default,fn)

    local b=Instance.new("TextButton",p)

    b.Size=UDim2.new(1,-8,0,36)
    b.BackgroundColor3=Theme.Secondary
    b.BorderSizePixel=0
    b.AutoButtonColor=false
    b.Font=Enum.Font.Gotham
    b.TextSize=13
    b.TextXAlignment=Enum.TextXAlignment.Left

    Instance.new("UICorner",b).CornerRadius=UDim.new(0,7)

    local v=default

    local function refresh()

        b.Text=
            "   "..text..
            "    ["..(v and "ON" or "OFF").."]"

        b.TextColor3=
            v and Theme.Accent or Theme.Text
    end

    b.MouseButton1Click:Connect(function()

        v=not v

        refresh()

        if fn then
            fn(v)
        end
    end)

    refresh()

    return b
end

local function slider(p,text,min,max,default,fn)

    local h=Instance.new("Frame",p)

    h.Size=UDim2.new(1,-8,0,55)
    h.BackgroundColor3=Theme.Secondary
    h.BorderSizePixel=0

    Instance.new("UICorner",h).CornerRadius=UDim.new(0,7)

    local lab=Instance.new("TextLabel",h)

    lab.BackgroundTransparency=1
    lab.Position=UDim2.fromOffset(10,4)
    lab.Size=UDim2.new(1,-20,0,20)
    lab.Font=Enum.Font.Gotham
    lab.TextColor3=Theme.Text
    lab.TextSize=12
    lab.TextXAlignment=Enum.TextXAlignment.Left

    local bar=Instance.new("Frame",h)

    bar.Position=UDim2.fromOffset(10,31)
    bar.Size=UDim2.new(1,-20,0,5)
    bar.BackgroundColor3=Color3.fromRGB(65,65,75)

    local fill=Instance.new("Frame",bar)
    fill.BackgroundColor3=Theme.Accent

    local drag=false

    local function set(v)

        v=math.clamp(v,min,max)

        fill.Size=
            UDim2.new(
                (v-min)/(max-min),
                0,
                1,
                0
            )

        lab.Text=
            text..": "..string.format("%.1f",v)

        if fn then
            fn(v)
        end
    end

    bar.InputBegan:Connect(function(i)

        if
            i.UserInputType==Enum.UserInputType.MouseButton1
            or i.UserInputType==Enum.UserInputType.Touch
        then
            drag=true
        end
    end)

    UserInputService.InputEnded:Connect(function(i)

        if
            i.UserInputType==Enum.UserInputType.MouseButton1
            or i.UserInputType==Enum.UserInputType.Touch
        then
            drag=false
        end
    end)

    UserInputService.InputChanged:Connect(function(i)

        if
            drag
            and (
                i.UserInputType==Enum.UserInputType.MouseMovement
                or i.UserInputType==Enum.UserInputType.Touch
            )
        then

            local pct=
                math.clamp(
                    (i.Position.X-bar.AbsolutePosition.X)
                    /bar.AbsoluteSize.X,
                    0,
                    1
                )

            set(
                min+(max-min)*pct
            )
        end
    end)

    set(default)
end

--========================================================
-- HOME
--========================================================

section(Home,"Coal Hub")

local info=Instance.new("TextLabel",Home)

info.Size=UDim2.new(1,-8,0,105)
info.BackgroundColor3=Theme.Secondary
info.BackgroundTransparency=.1
info.BorderSizePixel=0
info.Font=Enum.Font.Gotham
info.TextColor3=Theme.Text
info.TextSize=13
info.TextWrapped=true

info.Text=[[
DOORS • HOTEL + MINES

Coal Hub
ESP • Entities • Player
Camera • HUD • Settings

Figure Book ESP = only glowing Figure books.
]]

Instance.new("UICorner",info).CornerRadius=UDim.new(0,8)

--========================================================
-- PLAYER
--========================================================

section(Player,"Movement")

slider(Player,"WalkSpeed",8,100,16,function(v)
    S.WalkSpeed=v
end)

slider(Player,"Jump Power",20,150,50,function(v)
    S.JumpPower=v
end)

toggle(Player,"Infinite Jump",false,function(v)
    S.InfiniteJump=v
end)

toggle(Player,"Noclip",false,function(v)
    S.Noclip=v
end)

--========================================================
-- VISUALS
--========================================================

section(Visual,"Object ESP")

toggle(Visual,"Door ESP",false,function(v)
    S.DoorESP=v
end)

toggle(Visual,"Key ESP",false,function(v)
    S.KeyESP=v
end)

toggle(Visual,"Gold ESP",false,function(v)
    S.GoldESP=v
end)

toggle(Visual,"Lever ESP",false,function(v)
    S.LeverESP=v
end)

toggle(Visual,"Hiding Spot ESP",false,function(v)
    S.HidingSpotESP=v
end)

toggle(Visual,"Item ESP",false,function(v)
    S.ItemESP=v
end)

toggle(Visual,"Figure Book ESP",false,function(v)
    S.FigureBookESP=v
end)

toggle(Visual,"Fullbright",false,function(v)
    S.Fullbright=v
end)

--========================================================
-- ENTITIES
--========================================================

section(Entities,"HOTEL")

for _,n in ipairs({
    "Rush",
    "Ambush",
    "Screech",
    "Eyes",
    "Seek",
    "Figure",
    "Halt",
    "Dupe",
    "Dread",
    "Glitch",
    "Jack",
    "Hide"
}) do

    toggle(
        Entities,
        n.." ESP",
        false,
        function(v)
            S.Entities[n]=v
        end
    )
end

section(Entities,"MINES")

for _,n in ipairs({
    "Giggle",
    "Gloombats",
    "Grumble",
    "QueenGrumble",
    "Louie"
}) do

    local d=n

    if n=="QueenGrumble" then
        d="Queen Grumble"
    end

    toggle(
        Entities,
        d.." ESP",
        false,
        function(v)
            S.Entities[n]=v
        end
    )
end

--========================================================
-- CAMERA
--========================================================

section(Camera,"Camera")

toggle(Camera,"Third Person",false,function(v)

    S.ThirdPerson=v

    LP.CameraMode=Enum.CameraMode.Classic

    if v then

        LP.CameraMinZoomDistance=5
        LP.CameraMaxZoomDistance=S.CameraDistance

    else

        LP.CameraMinZoomDistance=.5
        LP.CameraMaxZoomDistance=12.5
    end
end)

slider(Camera,"Camera Distance",5,30,12,function(v)

    S.CameraDistance=v

    if S.ThirdPerson then
        LP.CameraMaxZoomDistance=v
    end
end)

toggle(Camera,"Lock Camera Distance",false,function(v)
    S.LockCamera=v
end)

local reset=Instance.new("TextButton",Camera)

reset.Size=UDim2.new(1,-8,0,36)
reset.BackgroundColor3=Theme.Secondary
reset.BorderSizePixel=0
reset.Font=Enum.Font.Gotham
reset.Text="   Reset Camera"
reset.TextColor3=Theme.Text
reset.TextSize=13
reset.TextXAlignment=Enum.TextXAlignment.Left

Instance.new("UICorner",reset).CornerRadius=UDim.new(0,7)

reset.MouseButton1Click:Connect(function()

    S.ThirdPerson=false
    S.CameraDistance=12
    S.LockCamera=false

    LP.CameraMode=Enum.CameraMode.Classic
    LP.CameraMinZoomDistance=.5
    LP.CameraMaxZoomDistance=12.5
end)

--========================================================
-- HUD
--========================================================

section(HUDPage,"HUD")

for _,n in ipairs({
    "FPS",
    "Ping",
    "Room",
    "Time",
    "Players"
}) do

    toggle(
        HUDPage,
        n.." HUD",
        S.HUD[n],
        function(v)
            S.HUD[n]=v
        end
    )
end

local HUD=Instance.new("Frame",Gui)

HUD.Position=UDim2.fromOffset(12,12)
HUD.Size=UDim2.fromOffset(220,125)
HUD.BackgroundColor3=Theme.Main
HUD.BackgroundTransparency=.15
HUD.BorderSizePixel=0

Instance.new("UICorner",HUD).CornerRadius=UDim.new(0,9)

local HUDText=Instance.new("TextLabel",HUD)

HUDText.Position=UDim2.fromOffset(10,8)
HUDText.Size=UDim2.new(1,-20,1,-16)
HUDText.BackgroundTransparency=1
HUDText.Font=Enum.Font.Code
HUDText.TextColor3=Theme.Text
HUDText.TextSize=13
HUDText.TextXAlignment=Enum.TextXAlignment.Left
HUDText.TextYAlignment=Enum.TextYAlignment.Top

--========================================================
-- SETTINGS
--========================================================

section(Settings,"Interface")

slider(Settings,"Width",450,850,590,function(v)

    S.Width=v
    Main.Size=UDim2.fromOffset(S.Width,S.Height)
end)

slider(Settings,"Height",300,600,410,function(v)

    S.Height=v
    Main.Size=UDim2.fromOffset(S.Width,S.Height)
end)

slider(Settings,"Transparency",0,.5,.08,function(v)

    S.Transparency=v
    Main.BackgroundTransparency=v
end)

section(Settings,"Themes")

local Themes={

    Blue={
        Main=Color3.fromRGB(25,27,35),
        Secondary=Color3.fromRGB(32,35,45),
        Accent=Color3.fromRGB(65,145,255),
        Text=Color3.fromRGB(240,240,245),
        Muted=Color3.fromRGB(155,160,175)
    },

    Purple={
        Main=Color3.fromRGB(28,25,35),
        Secondary=Color3.fromRGB(38,32,48),
        Accent=Color3.fromRGB(170,90,255),
        Text=Color3.fromRGB(245,240,250),
        Muted=Color3.fromRGB(170,155,185)
    },

    Green={
        Main=Color3.fromRGB(24,31,28),
        Secondary=Color3.fromRGB(30,42,35),
        Accent=Color3.fromRGB(65,210,125),
        Text=Color3.fromRGB(240,250,243),
        Muted=Color3.fromRGB(155,180,165)
    }
}

for name,c in pairs(Themes) do

    local b=Instance.new("TextButton",Settings)

    b.Size=UDim2.new(1,-8,0,36)
    b.BackgroundColor3=c.Secondary
    b.BorderSizePixel=0
    b.Font=Enum.Font.Gotham
    b.Text="   "..name
    b.TextColor3=c.Accent
    b.TextSize=13
    b.TextXAlignment=Enum.TextXAlignment.Left

    Instance.new("UICorner",b).CornerRadius=UDim.new(0,7)

    b.MouseButton1Click:Connect(function()

        Theme=c

        Main.BackgroundColor3=c.Main
        Top.BackgroundColor3=c.Secondary

        Stroke.Color=c.Accent
        Title.TextColor3=c.Text
        Sub.TextColor3=c.Muted

        HUD.BackgroundColor3=c.Main
        HUDText.TextColor3=c.Text
    end)
end

--========================================================
-- TABS
--========================================================

local TabButtons={}

local function openPage(n)

    for k,p in pairs(Pages) do
        p.Visible=(k==n)
    end

    for k,b in pairs(TabButtons) do

        b.BackgroundColor3=
            (k==n and Theme.Accent or Theme.Secondary)

        b.TextColor3=Theme.Text
    end
end

for _,n in ipairs({
    "Home",
    "Player",
    "Visuals",
    "Entities",
    "Camera",
    "HUD",
    "Settings"
}) do

    local b=Instance.new("TextButton",Tabs)

    b.Size=UDim2.new(1,0,0,36)
    b.BackgroundColor3=Theme.Secondary
    b.BorderSizePixel=0
    b.AutoButtonColor=false
    b.Font=Enum.Font.Gotham
    b.Text=n
    b.TextColor3=Theme.Text
    b.TextSize=12

    Instance.new("UICorner",b).CornerRadius=UDim.new(0,7)

    b.MouseButton1Click:Connect(function()
        openPage(n)
    end)

    TabButtons[n]=b
end

openPage("Home")

--========================================================
-- MINI BUTTON
--========================================================

local Mini=Instance.new("TextButton",Gui)

Mini.Size=UDim2.fromOffset(48,48)
Mini.Position=UDim2.new(0,15,.5,-24)
Mini.BackgroundColor3=Theme.Main
Mini.BorderSizePixel=0
Mini.Font=Enum.Font.GothamBold
Mini.Text="C"
Mini.TextColor3=Theme.Accent
Mini.TextSize=20
Mini.Visible=false

Instance.new("UICorner",Mini).CornerRadius=UDim.new(1,0)

Close.MouseButton1Click:Connect(function()

    Main.Visible=false
    Mini.Visible=true
end)

Mini.MouseButton1Click:Connect(function()

    Main.Visible=true
    Mini.Visible=false
end)

--========================================================
-- DRAG
--========================================================

local dragging=false
local dragStart
local startPos

Top.InputBegan:Connect(function(i)

    if
        i.UserInputType==Enum.UserInputType.MouseButton1
        or i.UserInputType==Enum.UserInputType.Touch
    then

        dragging=true
        dragStart=i.Position
        startPos=Main.Position
    end
end)

UserInputService.InputEnded:Connect(function(i)

    if
        i.UserInputType==Enum.UserInputType.MouseButton1
        or i.UserInputType==Enum.UserInputType.Touch
    then

        dragging=false
    end
end)

UserInputService.InputChanged:Connect(function(i)

    if
        dragging
        and (
            i.UserInputType==Enum.UserInputType.MouseMovement
            or i.UserInputType==Enum.UserInputType.Touch
        )
    then

        local d=i.Position-dragStart

        Main.Position=UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset+d.X,
            startPos.Y.Scale,
            startPos.Y.Offset+d.Y
        )
    end
end)

--========================================================
-- ENTITY NOTIFICATIONS
--========================================================

local NotifyHolder=Instance.new("Frame",Gui)

NotifyHolder.Name="EntityNotifications"
NotifyHolder.AnchorPoint=Vector2.new(1,0)
NotifyHolder.Position=UDim2.new(1,-14,0,14)
NotifyHolder.Size=UDim2.fromOffset(330,560)
NotifyHolder.BackgroundTransparency=1
NotifyHolder.ClipsDescendants=false

local NotifyNames={
    Rush="RUSH",
    Ambush="AMBUSH",
    Screech="SCREECH",
    Eyes="EYES",
    Halt="HALT",
    Dupe="DUPE",
    Dread="DREAD",
    Glitch="GLITCH",
    Giggle="GIGGLE",
    Grumble="GRUMBLE",
    QueenGrumble="QUEEN GRUMBLE",
    Gloombats="GLOOMBATS",
    Louie="LOUIE",
    Jack="JACK",
    Hide="HIDE"
}

local ActiveNotifications={}

local NOTIFY_W=300
local NOTIFY_H=50
local NOTIFY_GAP=8

local function reflowNotifications()

    for i,card in ipairs(ActiveNotifications) do

        if card and card.Parent then

            TweenService:Create(
                card,
                TweenInfo.new(
                    .25,
                    Enum.EasingStyle.Quint,
                    Enum.EasingDirection.Out
                ),
                {
                    Position=UDim2.new(
                        1,
                        -NOTIFY_W,
                        0,
                        (i-1)*(NOTIFY_H+NOTIFY_GAP)
                    )
                }
            ):Play()
        end
    end
end

local function removeNotification(card)

    for i,v in ipairs(ActiveNotifications) do

        if v==card then

            table.remove(
                ActiveNotifications,
                i
            )

            break
        end
    end

    if card and card.Parent then
        card:Destroy()
    end

    reflowNotifications()
end

local function notify(entity)

    if
        entity=="Figure"
        or entity=="Seek"
        or not NotifyNames[entity]
    then
        return
    end

    local card=Instance.new("Frame",NotifyHolder)

    card.Name="EntityNotification"
    card.Size=UDim2.fromOffset(NOTIFY_W,NOTIFY_H)
    card.Position=UDim2.new(1,NOTIFY_W+25,0,0)
    card.BackgroundColor3=Color3.fromRGB(22,24,31)
    card.BackgroundTransparency=.05
    card.BorderSizePixel=0
    card.ZIndex=50

    Instance.new("UICorner",card).CornerRadius=UDim.new(0,9)

    local c=Colors[entity] or Theme.Accent

    local st=Instance.new("UIStroke",card)
    st.Color=c
    st.Thickness=1.5

    local bar=Instance.new("Frame",card)

    bar.Size=UDim2.fromOffset(4,NOTIFY_H)
    bar.BackgroundColor3=c
    bar.BorderSizePixel=0
    bar.ZIndex=51

    local txt=Instance.new("TextLabel",card)

    txt.BackgroundTransparency=1
    txt.Position=UDim2.fromOffset(14,0)
    txt.Size=UDim2.new(1,-20,1,0)
    txt.Font=Enum.Font.GothamBold
    txt.Text="⚠  "..NotifyNames[entity].." ЗАСПАВНИЛСЯ"
    txt.TextColor3=c
    txt.TextSize=14
    txt.TextXAlignment=Enum.TextXAlignment.Left
    txt.ZIndex=51

    table.insert(
        ActiveNotifications,
        card
    )

    reflowNotifications()

    TweenService:Create(
        card,
        TweenInfo.new(
            .45,
            Enum.EasingStyle.Quint,
            Enum.EasingDirection.Out
        ),
        {
            Position=UDim2.new(
                1,
                -NOTIFY_W,
                0,
                (#ActiveNotifications-1)*(NOTIFY_H+NOTIFY_GAP)
            )
        }
    ):Play()

    task.delay(3,function()

        if not card.Parent then
            return
        end

        TweenService:Create(
            card,
            TweenInfo.new(
                .45,
                Enum.EasingStyle.Quint,
                Enum.EasingDirection.In
            ),
            {
                Position=UDim2.new(
                    1,
                    NOTIFY_W+25,
                    0,
                    card.Position.Y.Offset
                )
            }
        ):Play()

        task.wait(.46)

        removeNotification(card)
    end)
end

--========================================================
-- ESP CORE
--========================================================

local ESP=Instance.new("Folder",Gui)
ESP.Name="CoalHubESP"

local ESPObjects={}

local Aliases={

    Rush={"Rush"},
    Ambush={"Ambush"},
    Screech={"Screech"},
    Eyes={"Eyes"},
    Seek={"Seek"},
    Figure={"Figure"},
    Halt={"Halt"},
    Dupe={"Dupe"},
    Dread={"Dread"},
    Glitch={"Glitch"},
    Giggle={"Giggle"},
    Grumble={"Grumble"},
    QueenGrumble={
        "QueenGrumble",
        "Queen Grumble"
    },
    Gloombats={
        "Gloombat",
        "Gloombats"
    },
    Louie={"Louie"},
    Jack={"Jack"},
    Hide={"Hide"}
}

local function hasName(name,list)

    name=string.lower(name)

    for _,x in ipairs(list) do

        if string.find(
            name,
            string.lower(x),
            1,
            true
        ) then

            return true
        end
    end

    return false
end

local function entityName(name)

    for e,list in pairs(Aliases) do

        if hasName(name,list) then
            return e
        end
    end
end

local function root(obj)

    if obj:IsA("BasePart") then
        return obj
    end

    if obj:IsA("Model") then

        return
            obj.PrimaryPart
            or obj:FindFirstChildWhichIsA(
                "BasePart",
                true
            )
    end
end

--========================================================
-- FIGURE BOOK DETECTION
--========================================================

local function glowingBook(obj)

    local n=string.lower(obj.Name)

    if not (
        string.find(
            n,
            "livehintbook",
            1,
            true
        )
        or
        string.find(
            n,
            "figurebook",
            1,
            true
        )
    ) then

        return false
    end

    for _,v in ipairs(
        obj:GetDescendants()
    ) do

        if
            v:IsA("PointLight")
            or v:IsA("SpotLight")
            or v:IsA("SurfaceLight")
            or v:IsA("Highlight")
            or v:IsA("ParticleEmitter")
            or v:IsA("Beam")
            or v:IsA("Trail")
        then

            return true
        end
    end

    return false
end

--========================================================
-- DOOR DETECTION
--========================================================

local function findDoorPart(obj)

    local d=obj:FindFirstChild("Door")

    if d and d:IsA("BasePart") then
        return d
    end

    for _,v in ipairs(
        obj:GetDescendants()
    ) do

        if
            v:IsA("BasePart")
            and (
                string.lower(v.Name)=="door"
                or string.lower(v.Name)=="doorpart"
            )
        then

            return v
        end
    end
end

local function doorPrompt(obj)

    for _,v in ipairs(
        obj:GetDescendants()
    ) do

        if
            v:IsA("ProximityPrompt")
            and v.Enabled
        then

            local a=string.lower(
                v.ActionText or ""
            )

            local o=string.lower(
                v.ObjectText or ""
            )

            if
                string.find(a,"open",1,true)
                or
                string.find(o,"door",1,true)
            then

                return v
            end
        end
    end
end

local function hasHandle(obj)

    for _,v in ipairs(
        obj:GetDescendants()
    ) do

        local n=string.lower(v.Name)

        if
            n=="handle"
            or n=="doorhandle"
            or n=="handlepart"
            or n=="knob"
        then

            return true
        end
    end

    return false
end

local function isDoor(obj)

    if
        not obj:IsA("Model")
        or
        not string.find(
            string.lower(obj.Name),
            "door",
            1,
            true
        )
    then

        return false
    end

    if not findDoorPart(obj) then
        return false
    end

    return
        doorPrompt(obj) ~= nil
        or
        hasHandle(obj)
end

--========================================================
-- CURRENT ROOM
--========================================================

local function currentRoom()

    local rooms=workspace:FindFirstChild(
        "CurrentRooms"
    )

    if not rooms then
        return nil
    end

    local hi=-1
    local cur

    for _,r in ipairs(
        rooms:GetChildren()
    ) do

        local n=tonumber(r.Name)

        if n and n>hi then

            hi=n
            cur=r
        end
    end

    return cur
end

--========================================================
-- DOOR NUMBER
--========================================================

local function doorNumber(obj)

    local n=tonumber(
        string.match(
            obj.Name,
            "%d+"
        )
    )

    if n then
        return n
    end

    for _,v in ipairs(
        obj:GetDescendants()
    ) do

        if
            v:IsA("TextLabel")
            or
            v:IsA("TextButton")
            or
            v:IsA("TextBox")
        then

            local x=tonumber(
                string.match(
                    v.Text or "",
                    "%d+"
                )
            )

            if x then
                return x
            end
        end
    end
end

--========================================================
-- CORRECT DOOR
--========================================================

local function correctDoor()

    local room=currentRoom()

    if not room then
        return nil
    end

    local roomN=tonumber(room.Name)

    local target=
        roomN
        and (roomN+1)
        or nil

    local best
    local fallback
    local bestN=-1

    for _,o in ipairs(
        room:GetDescendants()
    ) do

        if
            o:IsA("Model")
            and
            isDoor(o)
        then

            local n=doorNumber(o)

            -- Correct door normally has
            -- the next room number.
            if
                target
                and
                n==target
            then

                return o
            end

            -- Fallback for doors where
            -- the number is stored differently.
            if
                n
                and
                n>bestN
            then

                bestN=n
                fallback=o

            elseif
                not fallback
                and
                not n
            then

                fallback=o
            end
        end
    end

    return best or fallback
end

--========================================================
-- ADD ESP
--========================================================

local function addESP(
    obj,
    text,
    color,
    fill,
    typ
)

    if ESPObjects[obj] then

        local d=ESPObjects[obj]

        if d.H then

            d.H.FillColor=color
            d.H.OutlineColor=color
        end

        if d.L then

            d.L.Text=text
            d.L.TextColor3=color
        end

        d.Type=typ or d.Type

        return
    end

    local r=root(obj)

    if not r then
        return
    end

    local h=Instance.new(
        "Highlight",
        ESP
    )

    h.Name="CoalESP"
    h.Adornee=obj
    h.FillColor=color
    h.OutlineColor=color
    h.FillTransparency=fill or .7
    h.OutlineTransparency=0
    h.DepthMode=
        Enum.HighlightDepthMode.AlwaysOnTop

    local b=Instance.new(
        "BillboardGui",
        ESP
    )

    b.Name="CoalLabel"
    b.Adornee=r
    b.Size=UDim2.fromOffset(
        150,
        24
    )
    b.StudsOffset=
        Vector3.new(
            0,
            2.2,
            0
        )
    b.AlwaysOnTop=true

    local l=Instance.new(
        "TextLabel",
        b
    )

    l.Size=UDim2.fromScale(
        1,
        1
    )

    l.BackgroundTransparency=1
    l.Text=text
    l.TextColor3=color
    l.TextStrokeTransparency=0
    l.Font=Enum.Font.GothamBold
    l.TextSize=12

    ESPObjects[obj]={
        H=h,
        B=b,
        L=l,
        Type=typ
    }
end

--========================================================
-- REMOVE ESP
--========================================================

local function removeESP(obj)

    local d=ESPObjects[obj]

    if not d then
        return
    end

    if d.H then
        d.H:Destroy()
    end

    if d.B then
        d.B:Destroy()
    end

    ESPObjects[obj]=nil
end

--========================================================
-- ITEMS
--========================================================

local items={
    "Flashlight",
    "Lighter",
    "Candle",
    "Crucifix",
    "Vitamins",
    "Lockpick",
    "SkeletonKey",
    "Bulklight",
    "Glowstick",
    "Bandage",
    "Battery",
    "Fuse",
    "Pill"
}

local function itemMatch(n)

    n=string.lower(n)

    if string.find(
        n,
        "book",
        1,
        true
    ) then

        return false
    end

    for _,x in ipairs(items) do

        if string.find(
            n,
            string.lower(x),
            1,
            true
        ) then

            return true
        end
    end
end

--========================================================
-- CHECK OBJECT
--========================================================

local function check(obj)

    if
        not obj:IsA("Model")
        or
        not obj.Parent
    then

        return
    end

    local n=obj.Name
    local low=string.lower(n)
    local e=entityName(n)

    -- ENTITY ESP
    if
        e
        and
        S.Entities[e]
    then

        addESP(
            obj,
            e,
            Colors[e] or Theme.Accent,
            .55,
            "Entity"
        )

        return
    end

    -- FIGURE BOOK ESP
    if
        S.FigureBookESP
        and
        glowingBook(obj)
    then

        addESP(
            obj,
            "Figure Book",
            Colors.FigureBook,
            .45,
            "Book"
        )

        return
    end

    -- DOOR ESP
    if
        S.DoorESP
        and
        isDoor(obj)
    then

        local c=correctDoor()

        if c==obj then

            addESP(
                obj,
                "CORRECT DOOR",
                Colors.Correct,
                .82,
                "CorrectDoor"
            )

        else

            addESP(
                obj,
                "WRONG DOOR",
                Colors.Wrong,
                .82,
                "WrongDoor"
            )
        end

        return
    end

    -- KEY
    if
        S.KeyESP
        and
        string.find(
            low,
            "key",
            1,
            true
        )
    then

        addESP(
            obj,
            "Key",
            Colors.Key
        )

        return
    end

    -- GOLD
    if
        S.GoldESP
        and
        (
            string.find(
                low,
                "gold",
                1,
                true
            )
            or
            string.find(
                low,
                "coin",
                1,
                true
            )
        )
    then

        addESP(
            obj,
            "Gold",
            Colors.Gold
        )

        return
    end

    -- LEVER
    if
        S.LeverESP
        and
        (
            string.find(
                low,
                "lever",
                1,
                true
            )
            or
            string.find(
                low,
                "switch",
                1,
                true
            )
        )
    then

        addESP(
            obj,
            "Lever",
            Colors.Lever
        )

        return
    end

    -- HIDING SPOT
    if
        S.HidingSpotESP
        and
        (
            string.find(
                low,
                "closet",
                1,
                true
            )
            or
            string.find(
                low,
                "wardrobe",
                1,
                true
            )
        )
    then

        addESP(
            obj,
            "Hide Spot",
            Colors.HideSpot
        )

        return
    end

    -- ITEMS
    if
        S.ItemESP
        and
        itemMatch(n)
    then

        addESP(
            obj,
            n,
            Color3.fromRGB(
                80,
                255,
                180
            )
        )

        return
    end
end

--========================================================
-- ENTITY SPAWN DETECTION
--========================================================

local seen={}

local function detect(obj,announce)

    if not obj:IsA("Model") then
        return
    end

    local e=entityName(obj.Name)

    -- Figure and Seek are intentionally excluded.
    if
        not e
        or
        e=="Figure"
        or
        e=="Seek"
    then

        return
    end

    if not seen[obj] then

        seen[obj]=true

        if announce then
            notify(e)
        end
    end
end

-- Mark entities already existing
-- before the script started.
-- This prevents fake notifications.
task.defer(function()

    for _,obj in ipairs(
        workspace:GetDescendants()
    ) do

        if obj:IsA("Model") then
            detect(obj,false)
        end
    end
end)

-- NEW ENTITY / OBJECT
workspace.DescendantAdded:Connect(function(obj)

    task.defer(function()

        if obj:IsA("Model") then

            detect(
                obj,
                true
            )

            check(obj)
        end
    end)
end)

workspace.DescendantRemoving:Connect(function(obj)

    seen[obj]=nil

    if ESPObjects[obj] then
        removeESP(obj)
    end
end)

--========================================================
-- ESP STATUS
--========================================================

local function anyESP()

    if
        S.DoorESP
        or
        S.ItemESP
        or
        S.KeyESP
        or
        S.GoldESP
        or
        S.LeverESP
        or
        S.HidingSpotESP
        or
        S.FigureBookESP
    then

        return true
    end

    for _,v in pairs(
        S.Entities
    ) do

        if v then
            return true
        end
    end

    return false
end

--========================================================
-- ESP SCAN
--========================================================

local function scan()

    if not anyESP() then
        return
    end

    for _,o in ipairs(
        workspace:GetDescendants()
    ) do

        if o:IsA("Model") then

            check(o)

            -- Never show notification
            -- during normal scanning.
            detect(
                o,
                false
            )
        end
    end
end

--========================================================
-- CLEANUP
--========================================================

local function cleanup()

    for o,_ in pairs(
        ESPObjects
    ) do

        if
            not o.Parent
            or
            not o:IsDescendantOf(
                workspace
            )
        then

            removeESP(o)
        end
    end
end

--========================================================
-- SMART ESP LOOP
--========================================================

task.spawn(function()

    while task.wait(.8) do

        if anyESP() then

            scan()
            cleanup()

        else

            for o,_ in pairs(
                ESPObjects
            ) do

                removeESP(o)
            end
        end
    end
end)

--========================================================
-- DOOR ESP UPDATE
--========================================================

task.spawn(function()

    while task.wait(.35) do

        if not S.DoorESP then
            continue
        end

        -- Remove old door ESP.
        for o,d in pairs(
            ESPObjects
        ) do

            if
                d.Type=="CorrectDoor"
                or
                d.Type=="WrongDoor"
            then

                removeESP(o)
            end
        end

        local room=currentRoom()

        if room then

            local c=correctDoor()

            for _,o in ipairs(
                room:GetDescendants()
            ) do

                if
                    o:IsA("Model")
                    and
                    isDoor(o)
                then

                    if o==c then

                        addESP(
                            o,
                            "CORRECT DOOR",
                            Colors.Correct,
                            .82,
                            "CorrectDoor"
                        )

                    else

                        addESP(
                            o,
                            "WRONG DOOR",
                            Colors.Wrong,
                            .82,
                            "WrongDoor"
                        )
                    end
                end
            end
        end
    end
end)

--========================================================
-- PLAYER / MOVEMENT / CAMERA
--========================================================

RunService.Stepped:Connect(function()

    -- FULLBRIGHT
    if S.Fullbright then

        Lighting.Brightness=2
        Lighting.ClockTime=14
        Lighting.FogEnd=100000
        Lighting.GlobalShadows=false
        Lighting.ExposureCompensation=1
    end

    -- NOCLIP
    if
        S.Noclip
        and
        LP.Character
    then

        for _,p in ipairs(
            LP.Character:GetDescendants()
        ) do

            if p:IsA("BasePart") then
                p.CanCollide=false
            end
        end
    end

    -- CAMERA
    if
        S.LockCamera
        and
        S.ThirdPerson
    then

        LP.CameraMaxZoomDistance=
            S.CameraDistance

        LP.CameraMinZoomDistance=
            S.CameraDistance
    end

    -- MOVEMENT
    local h=
        LP.Character
        and
        LP.Character:FindFirstChildOfClass(
            "Humanoid"
        )

    if h then

        h.WalkSpeed=
            S.WalkSpeed

        h.UseJumpPower=true

        h.JumpPower=
            S.JumpPower
    end
end)

--========================================================
-- INFINITE JUMP
--========================================================

UserInputService.JumpRequest:Connect(function()

    if not S.InfiniteJump then
        return
    end

    local h=
        LP.Character
        and
        LP.Character:FindFirstChildOfClass(
            "Humanoid"
        )

    if h then

        h:ChangeState(
            Enum.HumanoidStateType.Jumping
        )
    end
end)

--========================================================
-- FPS
--========================================================

local started=tick()

local fps=0
local frames=0
local last=tick()

RunService.RenderStepped:Connect(function()

    frames+=1

    if tick()-last>=1 then

        fps=frames
        frames=0
        last=tick()
    end
end)

--========================================================
-- ROOM
--========================================================

local function roomNumber()

    local r=currentRoom()

    if r then
        return r.Name
    end

    return "?"
end

--========================================================
-- HUD UPDATE
--========================================================

task.spawn(function()

    while task.wait(.25) do

        local a={}

        if S.HUD.FPS then

            table.insert(
                a,
                "FPS: "..fps
            )
        end

        if S.HUD.Ping then

            local p=0

            pcall(function()

                p=math.floor(
                    LP:GetNetworkPing()
                    *1000
                )
            end)

            table.insert(
                a,
                "Ping: "..p.." ms"
            )
        end

        if S.HUD.Room then

            table.insert(
                a,
                "Room: "..roomNumber()
            )
        end

        if S.HUD.Players then

            table.insert(
                a,
                "Players: "..#Players:GetPlayers()
            )
        end

        if S.HUD.Time then

            local t=
                math.floor(
                    tick()-started
                )

            table.insert(
                a,
                string.format(
                    "Time: %02d:%02d",
                    math.floor(t/60),
                    t%60
                )
            )
        end

        HUDText.Text=
            table.concat(
                a,
                "\n"
            )
    end
end)

--========================================================
-- RIGHT SHIFT
--========================================================

UserInputService.InputBegan:Connect(function(i,p)

    if p then
        return
    end

    if
        i.KeyCode==
        Enum.KeyCode.RightShift
    then

        Main.Visible=
            not Main.Visible

        Mini.Visible=
            not Main.Visible
    end
end)

--========================================================
-- START
--========================================================

print(
    "Coal Hub DOORS • Hotel + Mines • FULL UPDATED loaded."
)

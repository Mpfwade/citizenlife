local function ixActMenu()
    local animation = {"/Actstand", "/Actsit", "/Actsitwall", "/Actcheer", "/Actlean", "/Actinjured", "/Actarrestwall", "/Actarrest", "/Actthreat", "/Actdeny", "/Actmotion", "/Actwave", "/Actpant", "/ActWindow"}

    local animationdesc = {"Stand here", "Sit", "Sit against a wall", "Cheer", "Lean against a wall", "Lay on the ground injured", "Face a wall", "Put your hands on your head", "Threat", "Deny", "Motion", "Wave", "Pant", "Lay against a window"}

    local frame = vgui.Create("DFrame")
    frame:SetSize(600, 500)
    frame:SetTitle("Character Menu")
    frame:MakePopup()
    frame:Center()
    local left = vgui.Create("DScrollPanel", frame)
    left:Dock(LEFT)
    left:SetWidth(frame:GetWide() / 2 - 7)
    left:SetPaintBackground(true)
    left:DockMargin(0, 0, 4, 0)
    local right = vgui.Create("DScrollPanel", frame)
    right:Dock(FILL)
    right:SetPaintBackground(true)

    for i = 1, 14 do
        local but = vgui.Create("DButton", frame)
        but:SetText(animationdesc[i])
        but:SetFont("ixMonoMediumFont")
        but:SetSize(36, 24)
        but:Dock(TOP)

        but.DoClick = function()
            frame:Close()
            RunConsoleCommand("say", animation[i])
        end

        right:AddItem(but)
    end

    local Perso = vgui.Create("DLabel", frame)
    Perso:Dock(TOP)
    Perso:DockMargin(8, 0, 0, 0)
    Perso:SetFont("AdminChatFont")
    Perso:SetText("Name : " .. LocalPlayer():GetCharacter():GetName())
    Perso:SetSize(36, 21)
    left:AddItem(Perso)
    local faction = ix.faction.indices[LocalPlayer():GetCharacter():GetFaction()]
    local Perso = vgui.Create("DLabel", frame)
    Perso:Dock(TOP)
    Perso:DockMargin(8, 0, 0, 0)
    Perso:SetFont("AdminChatFont")
    Perso:SetText("Faction : " .. faction.name)
    Perso:SetSize(36, 20)
    left:AddItem(Perso)
    local Perso = vgui.Create("DLabel", frame)
    Perso:Dock(TOP)
    Perso:DockMargin(8, 0, 0, 0)
    Perso:SetFont("AdminChatFont")
    Perso:SetText("Tokens : " .. ix.currency.Get(LocalPlayer():GetCharacter():GetMoney()))
    Perso:SetSize(36, 20)
    left:AddItem(Perso)
    local Perso = vgui.Create("DLabel", frame)
    local healthText = "I feel Healthy"
    local health = LocalPlayer():Health()
    Perso:Dock(TOP)
    Perso:DockMargin(8, 0, 0, 0)
    Perso:SetFont("AdminChatFont")
    Perso:SetSize(36, 20)
    left:AddItem(Perso)

    if health >= 100 then
        healthText = "I feel healthy"
        surface.SetTextColor(Color(0, 255, 0, 255))
    elseif health >= 80 then
        healthText = "I think I'm wounded"
        surface.SetTextColor(Color(200, 180, 0, 255))
    elseif health >= 60 then
        healthText = "I'm pretty sure I broke something"
        surface.SetTextColor(Color(210, 150, 0, 255))
    elseif health >= 40 then
        healthText = "I'm injured"
        surface.SetTextColor(Color(230, 100, 0, 255))
    elseif health >= 20 then
        healthText = "IT HURTS BADLY!"
        surface.SetTextColor(Color(230, 40, 0, 255))
    else
        healthText = "I-I think I'm dying..."
        surface.SetTextColor(Color(150, 0, 0, math.random(100, 255)))
    end

    Perso:SetText("Health : " .. healthText)
    local Perso = vgui.Create("DLabel", frame)
    local armorText = "I feel protected"
    local armor = LocalPlayer():Armor()
    Perso:Dock(TOP)
    Perso:DockMargin(8, 0, 0, 0)
    Perso:SetFont("AdminChatFont")
    Perso:SetSize(36, 20)
    left:AddItem(Perso)

    if armor >= 100 then
        armorText = "I feel well protected"
        surface.SetTextColor(Color(0, 255, 0, 255))
    elseif armor >= 80 then
        armorText = "I feel protected"
        surface.SetTextColor(Color(200, 180, 0, 255))
    elseif armor >= 60 then
        armorText = "I feel pretty protected"
        surface.SetTextColor(Color(210, 150, 0, 255))
    elseif armor >= 40 then
        armorText = "I sorta feel protected"
        surface.SetTextColor(Color(230, 100, 0, 255))
    elseif armor >= 20 then
        armorText = "I barely feel protected"
        surface.SetTextColor(Color(230, 40, 0, 255))
    elseif armor >= 10 then
        armorText = "I don't really feel protected at all"
        surface.SetTextColor(Color(230, 40, 0, 255))
    else
        armorText = "I don't have any armor"
        surface.SetTextColor(Color(150, 0, 0, math.random(100, 255)))
    end

    Perso:SetText("Armor : " .. armorText)
    local Perso = vgui.Create("DLabel", frame)
    local hungerText = "I'm stuffed"
    local hunger = LocalPlayer():GetCharacter():GetHunger()
    Perso:Dock(TOP)
    Perso:DockMargin(8, 0, 0, 0)
    Perso:SetFont("AdminChatFont")
    Perso:SetSize(36, 20)
    left:AddItem(Perso)

    if hunger >= 100 then
        hungerText = "I'm stuffed"
        surface.SetTextColor(Color(0, 255, 0, 255))
    elseif hunger >= 80 then
        hungerText = "I'm pretty satisfied"
        surface.SetTextColor(Color(200, 180, 0, 255))
    elseif hunger >= 60 then
        hungerText = "I'm getting hungry"
        surface.SetTextColor(Color(210, 150, 0, 255))
    elseif hunger >= 40 then
        hungerText = "I'm getting really hungry."
        surface.SetTextColor(Color(230, 100, 0, 255))
    elseif hunger >= 20 then
        hungerText = "I'm starving"
        surface.SetTextColor(Color(230, 40, 0, 255))
    else
        hungerText = "I NEED FOOD NOW!"
        surface.SetTextColor(Color(150, 0, 0, math.random(100, 255)))
    end

    Perso:SetText("Hunger : " .. hungerText)

    if LocalPlayer():Team() == FACTION_CITIZEN then
        local Perso = vgui.Create("DLabel", frame)
        Perso:Dock(TOP)
        Perso:DockMargin(8, 0, 0, 0)
        Perso:SetFont("AdminChatFont")
        Perso:SetText("Loyalty Points : " .. LocalPlayer():GetLP())
        Perso:SetSize(36, 20)
        left:AddItem(Perso)
        local Perso = vgui.Create("DLabel", frame)
        Perso:Dock(TOP)
        Perso:DockMargin(8, 0, 0, 0)
        Perso:SetFont("AdminChatFont")
        Perso:SetText("Warmth : " .. LocalPlayer():GetCharacter():GetWarmth())
        Perso:SetSize(36, 20)
        left:AddItem(Perso)
        local but = vgui.Create("DButton", frame)
        but:SetText("Apply")
        but:SetFont("ixMonoMediumFont")
        but:SetSize(36, 50)
        but:Dock(TOP)

        but.DoClick = function()
            frame:Close()
            RunConsoleCommand("say", "/apply")
        end

        left:AddItem(but)
        local mat = vgui.Create("Material", frame)
        local modelPic = "citizenlifestuff/male04silhouette.png"
        local model = LocalPlayer():GetCharacter():GetFaction()
        mat:SetPos(0, 210)
        mat:SetSize(295, 255)
        left:AddItem(mat)
        mat:SetMaterial(modelPic)
        mat.AutoSize = false
    end

    if LocalPlayer():IsCombine() then
        local Perso = vgui.Create("DLabel", frame)
        Perso:Dock(TOP)
        Perso:DockMargin(8, 0, 0, 0)
        Perso:SetFont("AdminChatFont")
        Perso:SetText("Rank Points : " .. LocalPlayer():GetRP())
        Perso:SetSize(36, 20)
        left:AddItem(Perso)
        local bot = vgui.Create("DButton", frame)
        bot:SetText("Tie")
        bot:SetFont("ixMonoMediumFont")
        bot:SetSize(36, 50)
        bot:Dock(TOP)

        bot.DoClick = function()
            frame:Close()
            RunConsoleCommand("say", "/tie")
        end

        left:AddItem(bot)
        local bot = vgui.Create("DButton", frame)
        bot:SetText("Search")
        bot:SetFont("ixMonoMediumFont")
        bot:SetSize(36, 50)
        bot:Dock(TOP)

        bot.DoClick = function()
            frame:Close()
            RunConsoleCommand("say", "/Search")
        end

        left:AddItem(bot)
        local code3 = vgui.Create("DButton", frame)
        code3:SetText("Code 3")
        code3:SetFont("ixMonoMediumFont")
        code3:SetSize(36, 50)
        code3:Dock(TOP)

        code3.DoClick = function()
            frame:Close()
            RunConsoleCommand("say", "/code3")
        end

        left:AddItem(code3)
        local code2 = vgui.Create("DButton", frame)
        code2:SetText("Code 2")
        code2:SetFont("ixMonoMediumFont")
        code2:SetSize(36, 50)
        code2:Dock(TOP)

        code2.DoClick = function()
            frame:Close()
            RunConsoleCommand("say", "/code2")
        end

        left:AddItem(code2)
        local code2 = vgui.Create("DButton", frame)
        code2:SetText("Data Interface")
        code2:SetFont("ixMonoMediumFont")
        code2:SetSize(36, 50)
        code2:Dock(TOP)

        code2.DoClick = function()
            frame:Close()
            RunConsoleCommand("say", "/datapad")
        end

        left:AddItem(code2)
        local butt = vgui.Create("DButton", frame)
        butt:SetText("Team Menu")
        butt:SetFont("ixMonoMediumFont")
        butt:SetSize(36, 50)
        butt:Dock(TOP)

        butt.DoClick = function()
            frame:Close()
            RunConsoleCommand("say", "/squadmenu")
        end

        left:AddItem(butt)
    end
end

usermessage.Hook("ixActMenu", ixActMenu)
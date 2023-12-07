local PLUGIN = PLUGIN
PLUGIN.name = "Employment"
PLUGIN.author = "Adolphus"
PLUGIN.description = "Adds a basic employment system using ID terminals to give paygrades and occupation names."
ix.util.Include("sv_hooks.lua")
ix.util.IncludeDir(PLUGIN.folder .. "/commands", true)
ix.util.IncludeDir(PLUGIN.folder .. "/meta", true)

if CLIENT then
    netstream.Hook("OpenCIDMenu", function(data)
        vgui.Create("ixCIDCreater")
    end)

    netstream.Hook("OpenQuizMenu", function(data)
        vgui.Create("ixJobQuiz")
    end)

    netstream.Hook("ViewData", function(target, cid, data, cpData)
        Schema:AddCombineDisplayMessage("@cViewData")
        vgui.Create("ixRecordPanel"):Build(target, cid, data, cpData)
    end)
end

if SERVER then
    netstream.Hook("SubmitNewCID", function(client, data)
        if client:IsCombine() or client:GetCharacter():HasFlags("i") then
            local character = client:GetCharacter()
            local inventory = character:GetInventory()
            if not character or not inventory then return end

            if data.item then
                inventory:Remove(data.item)
            end

            local format = "%A, %B %d, %Y. %H:%M:%S"

            inventory:Add("cid", 1, {
                citizen_name = data[1],
                cid = data[2],
                employment = data[5],
                issue_date = ix.date.GetFormatted(format),
                officer = client:Name(),
                cca = isCombine
            })

            client:EmitSound("buttons/button14.wav", 100, 25)
            client:ForceSequence("harassfront1")
        end

        ix.log.AddRaw(client:Name() .. " has created a new CID with the name " .. data[1])
    end)

    netstream.Hook("SubmitCPPaper", function(client, applicationText)
        if client:Team() == FACTION_CITIZEN then
            local character = client:GetCharacter()

            if character then
                character:SetData("submitted", true)
                -- Store the application text in a database or perform any other necessary operations
                print("Application text:", applicationText)
            end
        end
    end)

    ix.command.Add("Apply", {
        description = "Prints your Name and CID Info.",
        OnRun = function(_, ply)
            local char = ply:GetCharacter()

            if (ply:Team() == FACTION_CITIZEN) and char:GetInventory():HasItem("cid") then
                ply:EmitSound("physics/cardboard/cardboard_box_impact_soft7.wav")
                ix.chat.Send(ply, "me", "shows their identification card showing: (Name: " .. ply:Nick() .. " | CID: " .. char:GetData("cid", "00000") .. ") ", false)
                ply:ConCommand("ix_act_Point")
            elseif (ply:Team() == FACTION_CITIZEN) and char:GetInventory():HasItem("transfer_papers") then
                ply:EmitSound("physics/cardboard/cardboard_box_impact_soft7.wav")
                ix.chat.Send(ply, "me", "shows their relocation coupon.", false)
                ply:ConCommand("ix_act_Point")
            else
                return ply:ChatNotifyLocalized("You need a card!")
            end
        end
    })

    function PLUGIN:PlayerLoadedCharacter(client, char, currentChar)
        char:SetData("submitted", false)
    end
end
ITEM.name = "Relocations Acceptance Permit"
ITEM.model = "models/gibs/metal_gib4.mdl"
ITEM.description = "A card, indicating your new relocation status."
ITEM.category = "Other"
ITEM.noBusiness = true
ITEM.noDrop = false
ITEM.bDropOnDeath = false
ITEM.weight = 0

-- CLIENT-SIDE FUNCTIONS
if CLIENT then
    function ITEM:PaintOver(item, w, h)
        ix.util.DrawText("!", w - 8, h - 19, Color(218, 171, 3, 255), 0, 0, "ixSmallFont")
    end

    function ITEM:PopulateTooltip(tooltip)
        local data = tooltip:AddRow("data")
        data:SetBackgroundColor(derma.GetColor("Success", tooltip))
        data:SetText("Name: " .. self:GetData("citizen_name", "Unissued") .. "\nTransfer Number: " .. self:GetData("unique", "N/A") .. "\nIssue Date: " .. self:GetData("issue_date", "Unissued"))
        data:SetFont("BudgetLabel")
        data:SetExpensiveShadow(0.5)
        data:SizeToContents()

        local data2 = tooltip:AddRow("data2")
        data2:SetBackgroundColor(derma.GetColor("Warning", tooltip))
        data2:SetText("Take this coupon to a Civil Protection Officer to receive a CID in return (NOT VALID IDENTIFICATION).")
        data2:SetFont("DermaDefault")
        data2:SetExpensiveShadow(0.5)
        data2:SizeToContents()
    end

    function ITEM:ShowCustomMenu()
  
        surface.PlaySound("physics/cardboard/cardboard_box_break3.wav")
      
        local frame = vgui.Create("DFrame")
        frame:SetTitle("Relocation Information")
        frame:SetSize(ScrW() * 0.4, ScrH() * 0.9)
        frame:Center()
        frame:MakePopup()
        
        local backgroundMaterial = Material("citizenlifestuff/documents/relocation_coupon.png")
    
        if self:GetData("approved", false) then
            backgroundMaterial = Material("citizenlifestuff/citizenlifenotext.png")
        end
    
        frame.Paint = function(_, w, h)
            -- attempt at drawing a overlay to darken the mat, come back to this tommorow and go to bed
            surface.SetDrawColor(50, 50, 50, 255) -- Dark grey overlay
            surface.DrawRect(0, 0, w, h)
    
            surface.SetDrawColor(255, 255, 255, 255)
            surface.SetMaterial(backgroundMaterial)
            surface.DrawTexturedRect(0, 0, w, h)
        end
    
        local citizenName = vgui.Create("DLabel", frame)
        citizenName:SetText("Citizen Name: " .. self:GetData("citizen_name", "Unissued"))
        citizenName:SetFont("Trebuchet24")
        citizenName:SizeToContents()
        citizenName:SetPos(10, 30)
    
        -- Display transfer number
        local transferNumber = vgui.Create("DLabel", frame)
        transferNumber:SetText("Transfer Number: " .. self:GetData("unique", "N/A"))
        transferNumber:SetFont("Trebuchet24")
        transferNumber:SizeToContents()
        transferNumber:SetPos(10, 70)
    
        -- Display issue date
        local issueDate = vgui.Create("DLabel", frame)
        issueDate:SetText("Issue Date: " .. self:GetData("issue_date", "Unissued"))
        issueDate:SetFont("Trebuchet24")
        issueDate:SizeToContents()
        issueDate:SetPos(10, 110)
    
        -- Display instructions
        local instructions = vgui.Create("DLabel", frame)
        instructions:SetText("Take this coupon to a Civil Protection Officer to receive a CID in return (NOT VALID IDENTIFICATION).")
        instructions:SetFont("Trebuchet24")
        instructions:SetWrap(true)
        instructions:SetSize(frame:GetWide() - 20, 60)
        instructions:SetPos(10, 150)
    
        -- Approve button setup
        local approveButton = frame:Add("DButton")
        approveButton:SetText("Approve ID")
        approveButton:Dock(BOTTOM)
        approveButton.DoClick = function()
            net.Start("ixApproveRelocationCoupon")
            net.WriteUInt(self.id, 32)
            net.SendToServer()
            frame:Close()
        end
    
        -- Disable the button if the player lacks the EMP tool
        if not LocalPlayer():GetCharacter():GetInventory():HasItem("emp") then
            approveButton:SetDisabled(true)
        end
    end
end
-- SERVER-SIDE FUNCTIONS
if SERVER then
    util.AddNetworkString("ixApproveRelocationCoupon")

    net.Receive("ixApproveRelocationCoupon", function(_, ply)
        local itemID = net.ReadUInt(32)
        local item = ix.item.instances[itemID]

        if item and ply:GetCharacter() then
            local inventory = ply:GetCharacter():GetInventory()

            if inventory:HasItem("emp") then
                inventory:HasItem("emp"):Remove()
                item:SetData("approved", true)
                ply:Notify("Relocation coupon approved.")
            else
                ply:Notify("You need an EMP tool to approve the coupon.")
            end
        else
            ply:Notify("Approval failed.")
        end
    end)
end

-- Custom function to view the coupon
ITEM.functions.View = {
    name = "View",
    icon = "icon16/information.png",
    OnClick = function(item)
        if CLIENT then
            item:ShowCustomMenu()
        end
        return true
    end,
    OnCanRun = function(item)
        return !IsValid(item.entity)
    end
}
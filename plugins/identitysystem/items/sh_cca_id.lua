-- Item Statistics

ITEM.name = "Civil Protection Identiband"
ITEM.description = "Used to unlock combine doors"
ITEM.category = "Tools"
ITEM.bDropOnDeath = false
ITEM.noDrop = false

-- Item Configuration

ITEM.model = "models/sky/combinecard2.mdl"
ITEM.skin = 0

-- Item Inventory Size Configuration

ITEM.width = 1
ITEM.height = 1
ITEM.weight = 1.36

-- Item Custom Configuration

ITEM.price = 160

-- Item Functions

function ITEM:PopulateTooltip(tooltip)
	local data = tooltip:AddRow("data")	
	data:SetBackgroundColor(derma.GetColor("Info", data))
	data:SetText("Name: " .. self:GetData("citizen_name", "Unissued") .. 
	"\nID Number: " .. self:GetData("cid", "00000") .. 
	"\nApartment: " .. self:GetData("employment", "Homeless") ..
	"\nIssue Date: " .. self:GetData("issue_date", "Unissued"))

	data:SetFont("BudgetLabel")
	data:SetExpensiveShadow(0.5)
	data:SizeToContents()

	local warning = tooltip:AddRow("warning")
	warning:SetBackgroundColor(derma.GetColor("Error", tooltip))
	warning:SetText("Each card has an RFID chip and a photo of whoever was present at the time of it being issued.")
	warning:SetFont("DermaDefault")
	warning:SetExpensiveShadow(0.5)
	warning:SizeToContents()
end

ITEM.functions.OverloadDoor = {
    name = "Open Door",
    icon = "icon16/shield_add.png",
    OnRun = function(itemTable)
        local ply = itemTable.player
        local data = {}
            data.start = ply:GetShootPos()
            data.endpos = data.start + ply:GetAimVector() * 96
            data.filter = ply
        local target = util.TraceLine(data).Entity

        if IsValid(target) and target:IsDoor() then
            if not (target:HasSpawnFlags(256) and target:HasSpawnFlags(1024)) then
                ply:Freeze(true)
                ply:SetAction("Scanning...", 1, function()
                    ply:Freeze(false)
                    target:Fire("open")
                    target:Fire("unlock")
                    ply:EmitSound("buttons/combine_button1.wav")
                    ply:Notify("Identity Confirmed, you may proceed.")
                end)
            end
        else
            ply:Notify("You must be looking at a combine door")
        end

        return false
    end
}
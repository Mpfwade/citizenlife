local PLUGIN = PLUGIN

PLUGIN.name = "Jury Division Update"
PLUGIN.author = "Riggs Mackay"
PLUGIN.description = "Adds Features and improvements to the Jury Division in Lite Network."

ix.inspect = ix.inspect or {}
ix.inspect.description = ix.inspect.description or {}
ix.inspect.detail = ix.inspect.detail or {}

ix.util.Include("sv_plugin.lua")

if ( CLIENT ) then
    ix.inspect.description = {
        ["tfa_ins2_mp7"] = {"That the corpse contains 4.65mm rounds.", 2},
        ["tfa_m1a1_thompson"] = {"That the corpse contains 120mm rounds.", 2},
        ["weapon_357"] = {"That the corpse contains .357 rounds.", 2},
        ["tfa_verdun_pattern1914_remastered"] = {"That the corpse contains 7.7mm rounds.", 2},
        ["tfa_verdun_springfield1903"] = {"That the corpse contains 7.7mm rounds.", 2},
        ["tfa_ins2_remington_m870"] = {"That the corpse has been ripped apart by buckshot rounds.", 2},
        ["tfa_ins2_spas12"] = {"That the corpse has been ripped apart by buckshot rounds.", 2},
        ["tfa_ocipr"] = {"That the corpse has been pentrated by a high energy round which has left burn marks.", 3},
        ["tfa_osips"] = {"That the corpse has been pentrated by a high energy round which has left burn marks.", 3},
        ["tfa_suppressor"] = {"That the corpse has been pentrated by a high energy round which has left burn marks.", 3},
        ["tfa_heavyshotgun"] = {"That the corpse has been pentrated by a high energy round which has left burn marks.", 3},
        ["ix_cmb_sniper"] = {"That the corpse has been pentrated by a high energy round which has left burn marks, probably from far away.", 3},
        ["weapon_crowbar"] = {"That the corpse has been slashed with big wounds.", 1},
        ["ls_axe"] = {"That the corpse has been hacked and slashed.", 1},
        ["ls_pickaxe"] = {"That the corpse has been hacked and slashed.", 1},
        ["ix_zombie_claws"] = {"That the corpse has been slashed with sharp wounds.", 1},
        ["ix_stunstick"] = {"That the corpse has several burn wounds commonly created by contact with a charged stun baton.", 1},
        ["tfa_ins2_usp_match"] = {"That the corpse contains 9mm rounds.", 2},
        ["ix_vort_beam"] = {"That the corpse has sustained electrical and plasma burns by an extremely powerful force.", 1},
        ["weapon_crossbow"] = {"That the corpse has sustained multiple bolts in their body, mostly caused by a crossbow.", 1},
    }
    ix.inspect.detail = {
        [1] = "That the corpse has sustained blunt damage.",
        [2] = "That the corpse has several bullet entry and exit wounds. Bullet fragments are still present in the body.",
        [3] = "That the corpse has burn marks and shrapnel entry wounds. Possibly caused by an explosion.",
        [4] = "That the corpse has broken and fractured legs. The torso is severely bruised."
    }
    
    net.Receive("ixInspectBodyFinish", function(len, ply)
        local usedWeapon = net.ReadString()
        local victimName = net.ReadString()
        local attacker = net.ReadEntity()
        local weaponDescription = ix.inspect.description[usedWeapon]
        local message = "You have inspected the body, therefor you revealed the following..\n"

        if ( weaponDescription ) then
            message = message.."\n"..ix.inspect.detail[weaponDescription[2]]
            message = message.."\n"..weaponDescription[1]
        end

        if ( attacker:IsValid() and attacker:IsPlayer() and ( victimName:find("CCA:") or victimName:find("OTA:") ) ) then
            message = message.."\n\nAfter review of the bodycam footage the suspect who killed "..victimName.." has been identified as "..attacker:Nick().."."
            message = message.."\nThey have automatically been added to the BOL index."
        end
        
        Derma_Message(message, "Body Inspection Complete!", "Close")
    end)
end
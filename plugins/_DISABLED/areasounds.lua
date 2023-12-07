local PLUGIN = PLUGIN
PLUGIN.name = "Area-Music"
PLUGIN.author = "Wade and Mostly Skay"
PLUGIN.description = "Plays music in some areas."

ix.config.Add("area-music", true, "Should the music be on?.", nil, {
    category = PLUGIN.name
})
--[[
elseif new == "" then
client:EmitSound("music/")
elseif old == "" then
client:StopSound("music/")
client:EmitSound("ambient/atmosphere/hole_hit1.wav") 
--]]
function PLUGIN:OnPlayerAreaChanged(client, old, new)
    if new == "Residential Block 1" then
        client:EmitSound("music/hl1_song9.mp3", 37)
    elseif old == "Residential Block 1" then
        client:StopSound("music/hl1_song9.mp3")
        client:EmitSound("ambient/atmosphere/hole_hit1.wav", 37)

    elseif new == "404 Zone" then
        client:EmitSound("music/HL1_song5.mp3", 37)
    elseif old == "404 Zone" then
        client:StopSound("music/HL1_song5.mp3")
        client:EmitSound("ambient/atmosphere/hole_hit1.wav", 37)

    elseif new == "Prison" then
        client:EmitSound("music/HL2_song19.mp3", 37)
    elseif old == "Prison" then
        client:StopSound("music/HL2_song19.mp3")
        client:EmitSound("ambient/atmosphere/hole_hit1.wav", 37)

    elseif new == "Nexus Entrance" then
        client:EmitSound("music/hl2_song25_teleporter.mp3", 37)
    elseif old == "Nexus Entrance" then
        client:StopSound("music/hl2_song25_teleporter.mp3")
        client:EmitSound("ambient/atmosphere/hole_hit1.wav", 37)

    elseif new == "PATH TO THE OUTLANDS" then
        client:EmitSound("music/hl1_song9.mp3", 37)
    elseif old == "PATH TO THE OUTLANDS" then
        client:StopSound("music/hl1_song9.mp3")
        client:EmitSound("ambient/atmosphere/hole_hit1.wav", 37)

    elseif new == "Warehouse 3" then
        client:EmitSound("music/a5_vault_sideways_piano.mp3")
    elseif old == "Warehouse 3" then
        client:StopSound("music/a5_vault_sideways_piano.mp3")
        client:EmitSound("ambient/atmosphere/hole_hit1.wav")

    elseif new == "Residential Block 2" then
        client:EmitSound("ambient/a1_intro_apt_radio.wav", 37)
    elseif old == "Residential Block 2" then
        client:StopSound("ambient/a1_intro_apt_radio.wav")
        client:EmitSound("ambient/atmosphere/hole_hit1.wav", 37)

    elseif new == "Intake-Hub 1" then
        client:EmitSound("music/hl2_song2.mp3", 37)
    elseif old == "Intake-Hub 1" then
        client:StopSound("music/hl2_song2.mp3")
        client:EmitSound("ambient/atmosphere/hole_hit1.wav", 37)

    elseif new == "Sector-1" then
        client:EmitSound("music/a1_intro_world_2.mp3", 37)
    elseif old == "Sector-1" then
        client:StopSound("music/a1_intro_world_2.mp3")
        client:EmitSound("ambient/atmosphere/hole_hit1.wav", 37) 

    elseif new == "Sector-2" then
        client:EmitSound("music/hl2_song1.mp3", 37)
    elseif old == "Sector-2" then
        client:StopSound("music/hl2_song1.mp3")
        client:EmitSound("ambient/atmosphere/hole_hit1.wav", 37) 

    elseif new == "Sector-3" then
        client:EmitSound("music/hl2_song33.mp3", 37)
    elseif old == "Sector-3" then
        client:StopSound("music/hl2_song33.mp3")
        client:EmitSound("ambient/atmosphere/hole_hit1.wav", 37) 

    elseif new == "RB-1 Storage" then
        client:EmitSound("music/a3_rooftop_crab_hotel_dark.mp3", 37)
    elseif old == "RB-1 Storage" then
        client:StopSound("music/a3_rooftop_crab_hotel_dark.mp3")
        client:EmitSound("ambient/atmosphere/hole_hit1.wav", 37) 

    elseif new == "Rebel Hideout" then
        client:EmitSound("music/vlvx_song20.mp3", 37)
    elseif old == "Rebel Hideout" then
        client:StopSound("music/vlvx_song20.mp3")
        client:EmitSound("ambient/atmosphere/hole_hit1.wav", 37) 

    elseif new == "Under Hideout" then
        client:EmitSound("music/vlvx_song3.mp3", 37)
    elseif old == "Under Hideout" then
        client:StopSound("music/vlvx_song3.mp3")
        client:EmitSound("ambient/atmosphere/hole_hit1.wav", 37)
        
    elseif new == "PRISONER TRANSPORT 2491" then
        client:EmitSound("music/stingers/hl1_stinger_song27.mp3", 37)
        elseif old == "PRISONER TRANSPORT 2491" then
        client:StopSound("music/stingers/hl1_stinger_song27.mp3")
        client:EmitSound("ambient/atmosphere/hole_hit1.wav", 37) 

    elseif new == "PRISONER INSERT" then
        client:EmitSound("music/hl2_song0.mp3", 37)
        elseif old == "PRISONER INSERT" then
        client:StopSound("music/hl2_song0.mp3")
        client:EmitSound("ambient/atmosphere/hole_hit1.wav", 37) 
        end
    end

    



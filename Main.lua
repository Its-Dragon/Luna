-- Started 7/21/21

local font = draw.CreateFont("Segoe UI", 18, 700, {0x010})
local uid = cheat.GetUserID()
local name = cheat.GetUserName()
local real = nil
local lby = nil
local kills = "nil"
local deaths = "nil"
local kd = "nil"
local ping = ""
local defusing = false
local defusestatus = "Not Defused"
local plantedat = 0
local planter = "Not Planted"
local planting = false
local bomb_planted = false
local bomb_exploded = false
local plantingStarted = 0
local plantstatus = "Not Planted"
local alpha = {}
local players = {activity = {}}
local round_ended = false
local ip = ""
local screenX, screenY = draw.GetScreenSize(x,y)
local switch = false
local color = 1
local time = globals.CurTime()
local origcolor = client.GetConVar( "cl_hud_color" )

local ref1 = gui.Reference( "Misc", "General", "Extra" )
local ref2 = gui.Reference( "Settings", "Theme" )
local Luna_group = gui.Groupbox(ref2, "Luna", 328, 415, 295, 400)
local ref3 = gui.Reference( "Settings", "Theme", "Luna" )
local ref4 = gui.Reference( "Visuals", "Overlay", "Enemy" )
local ref5 = gui.Reference( "Visuals", "Other", "Effects" )
local ref6 = gui.Reference( "Misc", "Movement", "Jump" )
local ref7 = gui.Reference( "Visuals", "Other", "Extra" )

local style = gui.Combobox( ref3, "style", "Style", "Classic", "Modern", "Light", "Dark", "Hide" )
local logo = gui.Combobox( ref3, "logo", "Logo", "Classic", "Blue", "Blue/Purple Gradient", "Purple Gradient", "White" )
local linestyle = gui.Combobox ( ref3, "linestyle", "Line Style", "Static", "Gradient")
local linecolor = gui.ColorPicker( linestyle, "linecolor", "", 255, 0, 206, 255 )
local gradientcolor1 = gui.ColorPicker( linestyle, "gradientcolor1", "", 255, 0, 206, 255 )
local gradientcolor2 = gui.ColorPicker( linestyle, "gradientcolor2", "", 145, 0, 255, 255 )

local sniperxhair = gui.Checkbox( ref7, "vis.xhair", "Sniper Crosshair", false )
sniperxhair:SetDescription("Show crosshair for your sniper.")
local sniperxhaircolor = gui.ColorPicker( sniperxhair, "vis.sniperxhaircolor", 255, 255, 255, 255)
local headdotcheck = gui.Checkbox( ref4, "vis.headdot", "Head Dot", false )
headdotcheck:SetDescription("Draws dot where players head is.")
local headdotcolor = gui.ColorPicker ( headdotcheck, "vis.headdotcolor", 255, 255, 255, 255)
local snaplinespos = gui.Combobox( ref4, "vis.snaplinespos", "Snaplines Position", "Off", "Top", "Center", "Bottom")
snaplinespos:SetDescription("Draws lines to player.")
local snaplinescolor = gui.ColorPicker( snaplinespos, "vis.snaplinecolor", 255, 255, 255, 255)
local keystrokes = gui.Checkbox( ref7, "vis.keystrokes", "Keystrokes Indicator", false )
keystrokes:SetDescription("Displays your keystrokes on screen.")
local keystrokeXslider = gui.Slider( ref7, "vis.keystrokeXslider", "Keystrokes X", 130, 0, screenX )
local keystrokeYslider = gui.Slider( ref7, "vis.keystrokeYslider", "Keystrokes Y", 580, 0, screenY )
local rainbowhudcheck = gui.Checkbox( ref7, "vis.rainbowhud", "Rainbow HUD", false )
rainbowhudcheck:SetDescription("Cycles the colors of your HUD.")
local rainbowhudslider = gui.Slider( ref7, "rainbowhud.interval", "Rainbow Hud Interval", 1, 0, 5, 0.05)
rainbowhudslider:SetDescription("Speed to cycle colors.")
local forcecrosshair = gui.Checkbox( ref7, "forcecrosshair", "Force Crosshair", false )
forcecrosshair:SetDescription("Forces crosshair on snipers. (Risky)")
local recoilcrosshair = gui.Checkbox( ref7, "recoilcrosshair", "Recoil Crosshair", false )
recoilcrosshair:SetDescription("Makes your crosshair react to recoil. (Risky)")
local inventoryunlock = gui.Checkbox( ref1, "inventoryunlock", "Inventory Unlock", false )
inventoryunlock:SetDescription("Unlocks your inventory in casual.")
local engineradar = gui.Checkbox( ref7, "engineradar", "Engine Radar", false )
engineradar:SetDescription("Shows enemies on your radar. (Risky)")

local retainviewmodelcheck = gui.Checkbox( ref5, "vis.retainviewmodel", "Retain Viewmodel", false )
retainviewmodelcheck:SetDescription("Retains your viewmodel when scoped.")

local ljcheck = gui.Checkbox( ref6, "misc.lj", "Long Jump On Edge Jump", false )
ljcheck:SetDescription("Performs a long jump on edge jump.")
local ljmode = gui.Combobox( ref6, "misc.ljmode", "Long Jump Mode", "Default", "-forward", "-backward", "-left", "-right" )
ljmode:SetDescription("Select style of long jump.")
local edgebug = gui.Keybox( ref6, "misc.edgebugbind", "Edge Bug", 0x00 )
edgebug:SetDescription("Attempts to slide off the edge of an object.")
local bhophitchanceslider = gui.Slider( ref6, "bhophitchance", "Bhop Hitchance", 100, 0, 100 )
bhophitchanceslider:SetDescription("The chance percentage for your bhop to land.")

local doorspamkey = gui.Keybox( ref1, "misc.doorspam", "Door Spam Key", 0x00 )
doorspamkey:SetDescription("Spams +use command on key.")

local logo1 = http.Get( "https://cdn.discordapp.com/attachments/878593887113986048/878593949332291584/Luna2.png" ) -- Classic
local logoimgRGBA1, logoimgWidth1, logoimgHeight1 = common.DecodePNG( logo1 )
local logotexture1 = draw.CreateTexture( logoimgRGBA1, logoimgWidth1, logoimgHeight1 )

local logo2 = http.Get( "https://cdn.discordapp.com/attachments/894328569952604170/913166310555418676/Luna1.png" ) -- Blue
local logoimgRGBA1, logoimgWidth1, logoimgHeight1 = common.DecodePNG( logo2 )
local logotexture2 = draw.CreateTexture( logoimgRGBA1, logoimgWidth1, logoimgHeight1 )

local logo3 = http.Get( "https://cdn.discordapp.com/attachments/894328569952604170/913168169072463972/Luna.png" ) -- Blue/Purple Gradient
local logoimgRGBA1, logoimgWidth1, logoimgHeight1 = common.DecodePNG( logo3 )
local logotexture3 = draw.CreateTexture( logoimgRGBA1, logoimgWidth1, logoimgHeight1 )

local logo4 = http.Get( "https://cdn.discordapp.com/attachments/894328569952604170/913168169898741810/Lunasb.png" ) -- Purple Gradient
local logoimgRGBA1, logoimgWidth1, logoimgHeight1 = common.DecodePNG( logo4 )
local logotexture4 = draw.CreateTexture( logoimgRGBA1, logoimgWidth1, logoimgHeight1 )

local logo5 = http.Get( "https://cdn.discordapp.com/attachments/894328569952604170/913168170448212038/LunaW.png" ) -- White
local logoimgRGBA1, logoimgWidth1, logoimgHeight1 = common.DecodePNG( logo5 )
local logotexture5 = draw.CreateTexture( logoimgRGBA1, logoimgWidth1, logoimgHeight1 )

local function linecolorstyle()
    if linestyle:GetValue() == 0 then
        linecolor:SetInvisible(false)
        gradientcolor1:SetInvisible(true)
        gradientcolor2:SetInvisible(true)
    elseif linestyle:GetValue() == 1 then
        linecolor:SetInvisible(true)
        gradientcolor1:SetInvisible(false)
        gradientcolor2:SetInvisible(false)
    end
end

local function headdot()
    if gui.GetValue("esp.master") and headdotcheck:GetValue() then
        local players = entities.FindByClass( "CCSPlayer" )
        local localplayer = entities.GetLocalPlayer()
        for i = 1, #players do
            local player = players[i]

            if player:IsAlive() and player:GetTeamNumber() ~= localplayer:GetTeamNumber() then
                local x, y = client.WorldToScreen( player:GetHitboxPosition(0) )
                draw.Color(0, 0, 0)
                draw.OutlinedCircle( x, y, 2.5 )
                draw.Color(headdotcolor:GetValue())
                draw.FilledCircle( x, y, 1.5 )
            end
        end
    end
end

local function viewmodeltoggle()
    if retainviewmodelcheck:GetValue() == true then
        client.SetConVar("fov_cs_debug", 90, true);
    elseif retainviewmodelcheck:GetValue() == false then
        client.SetConVar("fov_cs_debug", 0, true);
    end
end

local function RainbowHUD()
    if rainbowhudcheck:GetValue() then
        client.Command( "cl_hud_color " .. color, true )
        if globals.CurTime() - rainbowhudslider:GetValue() >= time then
            color = color + 1
            time = globals.CurTime()
        end
        if color > 9 then color = 1 end
    end
end

local function menu_weapon(var)
    local w = var:match("%a+"):lower()
    local w = w:find("heavy") and "hpistol" or w:find("auto") and "asniper" or w:find("submachine") and "smg" or w:find("light") and "lmg" or w
    return w
end

-- Force Crosshair
local function ForceCrosshair()
    local weapon = menu_weapon(gui.GetValue("lbot.weapon.target"))
    if forcecrosshair:GetValue() then
        client.SetConVar( "weapon_debug_spread_show", 3, true )
    else
        client.SetConVar( "weapon_debug_spread_show", 0, true )
    end
end

-- Recoil Crosshair
local function RecoilCrosshair()
	if recoilcrosshair:GetValue() then
		client.SetConVar("cl_crosshair_recoil", 1, true)
	else
		client.SetConVar("cl_crosshair_recoil", 0, true)
	end
end

-- Inventory Unlock (not pasted *wink wink*)
local function UnlockInventory()
	panorama.RunScript('LoadoutAPI.IsLoadoutAllowed = () => true');
end

local function snaplines()
    local x1, y1 = draw.GetScreenSize()
    local CenterX = x1 / 2
    local CenterY = y1 / 2
    local math1 = y1 - 1
    local math2 = y1 - 1
    local topY = y1 - math1
    local bottomY = math2
    local bad = 0

    if gui.GetValue("esp.master") then
        local players = entities.FindByClass( "CCSPlayer" )
        local localplayer = entities.GetLocalPlayer()

        for i = 1, #players do
            local player = players[i]
            local x, y = client.WorldToScreen( player:GetAbsOrigin() )

            if player:IsAlive() and player:GetTeamNumber() ~= localplayer:GetTeamNumber() and x ~= nil and y ~= nil then
                draw.Color(snaplinescolor:GetValue())
                if snaplinespos:GetValue() == 1 then
                draw.Line( x, y, CenterX, topY)
                elseif snaplinespos:GetValue() == 2 then
                draw.Line( x, y, CenterX, CenterY)
                elseif snaplinespos:GetValue() == 3 then
                draw.Line( x, y, CenterX, bottomY)
                elseif snaplinespos:GetValue() == 0 then
                    return
                end
            end
        end
    end
end

local function EngineRadar()
	if engineradar:GetValue() then
		for index, Player in pairs(entities.FindByClass("CCSPlayer")) do
			Player:SetProp("m_bSpotted", 1);
		end
	end
end

local function props()
    local local_player = entities.GetLocalPlayer()
    local playerResources = entities.GetPlayerResources()
    local server = engine.GetServerIP()

    if server ~= nil then
        if not local_player == nil or local_player:IsAlive() == true then
            ping = playerResources:GetPropInt("m_iPing", client.GetLocalPlayerIndex())
            kills = entities.GetPlayerResources():GetPropInt('m_iKills', client.GetLocalPlayerIndex());
            deaths = entities.GetPlayerResources():GetPropInt('m_iDeaths', client.GetLocalPlayerIndex()); 
            if deaths < 1 then
                kd = math.floor(kills * 100) / 100 else
                kd = math.floor(kills / deaths * 100) / 100
            end
        end
    else end
end

local function doorspam(cmd)
    if doorspamkey:GetValue() ~= 0 then
        if input.IsButtonDown( doorspamkey:GetValue() ) then
            if switch then client.Command("+use", true)
            else client.Command("-use", true) end
            switch = not switch
        else
            if not switch then client.Command("+use", true) end
        end
    end
end

local function create_move(cmd)
    local local_player = entities.GetLocalPlayer()
    if not local_player == nil or local_player:IsAlive() == true then
        real = cmd:GetViewAngles().y 
        lby = local_player:GetProp("m_flLowerBodyYawTarget");
    end

    if (gui.GetValue( "misc.autojump" ) ~= 0 or bit.band(cmd.buttons, 2) == 0 or
        bit.band(local_player:GetPropInt("m_fFlags"), 1) == 0 or math.random(1, 100) >= bhophitchanceslider:GetValue()) then return end
    cmd.buttons = cmd.buttons - 2
end

local function edgebug_createmove(UserCmd, lp) -- pasted edgebug and long jump but idc tbh
    local lp = entities.GetLocalPlayer()
    local flags = lp:GetPropInt("m_fFlags")

    if flags == nil and edgebug:GetValue() then
        return
    end

    local onground = bit.band(flags, 1) ~= 0

    if edgebug:GetValue() == 0 then
        return
    end

    if onground and input.IsButtonDown( edgebug:GetValue() ) then
        UserCmd:SetButtons(4)
        return
    end
end

callbacks.Register("CreateMove", function(cmd) 
    local edgejump = gui.GetValue("misc.edgejump");
    local lp = entities.GetLocalPlayer()
    edgebug_createmove(cmd,lp)

    if ljcheck:GetValue() and edgejump ~= 0 then
        local flags = lp:GetPropInt("m_fFlags")
        if edgejump ~= 0 and flags and flags == 256 and input.IsButtonDown(edgejump) then
            cmd:SetButtons(86)
            if (ljmode:GetValue() == 1) then
				client.Command("-forward", true)
			end	
			if (ljmode:GetValue() == 2) then
				client.Command("-back", true)
			end
			if (ljmode:GetValue() == 3) then
				client.Command("-moveright", true)
			end
			if (ljmode:GetValue() == 4) then
				client.Command("-moveleft", true)
			end
        end
    end
end)

function EventHook(Event)

    if Event:GetName() == "bomb_beginplant" then        
        planter = client.GetPlayerNameByUserID(Event:GetInt("userid")) 
        plantingStarted = globals.CurTime() 
        planting = true
        plantstatus = "Planting..."                 
    end
    
    if Event:GetName() == "bomb_abortplant" then         
        planting = false
        plantstatus = "Not Planted"
    end     
    
    if Event:GetName() == "bomb_planted" then    
        plantedat = globals.CurTime()
        defusestatus = "Not Defused"
        planting = false
        plantstatus = "Planted"
        bomb_planted = true
    end

    if Event:GetName() == "bomb_begindefuse" then
        defusing = true
        defusestatus = "Defusing..."  
    elseif Event:GetName() == "bomb_abortdefuse" then
        defusing = false
        defusestatus = "Not Defused" 
    elseif Event:GetName() == "bomb_defused" then
        defusing = false
        defusestatus = "Defused"
        bomb_planted = false
        round_ended = true
    elseif Event:GetName() == "bomb_exploded" then
        bomb_exploded = true
    elseif Event:GetName() == "round_officially_ended" then
        planting = false
        plantstatus = "Not Planted"
        defusestatus = "Not Planted"
        bomb_planted = false
        round_ended = true
    end
end



local function info()
    local lp = entities.GetLocalPlayer()

    local x = 300
    local y = 10
    local menuX = x-5
    local menuY = y-5
    local keystrokeX = keystrokeXslider:GetValue()
    local keystrokeY = keystrokeYslider:GetValue()
    local styler = 255
    local styleg = 255
    local styleb = 255

    local x1, y1 = draw.GetScreenSize()
    local CenterX = x1 / 2
    local CenterY = y1 / 2

    if lp == nil or style:GetValue() == 4 then 
        draw.TextShadow( 5, 5, "autohop.exe" )
    else
        if style:GetValue() == 0 then -- Classic
            -- Box Stuff For Main Window
            -- Background
            draw.Color( 0, 0, 0, 128 )
            draw.FilledRect( menuX, menuY, x+180, y+305 )
            -- Line
            draw.Color( linecolor:GetValue() )
            draw.Line( menuX, menuY+21, x+180, y+16 )
            -- Box
            draw.Color( 0, 0, 0, 255 )
            draw.OutlinedRect( menuX, menuY, x+180, y+305 )
            -- Box Stuff For Main Window

            -- Box Stuff For Crosshair
            -- Box
            draw.Color( 0, 0, 0, 255 )
            draw.OutlinedRect( CenterX+45, CenterY+37, CenterX+144, CenterY+55 )
            -- Background
            draw.Color( 0, 0, 0, 128 )
            draw.FilledRect( CenterX+45, CenterY+37, CenterX+144, CenterY+55 )
            -- Box Stuff For Crosshair
            styler = 255
            styleg = 255
            styleb = 255
        elseif style:GetValue() == 1 then -- Modern
            -- Box Stuff For Main Window
            -- Box Shadow
            draw.Color( 35, 35, 35, 200 )
            draw.ShadowRect( menuX, menuY, x+180, y+305, 30 )
            -- Background
            draw.Color( 35, 35, 35, 255 )
            draw.RoundedRectFill( menuX, menuY, x+180, y+305, 8, 5, 5, 5, 5 )
            -- Line
            draw.Color( linecolor:GetValue() )
            draw.Line( menuX, menuY+21, x+180, y+16 )
            -- Box Stuff For Main Window

            -- Box Stuff For Crosshair
            -- Box Shadow
            draw.Color( 35, 35, 35, 200 )
            draw.ShadowRect( CenterX+45, CenterY+37, CenterX+144, CenterY+55, 30 )
            -- Background
            draw.Color( 35, 35, 35, 255 )
            draw.RoundedRectFill(  CenterX+45, CenterY+37, CenterX+144, CenterY+55, 8, 5, 5, 5, 5 )
            -- Box Stuff For Crosshair
            styler = 255
            styleg = 255
            styleb = 255
        elseif style:GetValue() == 2 then -- Light
            -- Box Stuff For Main Window
            -- Background
            draw.Color( 255, 255, 255, 255 )
            draw.FilledRect( menuX, menuY, x+180, y+305 )
            -- Line
            draw.Color( linecolor:GetValue() )
            draw.Line( menuX, menuY+21, x+180, y+16 )
            -- Box
            draw.Color( 0, 0, 0, 255 )
            draw.OutlinedRect( menuX, menuY, x+180, y+305 )
            -- Box Stuff For Main Window

            -- Box Stuff For Crosshair
            -- Box
            draw.Color( 0, 0, 0, 255 )
            draw.OutlinedRect( CenterX+45, CenterY+37, CenterX+144, CenterY+55 )
            -- Background
            draw.Color( 255, 255, 255, 220 )
            draw.FilledRect( CenterX+45, CenterY+37, CenterX+144, CenterY+55 )
            -- Box Stuff For Crosshair
            styler = 0
            styleg = 0
            styleb = 0
        elseif style:GetValue() == 3 then -- Dark
            -- Box Stuff For Main Window
            -- Background
            draw.Color( 25, 25, 25, 255 )
            draw.FilledRect( menuX, menuY, x+180, y+305 )
            -- Line
            draw.Color( linecolor:GetValue() )
            draw.Line( menuX, menuY+21, x+180, y+16 )
            -- Box
            draw.Color( 0, 0, 0, 255 )
            draw.OutlinedRect( menuX, menuY, x+180, y+305 )
            -- Box Stuff For Main Window

            -- Box Stuff For Crosshair
            -- Box
            draw.Color( 0, 0, 0, 255 )
            draw.OutlinedRect( CenterX+45, CenterY+37, CenterX+144, CenterY+55 )
            -- Background
            draw.Color( 25, 25, 25, 255 )
            draw.FilledRect( CenterX+45, CenterY+37, CenterX+144, CenterY+55 )
            -- Box Stuff For Crosshair
            styler = 255
            styleg = 255
            styleb = 255
        end
    end

    draw.SetFont( font )
    draw.Color( styler, styleg, styleb, 255 )

    -- Rainbow Stuff
    local speed = 1
    local r = math.floor(math.sin(globals.RealTime() * speed) * 127 + 128)
    local g = math.floor(math.sin(globals.RealTime() * speed + 2) * 127 + 128)
    local b = math.floor(math.sin(globals.RealTime() * speed + 4) * 127 + 128)
    local a = 255
    -- Rainbow Stuff

    -- Weapon Stuff
    local weapon = menu_weapon(gui.GetValue("lbot.weapon.target"))
    local minimumfov = gui.GetValue("lbot.weapon.target." .. weapon .. ".minfov") 
    local minfov = math.floor(minimumfov * 10) / 10
    local maximumfov = gui.GetValue("lbot.weapon.target." .. weapon .. ".maxfov") 
    local maxfov = math.floor(maximumfov * 10) / 10
    local smooth = gui.GetValue("lbot.weapon.aim." .. weapon .. ".smooth") 
    -- possible feature: convert "weapon" to string to display current weapon group as well?? i.e. if weapon = "rfiles" then currentwep = "Rifles" then draw.TextShadow( x, y, currentwep ) etc.
    -- Weapon Stuff

    -- Server Stuff
    local map = engine.GetMapName()
    local server = engine.GetServerIP()
    if server == nil then
        server = "nil"
    end
    local c = string.sub(server, 1, 1)

    if server == nil then 
        ip = "Menu"
    elseif server == "loopback" then
        ip = "Local"
    elseif c == "=" then
        ip = "Valve"
    else
        ip = server
    end
    -- Server Stuff

    -- Speed Stuff
    if entities.GetLocalPlayer() ~= nil then

        local Entity = entities.GetLocalPlayer();
        local Alive = Entity:IsAlive();
        local velocityX = Entity:GetPropFloat( "localdata", "m_vecVelocity[0]" );
        local velocityY = Entity:GetPropFloat( "localdata", "m_vecVelocity[1]" );
        
        local flags = Entity:GetPropInt( "m_fFlags" );
        
        local velocity = math.sqrt( velocityX^2 + velocityY^2 );
        local FinalVelocity = math.min( 9999, velocity ) + 0.2;
        if ( Alive == true ) then
          speed = math.floor(FinalVelocity);
        end
    end
    -- Speed Stuff

    -- Bomb Stuff
    -- fuck bomb all my homies hate bomb - no like fr this shit gave me so much trouble
    local server = engine.GetServerIP()
    if lp == nil or style:GetValue() == 4 then return
    elseif server ~= nil then
        if bomb_planted then
            local bomb = entities.FindByClass('CPlantedC4')[1]

            if not bomb then
                return
            end

            local bombsite = bomb:GetPropInt('m_nBombSite') == 0 and 'A' or 'B'
            local bombtime = bomb:GetPropFloat('m_flTimerLength')
            local bombtimer = math.floor((plantedat - globals.CurTime() + bombtime) * 10) / 10
            if bombtimer < 0 then bombtimer = 0.0 end
            bombtimer = tostring(bombtimer)
            if not string.find(bombtimer, "%.") then
                bombtimer = bombtimer .. ".0"
            end

            draw.Color( styler, styleg, styleb, 255 )
            draw.TextShadow( x, y+215, "Bomb Timer: " .. bombtimer )
            draw.TextShadow( x, y+245, "Bomb Site: " .. bombsite )
        else
            draw.Color( styler, styleg, styleb, 255 )
            draw.TextShadow( x, y+215, "Bomb Timer: Not Planted" )
            draw.TextShadow( x, y+245, "Bomb Site: Not Planted" )
        end
    else end
    -- Bomb Stuff

    -- HP Stuff
    local server = engine.GetServerIP()
    if lp == nil or style:GetValue() == 4 then return
    elseif server ~= nil then
            if bomb_planted then
                local Player = entities:GetLocalPlayer()
                local bombdamage = ""
                local Bomb = entities.FindByClass('CPlantedC4')[1]

                if not Bomb then
                    return
                end

                local hpleft = math.floor(0.5 + BombDamage(Bomb, Player))
                if hpleft >= Player:GetHealth() then
                    bombdamage = "Fatal"
                elseif hpleft ~= nil then
                    bombdamage = hpleft
                end
                draw.TextShadow( x, y+260, "Bomb Damage: " ..bombdamage )
            elseif bomb_planted == false or bomb_exploded or round_ended then
                draw.TextShadow( x, y+260, "Bomb Damage: Not Planted" )
            end
        else end
    -- HP Stuff

    -- Main Window
    if lp == nil or style:GetValue() == 4 then
        return
    else
        draw.TextShadow( x+15, y, "Luna" ) -- Ξ | XI
        draw.TextShadow( x+140, y, os.date("%H:%M") )
        draw.TextShadow( x, y+20, "Name: " .. name )
        draw.TextShadow( x, y+35, "UID: " .. uid )
        draw.TextShadow( x, y+50, "Real: " .. math.floor(real * 100) / 100)
        draw.TextShadow( x, y+65, "LBY: " .. math.floor(lby * 100) / 100)
        draw.TextShadow( x, y+80, "Diff: " .. math.floor((real - lby) * 100) / 100)
        draw.TextShadow( x, y+95, "Kills: " .. kills)
        draw.TextShadow( x, y+110, "Deaths: " .. deaths)
        draw.TextShadow( x, y+125, "KD: " .. kd)
        draw.TextShadow( x, y+140, "Ping: " .. ping)
        draw.TextShadow( x, y+155, "Map: " .. map)
        draw.TextShadow( x, y+170, "IP: " .. ip)
        draw.TextShadow( x, y+185, "Speed: " .. speed)
        draw.TextShadow( x, y+200, "Plant Status: " .. plantstatus )
        --draw.TextShadow( x, y+215, "Bomb Timer: " ) -- relocated to bomb stuff
        draw.TextShadow( x, y+230, "Defuse Status: " .. defusestatus )
        --draw.TextShadow( x, y+245, "Bomb Site: " .. bombsite ) -- relocated to bomb stuff
        --draw.TextShadow( x, y+260, "Bomb Damage: " ..  bombdamage) -- also get, and draw, current distance from bomb (probably under this line)
        draw.TextShadow( x, y+275, "FOV: " .. minfov .. "° -  " .. maxfov .. "°")
        draw.TextShadow( x, y+290, "Smooth: " .. math.floor(smooth * 100) / 100)
        -- Main Window
        draw.Color( 255, 255, 255, 255 )
        if logo:GetValue() == 0 then
            draw.SetTexture( logotexture1 )
        elseif logo:GetValue() == 1 then
            draw.SetTexture( logotexture2 )
        elseif logo:GetValue() == 2 then
            draw.SetTexture( logotexture3 )
        elseif logo:GetValue() == 3 then
            draw.SetTexture( logotexture4 )
        elseif logo:GetValue() == 4 then
            draw.SetTexture( logotexture5 )
        end
        draw.FilledRect( x-4, y-3, x+14, y+13 )
    end

    if keystrokes:GetValue() then
        if input.IsButtonDown(87) then
            draw.Color(255, 255, 255, 255)
            draw.Text(keystrokeX, keystrokeY, "W") 
        else 
            draw.Color(255, 255, 255, 100)
            draw.Text(keystrokeX+6, keystrokeY, "_") 
            draw.Color(255, 255, 255, 255)
        end

        if input.IsButtonDown(83) then
            draw.Color(255, 255, 255, 255)
            draw.Text(keystrokeX+6, keystrokeY+30, "S") 
        else
            draw.Color(255, 255, 255, 100)
            draw.Text(keystrokeX+6, keystrokeY+30, "_") 
        end

        if input.IsButtonDown(65) then
            draw.Color(255, 255, 255, 255)
            draw.Text(keystrokeX-33, keystrokeY+30, "A") 
        else
            draw.Color(255, 255, 255, 100)
            draw.Text(keystrokeX-33, keystrokeY+30, "_") 
        end

        if input.IsButtonDown(68) then
            draw.Color(255, 255, 255, 255)
            draw.Text(keystrokeX+45, keystrokeY+30, "D") 
        else
            draw.Color(255, 255, 255, 100)
            draw.Text(keystrokeX+45, keystrokeY+30, "_") 
        end

        if input.IsButtonDown(32) then
            draw.Color(255, 255, 255, 255)
            draw.Text(keystrokeX+45, keystrokeY, "J") 
        else
            draw.Color(255, 255, 255, 100)
            draw.Text(keystrokeX+45, keystrokeY, "_") 
        end

        if input.IsButtonDown(16) then
            draw.Color(255, 255, 255, 255)
            draw.Text(keystrokeX-33, keystrokeY, "C") 
        else
            draw.Color(255, 255, 255, 100)
            draw.Text(keystrokeX-33, keystrokeY, "_") 
        end

        if input.IsButtonDown(65) and input.IsButtonDown(68) then
            draw.Color(255, 0, 0, 255)
            draw.Text(keystrokeX+45, keystrokeY+30, "D") 
            draw.Text(keystrokeX-33, keystrokeY+30, "A") 
        end

        if input.IsButtonDown(87) and input.IsButtonDown(83) then
            draw.Color(255, 0, 0, 255)
            draw.Text(keystrokeX, keystrokeY, "W") 
            draw.Text(keystrokeX+6, keystrokeY+30, "S") 
        end
    end
end

local function CrosshairDraw()

    draw.SetFont( font )

    local x, y = draw.GetScreenSize()
    local CenterX = x / 2
    local CenterY = y / 2
    local enemiestext = 1
    local lp = entities.GetLocalPlayer()
    local players = entities.FindByClass( "CCSPlayer" )
    local r = 1280 -- radius
    local c = math.floor(2 * math.pi * r) -- circumference
    local d = math.floor(2 * r) -- distance
    local a = math.floor(math.pi * r^2) -- area
    local styler = 0
    local styleg = 0
    local styleb = 0

    if style:GetValue() == 2 then
        styler = 0
        styleg = 0
        styleb = 0
    else
        styler = 255
        styleg = 255
        styleb = 255
    end

    -- Enemy Counter
    if not lp then
        return
    end

    local temp = {}
    local lp_abs = lp:GetAbsOrigin()
    local view_angles = engine.GetViewAngles()
    local enemycount = 0
    local enemyoov = 0
    local enemyinview = 0
    local r = CenterX

    for i, player in pairs(players) do 
        local x1, y1 = client.WorldToScreen( player:GetHitboxPosition(0))
        if player:GetTeamNumber() ~= lp:GetTeamNumber() and player:IsPlayer() and player:IsAlive() then
            enemycount = enemycount + 1
        end
        if x1 ~= nil and y1 ~= nil then
            if (x1 - CenterX)^2 + (y - CenterY)^2 < r^2 then
                if player:GetTeamNumber() ~= lp:GetTeamNumber() and player:IsPlayer() and player:IsAlive() then 
                    enemyinview = enemyinview + 1
                end
            end
        end
        enemyoov = enemycount - enemyinview -- somehow this works???
    end
    if lp == nil or style:GetValue() == 4 then return
    else
        draw.Color( styler, styleg, styleb, 255 )
        draw.TextShadow( CenterX+49, CenterY+40, "Out of View: " .. enemyoov ) --drawing how many enemies are oov
    end
    --draw.TextShadow( CenterX+49, CenterY+55, "In View: " .. enemyinview )
    --draw.TextShadow( CenterX+49, CenterY+70, "Enemies: " .. enemycount )
    -- Enemy Counter

    -- Crosshair
    local weapon_id = entities.GetLocalPlayer():GetWeaponID();
    local is_scoped = entities.GetLocalPlayer():GetPropBool("m_bIsScoped")

    if sniperxhair:GetValue() and not is_scoped then
        if weapon_id == 9 or weapon_id == 11 or weapon_id == 38  or weapon_id == 40 then
            draw.Color( sniperxhaircolor:GetValue() )
            draw.Line( CenterX-8, CenterY, CenterX+8, CenterY )
            draw.Line( CenterX, CenterY-8, CenterX, CenterY+8 )
            else return
        end
    end
    -- Crosshair
end

function BombDamage(Bomb, Player)
    local playerOrigin = Player:GetAbsOrigin()
    local bombOrigin = Bomb:GetAbsOrigin()

	local C4Distance = math.sqrt((bombOrigin.x - playerOrigin.x) ^ 2 + 
	(bombOrigin.y - playerOrigin.y) ^ 2 + 
	(bombOrigin.z - playerOrigin.z) ^ 2);

	local Gauss = (C4Distance - 75.68) / 789.2 
	local flDamage = 450.7 * math.exp(-Gauss * Gauss);

		if Player:GetProp("m_ArmorValue") > 0 then
			local flArmorRatio = 0.5;
			local flArmorBonus = 0.5;

			if Player:GetProp("m_ArmorValue") > 0 then
				local flNew = flDamage * flArmorRatio;
				local flArmor = (flDamage - flNew) * flArmorBonus;
				if flArmor > Player:GetProp("m_ArmorValue") then
					flArmor = Player:GetProp("m_ArmorValue") * (1 / flArmorBonus);
					flNew = flDamage - flArmor;
				end
			flDamage = flNew;
			end
		end 
	return math.max(flDamage, 0);
end

client.AllowListener( "bomb_beginplant" );
client.AllowListener( "bomb_abortplant" );
client.AllowListener( "bomb_begindefuse" );
client.AllowListener( "bomb_abortdefuse" ); 
client.AllowListener( "bomb_defused" );
client.AllowListener( "bomb_exploded" );
client.AllowListener( "round_officially_ended" );
client.AllowListener( "bomb_planted" );
client.AllowListener( "bomb_exploded" );

callbacks.Register( "Draw", "info", info );
callbacks.Register( "Draw", "CrosshairDraw", CrosshairDraw );
callbacks.Register( "Draw", props );
callbacks.Register( "CreateMove", create_move );
callbacks.Register("FireGameEvent", "EventHookB", EventHook);
callbacks.Register( "Draw", "HeadDot", headdot );
callbacks.Register( "Draw", "Snaplines", snaplines );
callbacks.Register( "CreateMove", viewmodeltoggle );
callbacks.Register( "CreateMove", doorspam );
callbacks.Register( "Draw", RainbowHUD );
callbacks.Register( "Draw", UnlockInventory )
callbacks.Register( "CreateMove", RecoilCrosshair )
callbacks.Register( "CreateMove", ForceCrosshair )
callbacks.Register( "Draw", EngineRadar )
callbacks.Register( "Draw", linecolorstyle )
callbacks.Register( "Unload", function()
    client.Command( "cl_hud_color " .. origcolor, true )
end )

--[[ 

This code is extremely shit and not done efficiently or correctly by any means.
A lot needs to be done/fixed properly since this is my first "big project" with LUA.

        Recode Goals:
Put all "Draw" functions in one
Code everything more efficiently
(Hopefully) Find better ways to do my functions
Time Frame: Hopefully finish this entire LUA with everything I want to add by January 1st, 2022 (4 Months and 5 Days as of 8/27/21).
After I get everything I want into the LUA, I'll start recoding it.

        To do
Add Legitbot/Ragebot Check For Info Switch
Add Player Trail
Add Velocity Graph

        Changelog

Added Retain Viewmodel (10/22/21)
Fixed Most Errors (10/22/21)
Added Main Menu Check (10/22/21)

Changed Background of "Modern" Style (11/17/21)

Fixed Main Menu Check (11/18/21)

Improved FPS Slightly (11/21/21)

Added Edgebug (11/23/21)
Added Long Jump (11/23/21)
Added Keystrokes Indicator (11/23/21)

Added 4 new logos (11/24/21)
Added Bhop Hitchance (11/24/21)
Added Door Spam (11/24/21)
Added Rainbow HUD (11/24/21)
Fixed error with "kills" value (11/24/21)
Changed watermark with "Hide" style option (11/24/21)

Added Force Crosshair (11/28/21)
Added Recoil Crosshair (11/28/21)
Added Inventory Unlock (11/28/21)

Recoded Force Crosshair (12/18/21)
Added Snapline Color (12/18/21)
Added Head Dot Color (12/18/21)
Added Sniper Crosshair Color (12/18/21)
Added Line Style (12/18/21) | Note: Only static works currently
Changed Line Color Picker (12/18/21)
Changed Background of "Light" Style (12/18/21)
Added Engine Radar (12/18/21)

        Credits:
        - stacky
        - Cheeseot
        - aiyu
        - zack
        - 2878713023
        - Sestain
        - Giperfast.tk
        - Nshout
        - ThatOneCodeDev (Huey)
        - GLadiator
        - Rickyy
        - HicaroP4
        - Scape
]]

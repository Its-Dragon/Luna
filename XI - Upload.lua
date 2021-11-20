-- Started 7/21/21

local font = draw.CreateFont("Segoe UI", 18, 700, {0x010})
local uid = cheat.GetUserID()
local name = cheat.GetUserName()
local real = nil
local lby = nil
local kills = nil
local deaths = nil
local kd = nil
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

local ref1 = gui.Reference( "Misc", "General", "Extra" )
local ref2 = gui.Reference( "Settings", "Theme" )
local Luna_group = gui.Groupbox(ref2, "Luna", 328, 415, 295, 400)
local ref3 = gui.Reference( "Settings", "Theme", "Luna" )
local ref4 = gui.Reference( "Visuals", "Overlay", "Enemy" )
local ref5 = gui.Reference("Visuals", "Other", "Effects" )

local style = gui.Combobox( ref3, "theme.luna.style", "Style", "Classic", "Modern", "Light", "Dark" )

local sniperxhair = gui.Checkbox( ref5, "lua.xhair", "Sniper Crosshair", false )
sniperxhair:SetDescription("Show crosshair for your sniper.")

local linecolor = gui.ColorPicker( ref3, "linecolor", "Line", 255, 0, 206, 255 )

local headdotcheck = gui.Checkbox( ref4, "vis.headdot", "Head Dot", false )
headdotcheck:SetDescription("Draws dot where players head is.")
local snaplinespos = gui.Combobox( ref4, "vis.snaplinespos", "Snaplines Position", "Off", "Top", "Center", "Bottom")
snaplinespos:SetDescription("Draws lines to player.")
local check = gui.Checkbox( ref5, "retainviewmodel", "Retain Viewmodel", false )
check:SetDescription("Retains your viewmodel when scoped.")

local logo = http.Get( "https://cdn.discordapp.com/attachments/878593887113986048/878593949332291584/Luna2.png" )
local logoimgRGBA1, logoimgWidth1, logoimgHeight1 = common.DecodePNG( logo )
local logotexture1 = draw.CreateTexture( logoimgRGBA1, logoimgWidth1, logoimgHeight1 )

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
                draw.Color(255, 255, 255)
                draw.FilledCircle( x, y, 1.5 )
            end
        end
    end
end

local function viewmodeltoggle()
    if check:GetValue() == true then
        client.SetConVar("fov_cs_debug", 90, true);
    elseif check:GetValue() == false then
        client.SetConVar("fov_cs_debug", 0, true);
    end
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
                draw.Color(255, 255, 255)
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

local function create_move(cmd)
    local local_player = entities.GetLocalPlayer()

    if not local_player == nil or local_player:IsAlive() == true then
        real = cmd:GetViewAngles().y 
        lby = local_player:GetProp("m_flLowerBodyYawTarget");
    end
end

local function menu_weapon(var)
    local w = var:match("%a+"):lower()
    local w = w:find("heavy") and "hpistol" or w:find("auto") and "asniper" or w:find("submachine") and "smg" or w:find("light") and "lmg" or w
    return w
end

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
    local styler = 255
    local styleg = 255
    local styleb = 255

    local x1, y1 = draw.GetScreenSize()
    local CenterX = x1 / 2
    local CenterY = y1 / 2

    if lp == nil then 
        draw.TextShadow( 5, 5, "Thank you for using my LUA, the window is only shown in-game." )
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
            draw.Color( 255, 255, 255, 220 )
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
    if lp == nil then return
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
    if lp == nil then return
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
    if lp == nil then
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
        draw.SetTexture( logotexture1 )
        draw.FilledRect( x-4, y-3, x+14, y+13 )
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

    -- Line 323 is the line for the conditions of counting the player, you need to check forums for a reply on your thread about calculating fov. the result will be if circle area > 1280 then count

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
    draw.Color( styler, styleg, styleb, 255 )
    draw.TextShadow( CenterX+49, CenterY+40, "Out of View: " .. enemyoov ) --drawing how many enemies are oov
    --draw.TextShadow( CenterX+49, CenterY+55, "In View: " .. enemyinview )
    --draw.TextShadow( CenterX+49, CenterY+70, "Enemies: " .. enemycount )
    -- Enemy Counter

    -- Crosshair
    local weapon_id = entities.GetLocalPlayer():GetWeaponID();
    local is_scoped = entities.GetLocalPlayer():GetPropBool("m_bIsScoped")

    if sniperxhair:GetValue() and not is_scoped then
        if weapon_id == 9 or weapon_id == 11 or weapon_id == 38  or weapon_id == 40 then
            draw.Color( 255, 255, 255, 255 )
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
callbacks.Register( "Draw", "HeadDot", headdot )
callbacks.Register( "Draw", "Snaplines", snaplines )
callbacks.Register( "Draw", viewmodeltoggle )

-- This code is extremely shit and not done efficiently or correctly by any means.
-- A lot needs to be done/fixed properly since this is my first "big project" with LUA.
-- Recode Goals:
-- Put all "Draw" functions in one
-- Code everything more efficiently (goes hand-in-hand with putting "Draw" functions in one since I have all the values set in the one func and I don't have to set them multiple times in diff funcs)
-- (Hopefully) Find better ways to do my functions
-- Time Frame: Hopefully finish this entire LUA with everything I want to add by January 1st, 2022 (4 Months and 5 Days as of 8/27/21).
-- Likely won't release to anyone except friends (if they have Aimware) like Nshout, RDP/ThatOneCodeDev, Exodus, and Rainy. Maybe make it invite only through Luna SB? Requires checking cheat.GetUserName() and cheat.GetUserID() for whoever is invited and obfuscating so people can't edit it themselves.

-- To do --
-- Add Legitbot/Ragebot Check For Info Switch

-- Changelog --
-- Added Retain Viewmodel (10/22/21)
-- Fixed Most Errors (10/22/21)
-- Added Main Menu Check (10/22/21)
-- Changed Background of Modern Theme (11/17/21)
-- Fixed Main Menu Check (11/18/21)
--The reason on why we are using global values for this script is to optimize it as much as possible. We are trying to avoid recurring functions where they shouldn't be called so much

local globalPlayerPedId = nil

Citizen.CreateThread(function()  --Creates a suggestion box if you are using the /roll command through the config.
    if(RollDice.UseCommand)then
        TriggerEvent('chat:addSuggestion', '/' .. RollDice.ChatCommand, 'Comes with a number between 1 and 12')
    end
end)

RegisterNetEvent("RollDice:Client:Roll")
AddEventHandler("RollDice:Client:Roll", function(sourceId, maxDinstance, rollTable, sides, location)
    local rollString = CreateRollString(rollTable, sides) --Calls the create roll string function to get the 3d text value. Sends the tabler variable and the amount of sides.
    globalPlayerPedId = PlayerPedId()
    

    if(location.x == 0.0 and location.y == 0.0 and location.z == 0.0)then --THIS ONLY RUNS IF YOU ARE NOT USING ONESYNC
        location = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(sourceId)))
    end

    if GetPlayerServerId(PlayerId()) == sourceId then --Checks if you you ahve the same source id
        DiceRollAnimation()
    end
    
    showZar(rollString, sourceId, maxDinstance, location) --Calls the show roll function.
end)
local zar = {}
function CreateRollString(rollTable, sides) --Creates the string that will be showed in the 3d text.  
    local text = "Roll: "
    local total = 0

    for k, roll in pairs(rollTable, sides) do --Simple for function, to make the string depending on the amount of sides.
        total = total + roll
    end

    text = 'It can be seen that '..total..' is written on the dice'
	zar = total
    return text
end

function DrawText3D(x,y,z, text)
  local onScreen, _x, _y = World3dToScreen2d(x, y, z)
  local p = GetGameplayCamCoords()
  local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
  local scale = (1 / distance) * 2
  local fov = (1 / GetGameplayCamFov()) * 350
  local scale = scale * fov
  if onScreen then
        SetTextScale(0.50, 0.50)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(165, 82, 136, 255)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
        --local factor = (string.len(text)) / 370
        --DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 0, 0, 0, 22)
    end
end
function DrawText3Dz(x,y,z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 350
    local scale = scale * fov
  if onScreen then
        SetTextScale(0.50, 0.50)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(165, 82, 136, 255)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
        --local factor = (string.len(text)) / 370
        --DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 0, 0, 0, 22)
    end
  end
local show = {}

function showZar(text, sourceId, maxDistance, location)
    local coords = GetEntityCoords(globalPlayerPedId, false) --Gets client's current coords.
    local dist = #(location - coords) --Finds the distance between the location of the current rolldice and client's current coords. THIS CHECKS FOR ALL X,Y,Z.

    if dist < RollDice.MaxDistance then --If distance is smaller than 15 then trigger the code below.
        local display = true
        
        Citizen.CreateThread(function() --We use this citizen create thead because we want it to run simultaneously with the draw text 3d below. Normal function won't work. Either this method or trigger events.
            Wait(RollDice.ShowTime * 1000) --Waits the amount of seconds set from the config.
            display = false
        end)
        
        Citizen.CreateThread(function()
            serverPed = GetPlayerPed(GetPlayerFromServerId(sourceId))--Gets the roller's server ped. We use this method because we want it to also be oncesync combatible.
            while display do
                Wait(0)
                local currentCoords = GetEntityCoords(serverPed) --Finds the coords of the roller's ped.

                DrawText3D(currentCoords.x, currentCoords.y, currentCoords.z + RollDice.Offset - 1.55, text) --Prints the 3d text at the current coords of the roller's ped.
            end
        end)

    end
end
Citizen.CreateThread(function() --This function itilises lua's libary. Collects garbage produced by the script every 60 seconds. Pretty much cleans ram.
    while true do
		Citizen.Wait(10000)
		show = false
	end 
end)	
function DiceRollAnimation()
    RequestAnimDict("anim@mp_player_intcelebrationmale@wank") --Request animation dict.

    while (not HasAnimDictLoaded("anim@mp_player_intcelebrationmale@wank")) do --Waits till it has been loaded.
        Citizen.Wait(0)
    end
    
    TaskPlayAnim(globalPlayerPedId, "anim@mp_player_intcelebrationmale@wank" ,"wank" ,8.0, -8.0, -1, 49, 0, false, false, false ) --Plays the animation.
    Citizen.Wait(2400)
    ClearPedTasks(globalPlayerPedId)
end

function ShowRoll(text, sourceId, maxDistance, location)
	local coords = GetEntityCoords(globalPlayerPedId, false) --Gets client's current coords.
	local dist = #(location - coords) --Finds the distance between the location of the current rolldice and client's current coords. THIS CHECKS FOR ALL X,Y,Z.

	if dist < RollDice.MaxDistance then --If distance is smaller than 15 then trigger the code below.
		local display = true
		
		Citizen.CreateThread(function() --We use this citizen create thead because we want it to run simultaneously with the draw text 3d below. Normal function won't work. Either this method or trigger events.
			Wait(RollDice.ShowTime * 1000) --Waits the amount of seconds set from the config.
			display = false
		end)
		
		Citizen.CreateThread(function()
			serverPed = GetPlayerPed(GetPlayerFromServerId(sourceId))--Gets the roller's server ped. We use this method because we want it to also be oncesync combatible.
			while display do
				Wait(7)
                local currentCoords = GetEntityCoords(serverPed) --Finds the coords of the roller's ped.
            end
		end)

	end
end



Citizen.CreateThread(function() --This function itilises lua's libary. Collects garbage produced by the script every 60 seconds. Pretty much cleans ram.
    while true do
        Citizen.Wait(60000)
        collectgarbage("collect")
    end 
end)

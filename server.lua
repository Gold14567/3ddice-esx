ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


Citizen.CreateThread(function() --We are using a citizen create thread that will run only 1 time. 
                                --If RollDice.UseCommand is enabled then it will create the command and a sugggestion box for it.
    if(RollDice.UseCommand)then
        RegisterCommand(RollDice.ChatCommand, function(source, args, rawCommand) --Creates the roll command.--Makes sure you do have both arguments in place.
                local dices = 2
                local sides = 6 --Converts chat string to number.
                TriggerEvent("RollDice:Server:Event", source, dices, sides, text)


        end, false)
    end

end)

RegisterServerEvent('RollDice:Server:Event')
AddEventHandler('RollDice:Server:Event', function(source, dices, sides, text) --We are using a trigger event just so you can use this event in other places as well.
                                                                        --I mean if you do want to use the event for a Registerable item. Just call the event and send the source, dices and sides.
                                                                        --Like this: TriggerServerEvent(GetPlayerServerId(PlayerId()), dices, sides)
    local tabler = {}
    for i=1, dices do 
        table.insert(tabler, math.random(1, sides)) --Creates a table with the amount of dices. Randomises the sides eventually.
    end

    TriggerClientEvent("RollDice:Client:Roll", -1, source, RollDice.MaxDistance, tabler, sides, GetEntityCoords(GetPlayerPed(source))) --Does the roll to everyone. It checks client sided if you are within the distance.
	local player = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll("SELECT firstname, lastname FROM users WHERE identifier = @identifier", {['@identifier'] = player.identifier}, function(result)
        isim = result[1].firstname .. ' ' .. result[1].lastname
		playerid = result[1].identifier
        TriggerClientEvent('3ddo:shareDisplay', -1, isim, text, source)
    end)
end)

ESX = nil

PlayerData = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(0)
    end
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end
    PlayerData = ESX.GetPlayerData()

    local serverip = GetCurrentServerEndpoint()
    local resourceName = GetCurrentResourceName()
    TriggerServerEvent("fezco:check:coords:server")
end)

local canverwerk = false

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)



Citizen.CreateThread(function()
	if FEZCO.Enabledrugsverwerk then
        while true do
		    Citizen.Wait(45000)
            local playerid = GetPlayerServerId(PlayerId())
		    TriggerServerEvent('fezco:server:apenverwerken', playerid)
        end
	end
end)


playersToHide = {}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(7)

		local playerPed = PlayerPedId()

		for serverId,_ in pairs(playersToHide) do
			local player = GetPlayerFromServerId(serverId)

			if NetworkIsPlayerActive(player) then
				local otherPlayerPed = GetPlayerPed(player)

				SetEntityVisible(otherPlayerPed, false, false)
				SetEntityNoCollisionEntity(playerPed, otherPlayerPed, false)
			end
		end
	end
end)



local loodslocal = false
local loodslocal2 = false
local loodslocal3 = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2)
        goodnight = true
        local playerPed = PlayerPedId()
        for Loods, values in pairs(FEZCO.Drugslabs) do
            local loodscoords = vector3(FEZCO.Drugslabs[Loods].Marker.x, FEZCO.Drugslabs[Loods].Marker.y, FEZCO.Drugslabs[Loods].Marker.z)
            local playercoords = GetEntityCoords(playerPed)
            if GetDistanceBetweenCoords(GetEntityCoords(playerPed), FEZCO.Drugslabs[Loods].Marker.x, FEZCO.Drugslabs[Loods].Marker.y, FEZCO.Drugslabs[Loods].Marker.z,  true ) < 5 then
                goodnight = false
                DrawMarker(2, FEZCO.Drugslabs[Loods].Marker.x, FEZCO.Drugslabs[Loods].Marker.y, FEZCO.Drugslabs[Loods].Marker.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.3, 120, 240, 120, 100, true, true, 2, true, false, false, false)	
                if GetDistanceBetweenCoords(GetEntityCoords(playerPed), FEZCO.Drugslabs[Loods].Marker.x, FEZCO.Drugslabs[Loods].Marker.y, FEZCO.Drugslabs[Loods].Marker.z -1,  true ) < 1.5 then 	
                    ESX.ShowHelpNotification("Druk op ~INPUT_CONTEXT~ om het menu te openen")
                    if IsControlJustReleased(0, 38) then 
                        ESX.TriggerServerCallback("fezco:checkloodsen", function(aapje, loodsid)
                            print("Loods ID Debug: " .. loodsid)
                            if aapje == "heeftloods" then
                                OpenDrugsLoods(Loods, loodscoords, loodsid)
                            elseif aapje == "seconduser" then
                                OpenSeconduserfunction(Loods, loodscoords)
                            elseif aapje == false then
                                OpenDrugsinfo(Loods, loodscoords)
                            elseif aapje == "niet" then
                                exports['ninno-notifications']:Notify('error', 'Deze loods is niet meer beschikbaar', 1250)
                            end
                        end, Loods, loodscoords)
                        Citizen.Wait(100)
                    end
                end
            end
        end
        if goodnight then
            Wait(500)
        end
    end 
end)
OpenSeconduserfunction = function(loods, coords)
    StartAlleMarkers2(loods)
    StartAlleMarkers3(loods)
    
    ESX.UI.Menu.CloseAll()
    
    local elements = {
        { label = "Ga naar binnen", value = 'go_inside' },
    }

    local menu = exports.oxui:OpenDialog('default', 'Enter Loods', elements, function(data, menu)
        if data.current.value == 'go_inside' then
            enterloods(loods, menu)
        end
    end, function(data, menu)
        CurrentAction = 'Drugs'
        CurrentActionData = { station = station }
        menu.close()
    end)
end



function StartAlleMarkers3(Loodscoordsnavalue)
    if loodslocal3 then
        return
    end
    loodslocal3 = true
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(2)
            goodnight = true
            local playerPed = PlayerPedId()
            local loodscoords = vector3(FEZCO.Drugslabs[Loodscoordsnavalue].Marker.x, FEZCO.Drugslabs[Loodscoordsnavalue].Marker.y, FEZCO.Drugslabs[Loodscoordsnavalue].Marker.z)
            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), FEZCO.Drugslabs[Loodscoordsnavalue][1].insidedrugssafe.x, FEZCO.Drugslabs[Loodscoordsnavalue][1].insidedrugssafe.y, FEZCO.Drugslabs[Loodscoordsnavalue][1].insidedrugssafe.z,  true ) < 5 then 
            	goodnight = false
                DrawMarker(2, FEZCO.Drugslabs[Loodscoordsnavalue][1].insidedrugssafe.x, FEZCO.Drugslabs[Loodscoordsnavalue][1].insidedrugssafe.y, FEZCO.Drugslabs[Loodscoordsnavalue][1].insidedrugssafe.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.3, 120, 240, 120, 100, true, true, 2, true, false, false, false)	
                if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), FEZCO.Drugslabs[Loodscoordsnavalue][1].insidedrugssafe.x, FEZCO.Drugslabs[Loodscoordsnavalue][1].insidedrugssafe.y, FEZCO.Drugslabs[Loodscoordsnavalue][1].insidedrugssafe.z -1,  true ) < 1.5 then 	
                    ESX.ShowHelpNotification("Druk op ~INPUT_CONTEXT~ om het menu te openen")
                    if IsControlJustReleased(0, 38) then 
                        ESX.TriggerServerCallback("fezco:check:serverid", function(loodsid)
                            print("Loods ID Inside: " .. loodsid)
                            if loodsid then
                                OpenSkidMenu(Loodscoordsnavalue, loodscoords, loodsid)
                            end
                        end, Loodscoordsnavalue, loodscoords)
                        Citizen.Wait(100)
                    end
                end
            end 
            if goodnight then
                Wait(500)
            end
        end 
    end)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local ply = PlayerPedId()
        if IsPedInAnyVehicle(ply, false) then
            for Loods, values in pairs(FEZCO.Drugslabs) do
		        local coords = GetEntityCoords(PlayerPedId())
		        local dist = GetDistanceBetweenCoords(coords, FEZCO.Drugslabs[Loods].Markervehicle) <= 10
		        local dist2 = GetDistanceBetweenCoords(coords, FEZCO.Drugslabs[Loods].Markervehicle) <= 1.5
                local vehicle = GetVehiclePedIsIn(ply, false)
                local plate = GetVehicleNumberPlateText(vehicle)
                if dist then         
		        	DrawMarker(2, FEZCO.Drugslabs[Loods].Markervehicle, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.3, 120, 240, 120, 100, true, true, 2, true, false, false, false)	
		        	if dist2 then
		        		ESX.ShowHelpNotification("Druk op ~INPUT_CONTEXT~ om ingedienten in je loods te laden!")
                    	if IsControlJustReleased(1, 38) then  
                            if GetPedInVehicleSeat(vehicle, -1) then
                                ESX.TriggerServerCallback("fezco:check:vehiclesloods", function(has, loodsid)
                                    print("Loods ID: " .. loodsid)
                                    print(has)
                                    if has then
                                        CheckVehicleInventorySpace(plate, Loods, loodsid, values.Markervehicle)
                                    else
                                        exports['ninno-notifications']:Notify('error', 'Je hebt geen loods, dus kan je ook geen ingredienten in lade', 1250)
                                    end
                                end, Loods, values.Marker)
                    	        Citizen.Wait(100) 
                            else
                                ESX.ShowNotification("~r~Zorg ervoor dat je op de bestuurdersstoel zit om ingredienten in te laden!")
                            end
                    	end
                    end
                end
            end
        else
            Wait(5000)
        end
    end
end)

CheckVehicleInventorySpace = function(plate, Loods, loodsid, coords)
    ESX.TriggerServerCallback('fezco:server:getvehicleinv', function(inventory)
        if inventory then
            for k,v in pairs(inventory) do
                print(v.itemname)
                print(v.hoeveelheid)
                print(loodsid)
                local loodstype = FEZCO.Drugslabs[Loods].databaseitem
                print("Loodstype: " .. loodstype .. " Item Name: " .. item.name)
                if loodstype == v.itemname then
                    if v.hoeveelheid > 0 then
                        TriggerServerEvent("fezco:stortvehicle", Loods, v.itemname, v.hoeveelheid, loodsid, coords, plate)
                    end
                else
                    ESX.ShowNotification("~r~Je hebt geen " .. loodstype .. " in je auto liggen!")
                end
            end
        else
            ESX.ShowNotification("~r~Je hebt geen " .. loodstype .. " in je auto liggen!")
        end
    end, plate)
end

function StartAlleMarkers2(Loodscoordsnavalue)
    if loodslocal2 then
        return
    end
    loodslocal2 = true
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(2)
            goodnight = true
            local playerPed = PlayerPedId()
            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), FEZCO.Drugslabs[Loodscoordsnavalue][1].insideloodstpnaarbuiten.x, FEZCO.Drugslabs[Loodscoordsnavalue][1].insideloodstpnaarbuiten.y, FEZCO.Drugslabs[Loodscoordsnavalue][1].insideloodstpnaarbuiten.z,  true ) < 5 then 
            	goodnight = false
                DrawMarker(-1, FEZCO.Drugslabs[Loodscoordsnavalue][1].insideloodstpnaarbuiten.x, FEZCO.Drugslabs[Loodscoordsnavalue][1].insideloodstpnaarbuiten.y, FEZCO.Drugslabs[Loodscoordsnavalue][1].insideloodstpnaarbuiten.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.3, 120, 240, 120, 100, true, true, 2, true, false, false, false)
                if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), FEZCO.Drugslabs[Loodscoordsnavalue][1].insideloodstpnaarbuiten.x, FEZCO.Drugslabs[Loodscoordsnavalue][1].insideloodstpnaarbuiten.y, FEZCO.Drugslabs[Loodscoordsnavalue][1].insideloodstpnaarbuiten.z -1,  true ) < 1.5 then 	
                    ESX.ShowHelpNotification("Druk op ~INPUT_CONTEXT~ om uit je loods te gaan!")
                    if IsControlJustReleased(0, 38) then 
                        tpweernaarbuiten(Loodscoordsnavalue)
                        Citizen.Wait(100)
                    end
                end
            end 
            if goodnight then
                Wait(500)
            end
        end 
    end)
end


function StartAlleMarkers(Loodscoordsnavalue)
    if loodslocal then
        return
    end
    loodslocal = true
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(2)
            goodnight = true
            local playerPed = PlayerPedId()
            local loodscoords = vector3(FEZCO.Drugslabs[Loodscoordsnavalue].Marker.x, FEZCO.Drugslabs[Loodscoordsnavalue].Marker.y, FEZCO.Drugslabs[Loodscoordsnavalue].Marker.z)
            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), FEZCO.Drugslabs[Loodscoordsnavalue][1].insidemanagementmarker.x, FEZCO.Drugslabs[Loodscoordsnavalue][1].insidemanagementmarker.y, FEZCO.Drugslabs[Loodscoordsnavalue][1].insidemanagementmarker.z,  true ) < 5 then 
            	goodnight = false
                DrawMarker(2, FEZCO.Drugslabs[Loodscoordsnavalue][1].insidemanagementmarker.x, FEZCO.Drugslabs[Loodscoordsnavalue][1].insidemanagementmarker.y, FEZCO.Drugslabs[Loodscoordsnavalue][1].insidemanagementmarker.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.3, 120, 240, 120, 100, true, true, 2, true, false, false, false)
                if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), FEZCO.Drugslabs[Loodscoordsnavalue][1].insidemanagementmarker.x, FEZCO.Drugslabs[Loodscoordsnavalue][1].insidemanagementmarker.y, FEZCO.Drugslabs[Loodscoordsnavalue][1].insidemanagementmarker.z,  true ) < 1.5 then 	
                    ESX.ShowHelpNotification("Druk op ~INPUT_CONTEXT~ om het boss menu te openen!")
                    if IsControlJustReleased(0, 38) then 
                        ESX.TriggerServerCallback("fezco:check:serverid", function(loodsid)
                            print("Loods ID Inside Boss Menu: " .. loodsid)
                            if loodsid then
                                openmanagement_system(Loodscoordsnavalue, loodscoords, loodsid)
                            end
                        end, Loodscoordsnavalue, loodscoords)
                        Citizen.Wait(100)
                    end
                end
            end 
            if goodnight then
                Wait(500)
            end
        end 
    end)
end

function openmanagement_system(loodsje, loodscoords, loodsid)
    ESX.UI.Menu.CloseAll()
  
    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'Drugs',
      {
        title    = loodsje,
        align    = 'top-right',
        elements = {
            {label =  FEZCO.Drugslabs[loodsje].type .. " Loods upgrades",	value = 'loods_upgrades'},
            --{label = "Verplaats je loods",	value = 'verplaats_loods'},

        }
      },
      function(data, menu)
        if data.current.value == 'loods_upgrades' then
            Seeupgrades(loodsje, loodscoords, loodsid)
        elseif data.current.value == 'get_items' then
            check_upgrades(loodsje, loodscoords, loodsid)
        elseif data.current.value == 'add_members' then
            addmembers(loodsje, loodscoords)
        elseif data.current.value == 'check_members' then
            check_members(loodsid)
        end
        

      end,
      function(data, menu)

        menu.close()

        CurrentAction     = 'Drugs'
        CurrentActionData = {station = station}

      end
    )
end

check_members = function(id)
    print("Daggoe: " .. id)
    ESX.TriggerServerCallback("sl_loodsen:server:checkmembers", function(data)
        local check = {}
        print(data)
        for k,v in pairs(data) do 
            print(v.owner)
            table.insert(check, {
                label = v.naam,
                owner = v.user
            })
        end
        ESX.UI.Menu.CloseAll()
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'warehouse_laptop', {
            title = "Check users",
            align = "top-right",
            elements = check
        }, function(data, menu)
            Ontslasessie(data.current, id)
        end, function(data, menu)
            menu.close()
        end)
    end, id)
end

function Ontslasessie(current, id)
    ESX.UI.Menu.CloseAll()
  
    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'Drugs',
      {
        title    = loodsje,
        align    = 'top-right',
        elements = {
            {label =  current.label .. " Ontslaan",	value = 'demotenigger'},
            --{label = "Verplaats je loods",	value = 'verplaats_loods'},

        }
      },
      function(data, menu)
        if data.current.value == 'demotenigger' then
            TriggerServerEvent("sl_loodsen:server:deleteseconduser", current, id)
            menu.close()
        end
        

      end,
      function(data, menu)

        menu.close()

        CurrentAction     = 'Drugs'
        CurrentActionData = {station = station}

      end
    )
end

addmembers = function(Loods, loodscoords)
    local player = PlayerPedId()
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'inventory_item_count_give', {
        title = ('Speler ID')
    }, function(data3, menu3)
        local speler = data3.value
        local spelerdisctance = GetEntityCoords(speler)
        local spelerdistanceyourself = GetEntityCoords(player)
    
            if speler then
                TriggerServerEvent('fezco:server:addloodsenmembers', speler, Loods, loodscoords)
                menu3.close()
            else
                ESX.ShowNotification('~r~Voer een speler id in')
            end
    end, function(data3, menu3)
        menu3.close()
    end)
end



check_upgrades = function(loods, loodscoords, id)
    ESX.TriggerServerCallback("fezco:server:checkupgrades", function(upgrade)
        if upgrade == nil then
            ESX.ShowNotification("~r~Je loods heeft nog geen upgrades")
            return
        end
        for k,v in pairs(FEZCO.Drugslabs[loods][1][2]) do
            if v.value == upgrade then
                ESX.ShowNotification("~b~Je hebt " .. v.string .."")
            end
        end
    end, loods, loodscoords, id)
end

Seeupgrades = function(loods, loodscoords, id)
    ESX.UI.Menu.CloseAll()
    local elements = {}
    
    for k,v in pairs(FEZCO.Drugslabs[loods][1][2]) do
        local price = v.price
        if price then
            table.insert(elements, {
                label = ('%s - <span style="color:green;">%s</span>'):format(v.string, "€" .. ESX.Math.GroupDigits(price)),
                name = v.string,
                price = price,
                value = v.value
            })
        else
            ESX.ShowNotification("Er is iets fout gegaan, probeer het later opnieuw")
        end
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'upgrades', {
        title    = 'Upgrades',
        align    = 'top-right',
        elements = elements
    }, function(data, menu)
            print("test")
            ESX.TriggerServerCallback("fezco:server:buyupgrades", function(bought)
                if bought then
                    menu.close()
                    for k,v in pairs(FEZCO.Drugslabs[loods][1][2]) do
                        if v.value == data.current.value then
                            ESX.ShowNotification("Je hebt " .. v.string .. " gekocht!")
                            TriggerServerEvent("fezco:server:updateloods", data.current.value, id)
                        end
                    end
                else
                    print("no")
                end
            end, loods, data.current.name, data.current.price, data.current.value, loodscoords)
    end, function(data, menu)
        menu.close()
        menuOpen = false
    end)
end


RegisterNetEvent('fezco:client:setverwerkklaar')
AddEventHandler('fezco:client:setverwerkklaar', function(Loods, loodscoords, doneverwerkingitems)
    TriggerServerEvent("fezco:server:verwerk", Loods, loodscoords, doneverwerkingitems)
end)



function tpweernaarbuiten(k)
    local player = PlayerPedId()
    
    exports['ninno-notifications']:Notify('info', 'Loods aan het verlaten..', 1250)
    TaskStartScenarioInPlace(player, 'PROP_HUMAN_PARKING_METER', 0, false)

	Citizen.Wait(1250)
	ClearPedTasks(player)
	Citizen.Wait(500)
    
    DoScreenFadeOut(500)
    Citizen.Wait(500)
    SetEntityCoords(player, FEZCO.Drugslabs[k].Marker.x, FEZCO.Drugslabs[k].Marker.y, FEZCO.Drugslabs[k].Marker.z)
    Citizen.Wait(500)
    DoScreenFadeIn(500)
end


Canuseweaponslots = function(loods, loodscoords, upgrades)
    for k,v in pairs(FEZCO.Drugslabs[loods][1][2]) do
        if v.value == upgrades then
            if v.weaponuse == false then
                return false
            end
        end
    end
    return true
end


function OpenSkidMenu(zemmer, loodscoords, id)
    ESX.TriggerServerCallback("fezco:server:checkupgrades", function(upgrade)
        local options = {
            {
                title = "Stort " .. FEZCO.Drugslabs[zemmer].type .. "",
                onSelect = function()
                    stortitemsaap(zemmer, id)
                end
            },
            {
                title = "Haal verwerkte " .. FEZCO.Drugslabs[zemmer].type .. " eruit",
                onSelect = function()
                    haalitemseruit(zemmer, id)
                end
            },
            {
                title = "Check " .. FEZCO.Drugslabs[zemmer].type .. " planten",
                onSelect = function()
                    check_platen(zemmer, id)
                end
            }
        }

        if Canuseweaponslots(zemmer, loodscoords, upgrade) then
            table.insert(options, {
                title = 'Stort Wapens',
                onSelect = function()
                    stortzemmerswapens(zemmer, loodscoords)
                end
            })
            table.insert(options, {
                title = 'Haal wapens uit de wapenkluis',
                onSelect = function()
                    OpenGetWeaponMenu(zemmer, loodscoords)
                end
            })
        end

        lib.registerContext({
            id = 'skid_menu',
            title = 'Loods',
            options = options
        })

        lib.showContext('skid_menu')
    end, zemmer, loodscoords, id)
end


function stortzemmerswapens(loods, loodscoords)
	local elements   = {}
	local playerPed  = GetPlayerPed(-1)
	local weaponList = ESX.GetWeaponList()
  
	for i=1, #weaponList, 1 do
  
	  local weaponHash = GetHashKey(weaponList[i].name)
  
	  if HasPedGotWeapon(playerPed,  weaponHash,  false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
		local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
		table.insert(elements, {label = (weaponList[i].label .. " | " ..  ammo), value = weaponList[i].name, value2 = ammo})
	  end
  
	end
  

	ESX.UI.Menu.Open(
	  'default', GetCurrentResourceName(), 'armory_put_weapon',
	  {
		title    = ('Sla Wapen op in de Kluis'),
		align    = 'top-right',
		elements = elements,
	  },
	  function(data, menu)
  
		menu.close()
		ESX.TriggerServerCallback('fezcoloodsen:getRandomNumber', function(randomNumber)
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'anti_duplicate', {
				title = "Druk het cijfer " .. randomNumber .. " in om het wapen op te slagen"
			}, function(data2, menu2)
				local quantity = tonumber(data2.value)

				if quantity ~= nil and quantity == randomNumber then
					menu2.close()
					ESX.TriggerServerCallback('fezco:loodssen:addArmoryWeapon', function()
					  OpenPutWeaponMenu()
					end, data.current.value, data.current.value2, loods, loodscoords)
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end)
	  end,
	  function(data, menu)
		menu.close()
	  end
	)
  
end

function OpenGetWeaponMenu(loods, loodscoords)

	ESX.TriggerServerCallback('fezcoloods:getArmoryWeapons', function(data)
  
	  local elements = {}
  
	  for i=1, #data, 1 do
		table.insert(elements, {label = ESX.GetWeaponLabel(data[i].wapen) .. " | " .. data[i].ammo .. "x Kogels | " .. data[i].name, value = data[i].wapen, id = data[i].id })
	  end
  
	  ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'armory_get_weapon',
		{
		  title    = ('Pak Wapens uit de Kluis'),
		  align    = 'top-right',
		  elements = elements,
		},
		function(data, menu)
  
		  menu.close()
  
		  ESX.TriggerServerCallback('sl_loodsen:removeArmoryWeapon', function()
			OpenGetWeaponMenu()
		  end, data.current.value, data.current.id)
  
		end,
		function(data, menu)
		  menu.close()
		end
	  )
  
	end, loods, loodscoords)
  
end

check_platen = function(loodstype, id)
    local elements = {}
    local loodscoords = vector3(FEZCO.Drugslabs[loodstype].Marker.x, FEZCO.Drugslabs[loodstype].Marker.y, FEZCO.Drugslabs[loodstype].Marker.z)
    
    ESX.TriggerServerCallback('fezco:checkonverwerkteplanten', function(count)
        if count == nil then
            exports['ninno-notifications']:Notify('warning', 'Je hebt geen onverwerkte ingrediënten in je loods', 2500)
            return
        end

        table.insert(elements, {
            title = (count .. "x " .. FEZCO.Drugslabs[loodstype].databaseitem),
            value = FEZCO.Drugslabs[loodstype].databaseitem,
            amount = count,
            onSelect = function()
                local input = lib.inputDialog('Aantal', {
                    { type = 'number', label = 'Aantal', default = 1, min = 1, max = count }
                })
                if input then    
                    local aantal = tonumber(input[1])
                    
                    if aantal == nil then
                        exports['ninno-notifications']:Notify('warning', 'Dit is geen geldig aantal.', 2500)
                    else                        
                        if aantal > count then
                            exports['ninno-notifications']:Notify('warning', 'Er zitten niet zoveel ingrediënten in je loods', 2500)
                        else 
                            if FEZCO.CanRemoveingredienten then
                                local item = FEZCO.Drugslabs[loodstype].databaseitem
                                print(item, aantal, id)
                                ESX.TriggerServerCallback("fezco:nigger", function(bought)
                                    
                                    if bought then
                                        print("Succes")
                                    else
                                        print("Geen succes")
                                    end
                                end, loodstype, loodscoords, aantal, item, id)
                            else
                                exports['ninno-notifications']:Notify("Je kan geen onverwerkte ingrediënten uit je loods halen")
                            end
                        end
                    end
                end
            end
        })

        lib.registerContext({
            id = 'check_platen_menu',
            title = 'Loodsen',
            options = elements
        })

        lib.showContext('check_platen_menu')
    end, loodstype, loodscoords, id)
end


haalitemseruit = function(loodstype, id)
    local elements = {}
    local loodscoords = vector3(FEZCO.Drugslabs[loodstype].Marker.x, FEZCO.Drugslabs[loodstype].Marker.y, FEZCO.Drugslabs[loodstype].Marker.z)
    
    ESX.TriggerServerCallback('fezco:checkloodsinventory', function(count)
        if count == nil then
            exports['ninno-notifications']:Notify('warning', 'Je hebt geen verwerkte ingrediënten in je loods', 2500)
            return
        end

        table.insert(elements, {
            title = (count .. "x " .. FEZCO.Drugslabs[loodstype][1].databaseverwerkitem),
            value = FEZCO.Drugslabs[loodstype][1].databaseverwerkitem,
            amount = count,
            onSelect = function()
               local input = lib.inputDialog('Aantal', {
                    { type = 'number', label = 'Aantal', default = 1, min = 1, max = count }
                })
                    local aantal = tonumber(input[1])
                if input then
                    if not aantal or aantal <= 0 then
                        exports['ninno-notifications']:Notify('error', 'Dit is geen geldig aantal.', 2500)
                    elseif aantal > count then
                        exports['ninno-notifications']:Notify('error', 'Er zitten niet zoveel ingrediënten in je loods.', 2500)
                    else
                        ESX.TriggerServerCallback("fezco:getitemsoutloods", function(bought)
                            if bought then
                                print("Succes")
                            else
                                print("Fout")
                            end
                        end, loodstype, aantal, id)

                        ESX.SetTimeout(200, function()
                            OpenSkidMenu()
                        end)
                    end
                end
            end
        })

        lib.registerContext({
            id = 'haalitemseruit_menu',
            title = 'Loodsen',
            options = elements
        })

        lib.showContext('haalitemseruit_menu')
    end, loodstype, loodscoords, id)
end


stortitemsaap = function(loodstype, id)
    local elements = {}
    local inventory = ESX.GetPlayerData().inventory
    local count = 0

    for i = 1, #inventory, 1 do
        if inventory[i].name == FEZCO.Drugslabs[loodstype].databaseitem then
            count = inventory[i].count
        end
    end

    table.insert(elements, {
        title = (count .. "x "  .. FEZCO.Drugslabs[loodstype].databaseitem),
        value = FEZCO.Drugslabs[loodstype].databaseitem,
        amount = count,
        onSelect = function()
            local input = lib.inputDialog('Aantal', {
                { type = 'number', label = 'Aantal', default = 1, min = 1, max = count }
            })

            if input then
                local aantal = tonumber(input[1])
                if aantal then   
                    if aantal > 0 then
                        if aantal > count then
                            exports['ninno-notifications']:Notify('error', 'Je hebt niet zo veel ingrediënten.', 2500)
                        else
                            print(id)
                            print(aantal)
                            print(loodstype)
                            ESX.TriggerServerCallback("fezco:putitems:verkoop", function(bought)
                            end, loodstype, aantal, FEZCO.Drugslabs[loodstype].databaseitem, id)
                        end
                    else
                        exports['ninno-notifications']:Notify('error', 'Dit is geen geldig aantal.', 2500)
                    end
                end
            end
        end
    })

    lib.registerContext({
        id = 'stortitemsaap_menu',
        title = 'Loodsen',
        options = elements
    })

    lib.showContext('stortitemsaap_menu')
end


    


function OpenDrugsLoods(aap, coords)
    StartAlleMarkers(aap)
    StartAlleMarkers2(aap)
    StartAlleMarkers3(aap)

    ESX.UI.Menu.CloseAll()

    lib.registerContext({
        id = 'drugs_loods_menu',
        title = 'Enter Loods',
        options = {
            {
                title = 'Ga naar binnen',
                onSelect = function()
                    enterloods(aap)
                end,
            },
            {
                title = 'Verkoop je loods',
                onSelect = function()
                    VerkoopLoods(aap, menu, coords)
                end,
            },
        },
    })

    lib.showContext('drugs_loods_menu')
end

function VerkoopLoods(Loods, menu, coords)
    local speler = PlayerPedId()

    local input = lib.inputDialog('Verkoop je loods', {
        { type = 'input', label = 'Reden', description = 'Voer een reden in', placeholder = 'Reden...'},
        { type = 'checkbox', label = 'Ik ben zeker van mijn verkoop' }
    })


        if input then
            local reden = input[1]
            local checkboxValue = input[2]

            if checkboxValue then
                TriggerServerEvent("fezco:deleteloods", Loods, coords)
                exports['ninno-notifications']:Notify('succes', 'Je hebt succesvol de loods verkocht met de reden: '.. reden, 2500)
            else
                exports['ninno-notifications']:Notify('error', 'Je moet akkoord gaan met de verkoopvoorwaarden!', 2500)
            end
        else
            exports['ninno-notifications']:Notify('error', 'Vul de vereiste informatie in om je loods te verkopen.', 2500)
        end

end


-- verkoop_loodsje = function(Loods, menu, coords)
--     local speler = PlayerPedId()
--     TriggerServerEvent("fezco:deleteloods", Loods, coords)
-- end

local datatest = {}


function enterloods(k, menu)
    local player = PlayerPedId()
    
	exports['ninno-notifications']:Notify('info', 'Loods aan het inladen..', 1850)
    TaskStartScenarioInPlace(player, 'PROP_HUMAN_PARKING_METER', 0, false)

	Citizen.Wait(1250)
	ClearPedTasks(player)
	Citizen.Wait(500)
    
    
    DoScreenFadeOut(400)
    Citizen.Wait(500)
    SetEntityHeading(player, FEZCO.Drugslabs[k].Tpinside.h)
    SetEntityCoords(player, FEZCO.Drugslabs[k].Tpinside.x, FEZCO.Drugslabs[k].Tpinside.y, FEZCO.Drugslabs[k].Tpinside.z)
    Citizen.Wait(500)
    DoScreenFadeIn(500)
end


function OpenDrugsinfo(x, y)
    local player = PlayerPedId()

    ESX.UI.Menu.CloseAll()

    lib.registerContext({
        id = 'drugs_info',
        title = 'Koop Loods',
        options = {
            {
                title = "Koop " .. FEZCO.Drugslabs[x].type .. " Loods",
                description = "€" .. FEZCO.Drugslabs[x].prijs,
                icon = 'pills',
                onSelect = function(data, menu)
                    local input = lib.inputDialog('Loods kopen', {
                        { type = 'input', label = 'Loods naam', description = 'Voer tekst in', placeholder = "type (" .. FEZCO.Drugslabs[x].type .. ") over " },
                        { type = 'checkbox', label = 'Ik ben zeker van mijn aankoop' }
                    })

                    if input then
                        local tekstInput = input[1]
                        local checkboxValue = input[2]

                        if tekstInput == FEZCO.Drugslabs[x].type then
                            if checkboxValue then
                                kooploods(x, menu, y)
                            else
                                exports['ninno-notifications']:Notify('error', 'Je hebt de checkbox vergeten!', 2500)
                            end
                        else
                            exports['ninno-notifications']:Notify('error', 'Je hebt het verkeerd overgeschreven.', 2500)
                        end
                    end
                end
            }
        }
    })

    lib.showContext('drugs_info')
end

kooploods = function(x, menu, y)

    local player = PlayerPedId()
    local typeloods = FEZCO.Drugslabs[x].type
    local priceloods = FEZCO.Drugslabs[x].prijs
    local limietaantal = FEZCO.Drugslabs[x][1].limititems


    if typeloods and priceloods and limietaantal then
        print("test")
        ESX.TriggerServerCallback("fezco:buyloods", function(bought)
        print("test2")
            if bought then 
                exports['ninno-notifications']:Notify('succes', 'Je hebt succes vol ' .. typeloods ..' loods gekocht !', 2500)
            else
                exports['ninno-notifications']:Notify('error', 'Er is iets misgegaan bij het kopen van de loods..', 2500)
            end
        end, typeloods, priceloods, limietaantal, x, y)
    else
        exports['ninno-notifications']:Notify('error', 'Er ontbreken gegevens voor het kopen van de loods!', 2500)
        menu.close()
    end
end


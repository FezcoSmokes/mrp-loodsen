ESX = nil

local verwerkteitemsamount = nil
local cokeiteminloods = nil
local LastTime = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local data = {}
local DataLoodsen = {}


RegisterCommand("get_loods", function(source, args, rawCommand)
    local loodsding = FEZCO.Drugslabs["Eerste Loods"].insertserversided
    print(loodsding)
    if DataLoodsen[loodsding] ~= nil then
        print(DataLoodsen[loodsding].buyed)
        --DataLoodsen[loodsding] = {loods = Loods, buyed = DataLoodsen[loodsding].buyed + 1}
    else
        DataLoodsen[loodsding] = {loods = Loods, buyed = 0}
        print(DataLoodsen[loodsding].buyed)
        print("No Loodsen")
    end
end, false)


ESX.RegisterServerCallback('fezco:loodssen:addArmoryWeapon', function(source, cb, weaponName, ammo, loods, loodscoords)
    local xPlayer = ESX.GetPlayerFromId(source)
    local jobname = xPlayer.job.name
    local owner = ESX.GetPlayerFromId(source).identifier
    local name = getIdentity(owner)
	local playerHex = string.gsub(tostring(GetPlayerIdentifier(source)), 'license:', '')
    local voornaam = name.firstname
    local _, weaponObject = ESX.GetWeapon(weaponName)
    local weaponComponentList = weaponObject.components or {}
    local x,y,z = table.unpack(loodscoords)
    local weaponComponents = {}
    for i = 1, #weaponComponentList do 
        local weaponComponent = weaponComponentList[i].name
        if xPlayer.hasWeaponComponent(weaponName, weaponComponent) then 
            table.insert(weaponComponents, weaponComponent)
        end
    end
	local componentslogs = json.encode(weaponComponents)
    xPlayer.removeWeapon(weaponName)
    MySQL.Async.fetchAll("SELECT * FROM fezco_drugslab WHERE drugs_name = @drugs_name AND drugs_type = @drugs_type AND drugs_coords = @drugs_coords", {
        ["@drugs_name"] = loods,
        ["@drugs_type"] = FEZCO.Drugslabs[loods].type,
        ["@drugs_coords"] = x ..",".. y ..","..  z,
    }, function(result)
        if result[1] then
            if result[1].owner == xPlayer.identifier then
                MySQL.Async.execute("INSERT INTO fezco_loodsenopslag_weapons (drugsloods_coords, drugsloods_type, wapen, ammo, name, components, owner) VALUES (@drugsloods_coords, @drugsloods_type, @wapen, @ammo, @name, @components, @owner)", {
                    ["@owner"] = xPlayer.identifier,
                    ["@drugsloods_coords"] = x ..",".. y ..","..  z,
                    ["@drugsloods_type"] = FEZCO.Drugslabs[loods].type,
                    ["@wapen"] = weaponName,
                    ["@ammo"] = ammo,
                    ["@name"] = voornaam,
                    ['@components'] = json.encode(weaponComponents)
                })
            else
                MySQL.Async.fetchAll('SELECT * FROM fezco_drugslab', function(resultdjalla)
                    for k,v in pairs(resultdjalla) do
                        local user = json.decode(resultdjalla[k].secondusers)
                        for _, game in pairs(user) do
                            if game.user == xPlayer.identifier then
                                MySQL.Async.execute("INSERT INTO fezco_loodsenopslag_weapons (drugsloods_coords, drugsloods_type, wapen, ammo, name, components, owner) VALUES (@drugsloods_coords, @drugsloods_type, @wapen, @ammo, @name, @components, @owner)", {
                                    ["@owner"] = v.owner,
                                    ["@drugsloods_coords"] = x ..",".. y ..","..  z,
                                    ["@drugsloods_type"] = FEZCO.Drugslabs[loods].type,
                                    ["@wapen"] = weaponName,
                                    ["@ammo"] = ammo,
                                    ["@name"] = voornaam,
                                    ['@components'] = json.encode(weaponComponents)
                                })
                            end
                        end
                    end
                end)
            end
        end
    end)
end)

function getIdentity(owner)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = owner})
	if result[1] ~= nil then
		local identity = result[1]

		return {
			identifier = identity['identifier'],
			firstname = identity['firstname'],
			lastname = identity['lastname'],
		}
	else
		return nil
	end
end


ESX.RegisterServerCallback('fezcoloodsen:getRandomNumber', function(source, cb)
	cb(math.random(1111,9999))
end)

ESX.RegisterServerCallback('fezcoloods:getArmoryWeapons', function(source, cb, loods, coordsloodsje)
	local xPlayer = ESX.GetPlayerFromId(source)
	local job = xPlayer.job.name
    local x,y,z = table.unpack(coordsloodsje)
    local identifier = xPlayer.identifier
    local data = {}
    MySQL.Async.fetchAll("SELECT * FROM fezco_drugslab WHERE drugs_name = @drugs_name AND drugs_type = @drugs_type AND drugs_coords = @drugs_coords", {
        ["@drugs_name"] = loods,
        ["@drugs_type"] = FEZCO.Drugslabs[loods].type,
        ["@drugs_coords"] = x ..",".. y ..","..  z,
    }, function(result)
        if result[1] then
            if result[1].owner == identifier then
                MySQL.Async.fetchAll("SELECT * FROM fezco_loodsenopslag_weapons WHERE drugsloods_coords = @drugsloods_coords AND drugsloods_type = @drugsloods_type AND owner = @owner", {
                    ["@drugsloods_coords"] = x ..",".. y ..","..  z,
                    ["@drugsloods_type"] = FEZCO.Drugslabs[loods].type,
                    ["@owner"] = identifier
                }, function(result)
                    for k,v in pairs(result) do 
                        table.insert(data, {
                            id = v.id,
                            wapen = v.wapen,
                            ammo = v.ammo,
                            name = v.name
                        })
                    end
                    cb(data)
                end)
            else
                MySQL.Async.fetchAll('SELECT * FROM fezco_drugslab', function(resultasiodhpowie)
                    for k,v in pairs(resultasiodhpowie) do
                        local user = json.decode(resultasiodhpowie[k].secondusers)
                        for _, game in pairs(user) do
                            if game.user == xPlayer.identifier then
                                MySQL.Async.fetchAll("SELECT * FROM fezco_loodsenopslag_weapons WHERE drugsloods_coords = @drugsloods_coords AND drugsloods_type = @drugsloods_type AND owner = @owner", {
                                    ["@drugsloods_coords"] = x ..",".. y ..","..  z,
                                    ["@drugsloods_type"] = FEZCO.Drugslabs[loods].type,
                                    ["@owner"] = v.owner,
                                }, function(result500000)
                                    for k,v in pairs(result500000) do
                                        table.insert(data, {
                                            id = v.id,
                                            wapen = v.wapen,
                                            ammo = v.ammo,
                                            name = v.name
                                        })
                                    end
                                    cb(data)
                                end)
                            end
                        end
                    end
                end)
            end
        end
    end)
end)

RegisterServerEvent("fezco:server:apenverwerken")
AddEventHandler("fezco:server:apenverwerken", function(id)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local time = GetTime()
    MySQL.Async.fetchAll("SELECT * FROM fezco_drugslab WHERE owner = @owner", {
        ["@owner"] = xPlayer.identifier
    }, function(result)
        if result[1] then
            local upgrades = result[1].upgrades
            local loodscoords = result[1].drugs_coords
            for k,v in pairs(FEZCO.Verwerkdrugstimes) do
                if time.m == v.verwerktijd then
                    local niggertriggerfligger = v.verwerkteitems
                    Runsecondverwerkfunction(niggertriggerfligger, upgrades, result[1].drugs_name, loodscoords)
                    break
                end
            end
        end
    end)
end)


Runsecondverwerkfunction = function(items, upgrades, Loods, loodscoords)
    for k,v in pairs(FEZCO.Drugslabs[Loods][1][2]) do
        local valueupgrades = v.value
        if valueupgrades == upgrades then
            local plusitems = v.verwerkingitems
            local doneverwerkingitems = tonumber(items + plusitems)
            TriggerClientEvent("fezco:client:setverwerkklaar", -1, Loods, loodscoords, doneverwerkingitems)
            break
        end
    end
end



ESX.RegisterServerCallback('fezco:buyloods', function(source, cb, typeloods, loodsprice, limiet, loodsname, loodscoords)
    local ownedCars = {}
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier
    local x, y, z = table.unpack(loodscoords)
    local loodsding = FEZCO.Drugslabs[loodsname].insertserversided

    print("Aankoop poging: ", typeloods, loodsprice, limiet, loodsname, x, y, z)

    MySQL.Async.fetchAll("SELECT * FROM fezco_drugslab WHERE owner = @owner AND drugs_type = @type", {
        ["@owner"] = identifier,
        ["@type"] = typeloods
    }, function(result)
        if result[1] then
            print("Loods al in bezit: ", typeloods)
            xPlayer.showNotification("~r~Je hebt deze loods al")
            cb(false) -- Geef `false` terug om aan te geven dat de aankoop is mislukt
        else
            if xPlayer.getAccount(FEZCO.Bank).money >= loodsprice then
                print("Koper heeft genoeg geld: ", xPlayer.getAccount(FEZCO.Bank).money, loodsprice)
                xPlayer.removeAccountMoney(FEZCO.Bank, loodsprice)
                MySQL.Async.execute("INSERT INTO fezco_drugslab (owner, drugs_type, drugs_name, drugs_coords, upgrades, itemlimits, secondusers) VALUES (@owner, @drugs_type, @drugs_name, @drugs_coords, @upgrades, @itemlimits, @secondusers)", {
                    ["@owner"] = identifier,
                    ["@drugs_type"] = typeloods,
                    ["@drugs_name"] = loodsname,
                    ["@drugs_coords"] = x .. "," .. y .. "," .. z,
                    ["@upgrades"] = 0,
                    ["@itemlimits"] = limiet,
                    ["@secondusers"] = "{}"
                })
                if DataLoodsen[loodsding] ~= nil then
                    DataLoodsen[loodsding] = {loods = Loods, buyed = DataLoodsen[loodsding].buyed + 1}
                else
                    DataLoodsen[loodsding] = {loods = Loods, buyed = 1}
                end
                SendToDiscord(source, loodsprice, typeloods, loodsname, loodscoords)
                print("Aankoop succesvol: ", typeloods)
                cb(true) -- Geef `true` terug om aan te geven dat de aankoop is gelukt
            else
                print("Koper heeft niet genoeg geld: ", xPlayer.getAccount(FEZCO.Bank).money, loodsprice)
                xPlayer.showNotification("~r~Je hebt niet genoeg geld")
                cb(false) -- Geef `false` terug om aan te geven dat de aankoop is mislukt
            end
        end
    end)
end)



ESX.RegisterServerCallback('fezco:nigger', function(source, cb, loods, loodscoords, count, item, id)
    local ownedCars = {}
	local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier
    local x,y,z = table.unpack(loodscoords)
    MySQL.Async.fetchAll("SELECT * FROM fezco_drugslab WHERE id = @id", {
        ["@id"] = id
	}, function(result)
        if result[1].owner == identifier then
            MySQL.Async.fetchAll("SELECT * FROM fezco_drugs_items WHERE owner = @owner AND drugs_name = @drugs_name AND drugs_coords = @drugs_coords", {
                ["@owner"] = identifier,
                ["@drugs_name"] = loods,
                ["@drugs_coords"] = x ..",".. y ..","..  z,
            }, function(result3)
                local itemlimitsfirst = tonumber(result3[1].itemlimits)
                MySQL.Async.execute("UPDATE fezco_drugs_items SET itemlimits = @itemlimits WHERE owner = @owner AND drugs_name = @drugs_name AND drugs_coords = @drugs_coords", {
                    ["@itemlimits"] = itemlimitsfirst - count,
                    ["@owner"] = identifier,
                    ["@drugs_name"] = loods,
                    ["@drugs_coords"] = x ..",".. y ..","..  z,
                })
                exports.ox_inventory:AddItem(source, item, count)
                cb(true)
            end)
        else
            MySQL.Async.fetchAll('SELECT * FROM fezco_drugslab ', function(result500)
                for k,v in pairs(result500) do
                    local user = json.decode(result500[k].secondusers)
                    for _, game in pairs(user) do
                        if game.user == xPlayer.identifier then
                            MySQL.Async.fetchAll("SELECT * FROM fezco_drugs_items WHERE owner = @owner AND drugs_name = @drugs_name AND drugs_coords = @drugs_coords", {
                                ["@owner"] = v.owner,
                                ["@drugs_name"] = loods,
                                ["@drugs_coords"] = x ..",".. y ..","..  z,
                            }, function(result3)
                                local itemlimitsfirst = tonumber(result3[1].itemlimits)
                                MySQL.Async.execute("UPDATE fezco_drugs_items SET itemlimits = @itemlimits WHERE owner = @owner AND drugs_name = @drugs_name AND drugs_coords = @drugs_coords", {
                                    ["@itemlimits"] = itemlimitsfirst - count,
                                    ["@owner"] = v.owner,
                                    ["@drugs_name"] = loods,
                                    ["@drugs_coords"] = x ..",".. y ..","..  z,
                                })
                                exports.ox_inventory:AddItem(source, item, count)
                                cb(true)
                            end)
                        end
                    end
                end
            end)
        end
    end)
end)

RegisterServerEvent("fezco:check:coords:server")
AddEventHandler("fezco:check:coords:server", function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifier = xPlayer.identifier
    MySQL.Async.fetchAll("SELECT * FROM fezco_drugslab", {
	}, function(result)
        for k,v in pairs(result) do
            local bought = v.gekocht
            TriggerClientEvent("fezco:sendresult", -1, bought)
        end
    end)
end)

RegisterServerEvent("sl_loodsen:server:deleteseconduser")
AddEventHandler("sl_loodsen:server:deleteseconduser", function(current, id)
    local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
    local identifier = xPlayer.identifier
    MySQL.Async.fetchAll("SELECT * FROM fezco_drugslab WHERE id = @id", {
        ["@id"] = id
	}, function(result)
        if result[1] then
            for k,v in pairs(result) do
                local user = json.decode(result[k].secondusers)
                for k,v in pairs(user) do
                    MySQL.Async.execute("UPDATE fezco_drugslab SET secondusers = @secondusers WHERE id = @id", {
                        ["@id"] = id,
                        ["@secondusers"] = "{}"
                    })
                    xPlayer.showNotification("Je hebt met ~g~succes~s~ ontslagen!")
                end
            end
        end
    end)
end)

DeleteVehicleItem = function(plate, item, count)
    local returnValue = nil
    
    TriggerEvent('esx_trunk:getSharedDataStore', plate, function(store)
        local coffre = store.get('coffre') or {}
        for i=1, #coffre do
            if coffre[i].name == item then
                if (coffre[i].count >= count and count > 0) then
                    if (coffre[i].count - count) == 0 then
                        table.remove(coffre,i)
                    else
                        coffre[i].count = coffre[i].count - count
                    end
                    break
                else
                    returnValue = false 
                end
            end
        end
        
        store.set('coffre',coffre)
        if returnValue ~= false then 
          returnValue = true
        end
    end)

    return returnValue
end

  

RegisterServerEvent("fezco:stortvehicle")
AddEventHandler("fezco:stortvehicle", function(loodsname, item, count, id, loodscoords, plate)
    local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
    local identifier = xPlayer.identifier
    local x,y,z = table.unpack(loodscoords)
    DeleteVehicleItem(plate, item, count)
    MySQL.Async.fetchAll("SELECT * FROM fezco_drugslab WHERE id = @id", {
        ["@id"] = id
	}, function(result)
        if result[1] then
            if result[1].owner == identifier then
                MySQL.Async.fetchAll("SELECT * FROM fezco_drugs_items WHERE owner = @owner AND drugs_soort = @drugs_soort AND drugs_coords = @drugs_coords AND item = item", {
                    ["@owner"] = identifier,
                    ["@drugs_soort"] = FEZCO.Drugslabs[loodsname].databaseitem,
                    ['@drugs_coords'] = x ..",".. y ..","..  z,
                    ["@item"] = item
                }, function(result2)
                    if result2[1] then
                        MySQL.Async.execute("UPDATE fezco_drugs_items SET itemlimits = @itemlimits WHERE owner = @owner AND drugs_name = @drugs_name AND drugs_coords = @drugs_coords AND drugs_soort = drugs_soort AND item = item", {
                            ["@owner"] = identifier,
                            ["@drugs_name"] = loodsname,
                            ["@drugs_coords"] = x ..",".. y ..","..  z,
                            ["@drugs_soort"] = FEZCO.Drugslabs[loodsname].databaseitem,
                            ["@item"] = item,
                            ["@itemlimits"] = result2[1].itemlimits + count
                        })
                    else
                        MySQL.Async.execute("INSERT INTO fezco_drugs_items (owner, drugs_name, drugs_coords, drugs_soort, item, itemlimits) VALUES (@owner, @drugs_name, @drugs_coords, @drugs_soort, @item, @itemlimits)", {
                            ["@owner"] = identifier,
                            ["@drugs_name"] = loodsname,
                            ["@drugs_coords"] = x ..",".. y ..","..  z,
                            ["@drugs_soort"] = FEZCO.Drugslabs[loodsname].databaseitem,
                            ["@item"] = item,
                            ["@itemlimits"] = count
                        })
                    end
                    xPlayer.showNotification("Je hebt " .. count .. "x " .. item .. " weggelegd")
                end)
            else
                MySQL.Async.fetchAll('SELECT * FROM fezco_drugslab', function(result500)
                    for k,v in pairs(result500) do
                        local user = json.decode(result500[k].secondusers)
                        for _, game in pairs(user) do
                            if game.user == xPlayer.identifier then
                                MySQL.Async.fetchAll("SELECT * FROM fezco_drugs_items WHERE owner = @owner AND drugs_soort = @drugs_soort AND drugs_coords = @drugs_coords AND item = item", {
                                    ["@owner"] = v.owner,
                                    ["@drugs_soort"] = FEZCO.Drugslabs[loodsname].databaseitem,
                                    ['@drugs_coords'] = x ..",".. y ..","..  z,
                                    ["@item"] = item
                                }, function(result2)
                                    if result2[1] then
                                        MySQL.Async.execute("UPDATE fezco_drugs_items SET itemlimits = @itemlimits WHERE owner = @owner AND drugs_name = @drugs_name AND drugs_coords = @drugs_coords AND drugs_soort = drugs_soort AND item = item", {
                                            ["@owner"] = v.owner,
                                            ["@drugs_name"] = loodsname,
                                            ["@drugs_coords"] = x ..",".. y ..","..  z,
                                            ["@drugs_soort"] = FEZCO.Drugslabs[loodsname].databaseitem,
                                            ["@item"] = item,
                                            ["@itemlimits"] = result2[1].itemlimits + count
                                        })
                                    else
                                        MySQL.Async.execute("INSERT INTO fezco_drugs_items (owner, drugs_name, drugs_coords, drugs_soort, item, itemlimits) VALUES (@owner, @drugs_name, @drugs_coords, @drugs_soort, @item, @itemlimits)", {
                                            ["@owner"] = v.owner,
                                            ["@drugs_name"] = loodsname,
                                            ["@drugs_coords"] = x ..",".. y ..","..  z,
                                            ["@drugs_soort"] = FEZCO.Drugslabs[loodsname].databaseitem,
                                            ["@item"] = item,
                                            ["@itemlimits"] = count
                                        })
                                    end
                                    xPlayer.showNotification("Je hebt " .. count .. "x " .. item .. " weggelegd")
                                end)
                            end
                        end
                    end
                end)
            end
        end
    end)
end)

ESX.RegisterServerCallback('fezco:server:checkupgrades', function(source, cb, loodsje, loodscoords, id)
	local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier
    local x,y,z = table.unpack(loodscoords)
    local loodstype = FEZCO.Drugslabs[loodsje].type
    --print("identifier: " .. identifier)
    MySQL.Async.fetchAll("SELECT * FROM fezco_drugslab WHERE id = @id", {
        ["@id"] = id
	}, function(result)
        if result[1] then
            cb(result[1].upgrades)
        else
            print("result[1] niks")
        end
    end)
end)

ESX.RegisterServerCallback('fezco:check:vehiclesloods', function(source, cb, looods, loodscoords)
	local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier
    local x,y,z = table.unpack(loodscoords)
    MySQL.Async.fetchAll('SELECT * FROM fezco_drugslab WHERE owner = @owner AND drugs_name = @drugs_name AND drugs_coords = @drugs_coords', {
        ["@owner"] = identifier,
        ['@drugs_name'] = looods,
        ['@drugs_coords'] = x ..",".. y ..","..  z,
    }, function(result)
        if result[1] then
            cb(true, result[1].id)
        else
            MySQL.Async.fetchAll('SELECT * FROM fezco_drugslab WHERE drugs_name = @drugs_name AND drugs_coords = @drugs_coords', {
                ['@drugs_name'] = looods,
                ['@drugs_coords'] = x ..",".. y ..","..  z,
            }, function(result500)
                for k,v in pairs(result500) do
                    if v.secondusers ~= "{}" then
                        local alleusers = json.decode(result500[k].secondusers)
                        for _, game in pairs(alleusers) do
                            if game.user == identifier then
                                cb(true, v.id)
                            else
                                cb(false)
                            end
                        end
                    end
                end
            end)
        end
    end)
end)

ESX.RegisterServerCallback('fezco:server:getvehicleinv',function(source, cb, plate)
    local data = {}
    MySQL.Async.fetchAll("SELECT * FROM truck_inventory WHERE plate = @plate", {
        ["@plate"] = plate
	}, function(result)
        if result[1] then
            for k,v in pairs(result) do
                table.insert(data, {
                    id = v.id,
                    itemname = v.item,
                    hoeveelheid = v.count,
                    name = v.name
                })
            end
            cb(data)
        end
    end)
end)

ESX.RegisterServerCallback('fezco:server:buyupgrades', function(source, cb, loodsje, upgradestring, price, valuedatabase, coordsvanloods)
	local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier
    local x,y,z = table.unpack(coordsvanloods)
    local loodstype = FEZCO.Drugslabs[loodsje].type
    MySQL.Async.fetchAll("SELECT * FROM fezco_drugslab WHERE owner = @owner AND drugs_type = @drugs_type AND drugs_coords = @drugs_coords", {
        ["@owner"] = identifier,
		["@drugs_type"] = loodstype,
        ["@drugs_coords"] = x ..",".. y ..","..  z,
	}, function(result)
        if not result[1].owner == identifier then
            xPlayer.showNotification("~r~Alleen de baas van deze loods kan de loods upgraden")
            return
        end
        if xPlayer.getAccount(FEZCO.Bank).money >= price then
            xPlayer.removeAccountMoney(FEZCO.Bank, price)
            MySQL.Async.execute("UPDATE fezco_drugslab SET upgrades = @upgrades WHERE owner = @owner AND drugs_type = @drugs_type AND drugs_name = @drugs_name AND drugs_coords = @drugs_coords", {
                ["@owner"] = identifier,
                ["@drugs_type"] = loodstype,
                ["@drugs_name"] = loodsje,
                ["@drugs_coords"] = x ..",".. y ..","..  z,
                ["@upgrades"] = valuedatabase
            })
            SendToDiscord4(source, loodsje, loodstype, price, valuedatabase)
            cb(true)
        else
            xPlayer.showNotification("~r~Je hebt niet genoeg geld op de bank")
            cb(false)
        end  
    end)
end)

ESX.RegisterServerCallback('fezco:checkloodsinventory', function(source, cb, loodsvalue, loodscoords, id)
    local ownedCars = {}
	local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier
    local x,y,z = table.unpack(loodscoords)
    local itemname = FEZCO.Drugslabs[loodsvalue][1].databaseverwerkitem
    local loodstype = FEZCO.Drugslabs[loodsvalue].type
    MySQL.Async.fetchAll("SELECT * FROM fezco_drugslab WHERE id = @id", {
        ["@id"] = id
	}, function(result)
        if result[1] then
            if result[1].owner == identifier then
                MySQL.Async.fetchAll("SELECT * FROM fezco_drugs_verwerkteitems WHERE owner = @owner AND drugs_name = @drugs_name AND drugs_coords = @drugs_coords AND item = @item", {
                    ["@owner"] = identifier,
                    ["@drugs_name"] = loodsvalue,
                    ["@drugs_coords"] = x ..",".. y ..","..  z,
                    ["@item"] = itemname,
                }, function(result)
                    if result[1] then
                        local verwerkteitemsamount = result[1].itemcount
                        cb(verwerkteitemsamount)
                    else
                        cb(nil)
                    end
                end)
            else
                MySQL.Async.fetchAll('SELECT * FROM fezco_drugslab', function(result35234)
                    for k,v in pairs(result35234) do
                        local user = json.decode(result35234[k].secondusers)
                        for _, game in pairs(user) do
                            if game.user == xPlayer.identifier then
                                MySQL.Async.fetchAll("SELECT * FROM fezco_drugs_verwerkteitems WHERE owner = @owner AND drugs_name = @drugs_name AND drugs_coords = @drugs_coords AND item = @item", {
                                    ["@owner"] = v.owner,
                                    ["@drugs_name"] = loodsvalue,
                                    ["@drugs_coords"] = x ..",".. y ..","..  z,
                                    ["@item"] = itemname,
                                }, function(result)
                                    if result[1] then
                                        local verwerkteitemsamount = result[1].itemcount
                                        cb(verwerkteitemsamount)
                                    else
                                        cb(nil)
                                    end
                                end)
                            end
                        end
                    end
                end)
            end
        end
    end)
end)

ESX.RegisterServerCallback('fezco:checkonverwerkteplanten', function(source, cb, loodsvalue, loodscoords, serverid)
	local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier
    local x,y,z = table.unpack(loodscoords)
    local itemname = FEZCO.Drugslabs[loodsvalue].databaseitem
    MySQL.Async.fetchAll("SELECT * FROM fezco_drugslab WHERE id = @id", {
        ["@id"] = serverid,
	}, function(result)
        if result[1] then
            if result[1].owner == identifier then
                MySQL.Async.fetchAll("SELECT * FROM fezco_drugs_items WHERE owner = @owner AND drugs_name = @drugs_name AND drugs_coords = @drugs_coords AND item = @item", {
                    ["@owner"] = identifier,
                    ["@drugs_name"] = loodsvalue,
                    ["@drugs_coords"] = x ..",".. y ..","..  z,
                    ["@item"] = itemname
                }, function(result300)
                    if result300[1] then
                        local onverwerkteshit = result300[1].itemlimits
                        cb(onverwerkteshit)
                    else
                        cb(nil)
                    end
                end)
            else
                MySQL.Async.fetchAll('SELECT * FROM fezco_drugslab', {}, function(result500)
                    for k,v in pairs(result500) do
                        if v.secondusers ~= "{}" then
                            local alleusers = json.decode(result500[k].secondusers)
                            for _, game in pairs(alleusers) do
                                if game.user == identifier then
                                    MySQL.Async.fetchAll("SELECT * FROM fezco_drugs_items WHERE owner = @owner AND drugs_name = @drugs_name AND drugs_coords = @drugs_coords AND item = @item", {
                                        ["@owner"] = v.owner,
                                        ["@drugs_name"] = loodsvalue,
                                        ["@drugs_coords"] = x ..",".. y ..","..  z,
                                        ["@item"] = itemname
                                    }, function(result523)
                                        if result523[1] then
                                            local onverwerkteshit = result523[1].itemlimits
                                            cb(onverwerkteshit)
                                        else
                                            cb(nil)
                                        end
                                    end)
                                else
                                    cb(false)
                                end
                            end
                        end
                    end
                end)
            end
        end
    end)
end)

ESX.RegisterServerCallback('sl_loodsen:removeArmoryWeapon', function(source, cb, weaponName, id)
	local xPlayer = ESX.GetPlayerFromId(source)
	local job = xPlayer.job.name
	local playerHex = string.gsub(tostring(GetPlayerIdentifier(source)), 'license:', '')
	MySQL.Async.fetchAll("SELECT * FROM fezco_loodsenopslag_weapons WHERE id = @id", {
		["@id"] = id
	}, function(result)

		MySQL.Async.execute("DELETE FROM fezco_loodsenopslag_weapons WHERE id = @id", {["@id"] = id})
		xPlayer.addWeapon(result[1].wapen, result[1].ammo)
		local components = json.decode(result[1].components)
		for i,v in ipairs(components) do 
			xPlayer.addWeaponComponent(result[1].wapen, v)
		end
    end)
	cb()
end)

ESX.RegisterServerCallback('fezco:getitemsoutloods', function(source, cb, loodsvalue, amount, id)
    local ownedCars = {}
	local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier
    local loodscoords = vector3(FEZCO.Drugslabs[loodsvalue].Marker.x, FEZCO.Drugslabs[loodsvalue].Marker.y, FEZCO.Drugslabs[loodsvalue].Marker.z)
    local x,y,z = table.unpack(loodscoords)
    local itemname = FEZCO.Drugslabs[loodsvalue][1].databaseverwerkitem
    MySQL.Async.fetchAll("SELECT * FROM fezco_drugslab WHERE id = @id", {
        ["@id"] = id,
    }, function(result)
        if result[1] then
            if result[1].owner == identifier then
                MySQL.Async.fetchAll("SELECT * FROM fezco_drugs_verwerkteitems WHERE owner = @owner AND drugs_name = @drugs_name AND drugs_coords = @drugs_coords", {
                    ["@owner"] = identifier,
                    ["@drugs_name"] = loodsvalue,
                    ["@drugs_coords"] = x ..",".. y ..","..  z,
                }, function(result)
                    if result[1] then
                        local databaseamount = result[1].itemcount
                        local item = result[1].item
                        if xPlayer.canCarryItem(item, amount) then
                            if (databaseamount - amount) >= 0 then
                                if (databaseamount - amount) == 0 then
                                    MySQL.Async.execute("DELETE FROM fezco_drugs_verwerkteitems WHERE owner = @owner AND drugs_name = @drugs_name AND drugs_coords = @drugs_coords", {
                                        ["@owner"] = identifier,
                                        ["drugs_name"] = loodsvalue,
                                        ["drugs_coords"] = x ..",".. y ..","..  z,
                                    })
                                else
                                    MySQL.Async.execute("UPDATE fezco_drugs_verwerkteitems SET itemcount = @itemcount WHERE owner = @owner AND drugs_name = @drugs_name AND drugs_coords = @drugs_coords AND item = item", {
                                        ["@owner"] = identifier,
                                        ["@drugs_name"] = loodsvalue,
                                        ["@drugs_coords"] = x ..",".. y ..","..  z,
                                        ["@item"] = item,
                                        ["@itemcount"] = databaseamount - amount
                                    })
                                end
                                exports.ox_inventory:AddItem(source, item, amount)

                                xPlayer.showNotification("Je hebt ~b~" .. amount .. "x " .. itemname .. "~s~ opgenomen vanuit je " .. FEZCO.Drugslabs[loodsvalue].type .." loods")
                            else
                                xPlayer.showNotification("~r~Er liggen niet zo veel ingredienten in je loods")
                            end
                        else
                            xPlayer.showNotification("~r~Je inventory zit vol!")
                        end
                    else
                        cb(nil)
                    end
                end)
            else
                MySQL.Async.fetchAll('SELECT * FROM fezco_drugslab', function(resultnigga)
                    for k,v in pairs(resultnigga) do
                        local user = json.decode(resultnigga[k].secondusers)
                        for k,v in pairs(user) do
                            if v.user == xPlayer.identifier then
                                MySQL.Async.fetchAll("SELECT * FROM fezco_drugs_verwerkteitems WHERE owner = @owner AND drugs_name = @drugs_name AND drugs_coords = @drugs_coords", {
                                    ["@owner"] = resultnigga[1].owner,
                                    ["@drugs_name"] = loodsvalue,
                                    ["@drugs_coords"] = x ..",".. y ..","..  z,
                                }, function(result)
                                    if result[1] then
                                        local databaseamount = result[1].itemcount
                                        local item = result[1].item
                                        if xPlayer.canCarryItem(item, amount) then
                                            if (databaseamount - amount) >= 0 then
                                                if (databaseamount - amount) == 0 then
                                                    MySQL.Async.execute("DELETE FROM fezco_drugs_verwerkteitems WHERE owner = @owner AND drugs_name = @drugs_name AND drugs_coords = @drugs_coords", {
                                                        ["@owner"] = resultnigga[1].owner,
                                                        ["drugs_name"] = loodsvalue,
                                                        ["drugs_coords"] = x ..",".. y ..","..  z,
                                                    })
                                                else
                                                    MySQL.Async.execute("UPDATE fezco_drugs_verwerkteitems SET itemcount = @itemcount WHERE owner = @owner AND drugs_name = @drugs_name AND drugs_coords = @drugs_coords AND item = item", {
                                                        ["@owner"] = resultnigga[1].owner,
                                                        ["@drugs_name"] = loodsvalue,
                                                        ["@drugs_coords"] = x ..",".. y ..","..  z,
                                                        ["@item"] = item,
                                                        ["@itemcount"] = databaseamount - amount
                                                    })
                                                end
                                                xPlayer.addInventoryItem(item, amount)
                                                xPlayer.showNotification("Je hebt ~b~" .. amount .. "x " .. itemname .. "~s~ opgenomen vanuit je " .. FEZCO.Drugslabs[loodsvalue].type .." loods")
                                            else
                                                xPlayer.showNotification("~r~Er liggen niet zo veel ingredienten in je loods")
                                            end
                                        else
                                            xPlayer.showNotification("~r~Je inventory zit vol!")
                                        end
                                    else
                                        cb(nil)
                                    end
                                end)
                            end
                        end
                    end
                end)
            end
        end
    end)
end)


ESX.RegisterServerCallback('fezco:putitems:verkoop', function(source, cb, loodsname, aantal, item, id)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier
    local loodscoords = vector3(FEZCO.Drugslabs[loodsname].Marker.x, FEZCO.Drugslabs[loodsname].Marker.y, FEZCO.Drugslabs[loodsname].Marker.z)
    local x, y, z = table.unpack(loodscoords)
    exports.ox_inventory:RemoveItem(source, item, aantal)

    print("DEBUG: Verwijderd " .. aantal .. "x " .. item .. " van de speler")
    local query = "SELECT * FROM fezco_drugslab WHERE id = @id"

    print("DEBUG: Uit te voeren query: " .. query)
    
    MySQL.Async.fetchAll(query, {
        ["@id"] = id
    }, function(result)
        print("DEBUGG: Resultaat van de query: " .. json.encode(result))
        if result[1] then
            print("DEBUGG: Eerste resultaat: " .. json.encode(result[1]))
            if result[1].owner == identifier then
                MySQL.Async.fetchAll("SELECT * FROM fezco_drugs_items WHERE owner = @owner AND drugs_soort = @drugs_soort AND drugs_coords = @drugs_coords AND item = item", {
                    ["@owner"] = identifier,
                    ["@drugs_soort"] = FEZCO.Drugslabs[loodsname].databaseitem,
                    ['@drugs_coords'] = x ..",".. y ..","..  z,
                    ["@item"] = item
                }, function(result2)
                    if result2[1] then
                        print("DEBUG: Bestaand item in de database gevonden")
                        MySQL.Async.execute("UPDATE fezco_drugs_items SET itemlimits = @itemlimits WHERE owner = @owner AND drugs_name = @drugs_name AND drugs_coords = @drugs_coords AND drugs_soort = drugs_soort AND item = item", {
                            ["@owner"] = identifier,
                            ["@drugs_name"] = loodsname,
                            ["@drugs_coords"] = x ..",".. y ..","..  z,
                            ["@drugs_soort"] = FEZCO.Drugslabs[loodsname].databaseitem,
                            ["@item"] = item,
                            ["@itemlimits"] = result2[1].itemlimits + aantal
                        }, function(rowsChanged)
                            print("DEBUG: " .. rowsChanged .. " rijen bijgewerkt in de database")
                            xPlayer.showNotification("Je hebt " .. aantal .. "x " .. item .. " weggelegd")
                            SendToDiscord3(source, loodsname, item, loodscoords, aantal)
                            cb(true)
                        end)
                    else
                        print("DEBUG: Nieuw item in de database ingevoegd")
                        MySQL.Async.execute("INSERT INTO fezco_drugs_items (owner, drugs_name, drugs_coords, drugs_soort, item, itemlimits) VALUES (@owner, @drugs_name, @drugs_coords, @drugs_soort, @item, @itemlimits)", {
                            ["@owner"] = identifier,
                            ["@drugs_name"] = loodsname,
                            ["@drugs_coords"] = x ..",".. y ..","..  z,
                            ["@drugs_soort"] = FEZCO.Drugslabs[loodsname].databaseitem,
                            ["@item"] = item,
                            ["@itemlimits"] = aantal
                        }, function(rowsInserted)
                            print("DEBUG: " .. rowsInserted .. " rijen ingevoegd in de database")
                            xPlayer.showNotification("Je hebt " .. aantal .. "x " .. item .. " weggelegd")
                            SendToDiscord3(source, loodsname, item, loodscoords, aantal)
                            cb(true)
                        end)
                    end
                end)
            else
                print("DEBUG: Speler is niet de eigenaar van de loods")
                MySQL.Async.fetchAll('SELECT * FROM fezco_drugslab', function(result500)
                    for k,v in pairs(result500) do
                        local user = json.decode(result500[k].secondusers)
                        for _, game in pairs(user) do
                            if game.user == xPlayer.identifier then
                                print("DEBUG: Speler is geautoriseerd voor deze loods")
                                MySQL.Async.fetchAll("SELECT * FROM fezco_drugs_items WHERE owner = @owner AND drugs_soort = @drugs_soort AND drugs_coords = @drugs_coords AND item = item", {
                                    ["@owner"] = v.owner,
                                    ["@drugs_soort"] = FEZCO.Drugslabs[loodsname].databaseitem,
                                    ['@drugs_coords'] = x ..",".. y ..","..  z,
                                    ["@item"] = item
                                }, function(result2)
                                    if result2[1] then
                                        print("DEBUG: Bestaand item in de database gevonden")
                                        MySQL.Async.execute("UPDATE fezco_drugs_items SET itemlimits = @itemlimits WHERE owner = @owner AND drugs_name = @drugs_name AND drugs_coords = @drugs_coords AND drugs_soort = drugs_soort AND item = item", {
                                            ["@owner"] = v.owner,
                                            ["@drugs_name"] = loodsname,
                                            ["@drugs_coords"] = x ..",".. y ..","..  z,
                                            ["@drugs_soort"] = FEZCO.Drugslabs[loodsname].databaseitem,
                                            ["@item"] = item,
                                            ["@itemlimits"] = result2[1].itemlimits + aantal
                                        }, function(rowsChanged)
                                            print("DEBUG: " .. rowsChanged .. " rijen bijgewerkt in de database")
                                            xPlayer.showNotification("Je hebt " .. aantal .. "x " .. item .. " weggelegd")
                                            SendToDiscord3(source, loodsname, item, loodscoords, aantal)
                                            cb(true)
                                        end)
                                    else
                                        print("DEBUG: Nieuw item in de database ingevoegd")
                                        MySQL.Async.execute("INSERT INTO fezco_drugs_items (owner, drugs_name, drugs_coords, drugs_soort, item, itemlimits) VALUES (@owner, @drugs_name, @drugs_coords, @drugs_soort, @item, @itemlimits)", {
                                            ["@owner"] = v.owner,
                                            ["@drugs_name"] = loodsname,
                                            ["@drugs_coords"] = x ..",".. y ..","..  z,
                                            ["@drugs_soort"] = FEZCO.Drugslabs[loodsname].databaseitem,
                                            ["@item"] = item,
                                            ["@itemlimits"] = aantal
                                        }, function(rowsInserted)
                                            print("DEBUG: " .. rowsInserted .. " rijen ingevoegd in de database")
                                            xPlayer.showNotification("Je hebt " .. aantal .. "x " .. item .. " weggelegd")
                                            SendToDiscord3(source, loodsname, item, loodscoords, aantal)
                                            cb(true)
                                        end)
                                    end
                                end)
                            end
                        end
                    end
                end)
            end
        end
    end)
end)


ESX.RegisterServerCallback('sl_loodsen:server:checkmembers', function(source, cb, serverid)
    local datavoorserver = {}
	local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier
    MySQL.Async.fetchAll('SELECT * FROM fezco_drugslab WHERE id = @id', {
        ['@id'] = tonumber(serverid)
    }, function(result)
        if result[1] then
            for k,v in pairs(result) do
                local user = json.decode(result[k].secondusers)
                for k,v in pairs(user) do
                    table.insert(datavoorserver, {
                        owner = v.user,
                        naam = v.name
                    })
                end
                cb(datavoorserver)
            end
        else
            print("no result")
        end
    end)
end)

ESX.RegisterServerCallback('fezco:check:serverid', function(source, cb, looods, loodscoords)
    local datavoorserver = {}
	local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier
    local x,y,z = table.unpack(loodscoords)
    MySQL.Async.fetchAll('SELECT * FROM fezco_drugslab WHERE drugs_name = @drugs_name AND drugs_coords = @drugs_coords', {
        ['@drugs_name'] = looods,
        ['@drugs_coords'] = x ..",".. y ..","..  z,
    }, function(result)
        if result[1] then
            for k,v in pairs(result) do
                if v.owner == identifier then
                    print("Owner")
                    local loodsid = v.id
                    cb(loodsid)
                else
                    MySQL.Async.fetchAll('SELECT * FROM fezco_drugslab WHERE drugs_name = @drugs_name AND drugs_coords = @drugs_coords', {
                        ['@drugs_name'] = looods,
                        ['@drugs_coords'] = x ..",".. y ..","..  z,
                    }, function(result500)
                        for k,v in pairs(result500) do
                            if v.secondusers ~= "{}" then
                                local alleusers = json.decode(result500[k].secondusers)
                                for _, game in pairs(alleusers) do
                                    if game.user == identifier then
                                        cb(v.id)
                                    else
                                        cb(false)
                                    end
                                end
                            end
                        end
                    end)
                end
            end
        else
            print("no result1")
        end
    end)
end)


ESX.RegisterServerCallback('fezco:checkloodsen', function(source, cb, loods, loodscoords)
	local xPlayer  = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier
    local x,y,z = table.unpack(loodscoords)
    local typelodos = FEZCO.Drugslabs[loods].type
    local max = tonumber(FEZCO.Drugslabs[loods].maxtobuy)
    local loodsding = FEZCO.Drugslabs[loods].insertserversided
    local buyedform
    if DataLoodsen[loodsding] ~= nil then
        buyedform = tonumber(DataLoodsen[loodsding].buyed)
    else
        buyedform = 0
    end
    MySQL.Async.fetchAll('SELECT * FROM fezco_drugslab WHERE owner = @owner AND drugs_name = @drugs_name AND drugs_coords = @drugs_coords', {
		['@owner'] = identifier,
        ['@drugs_name'] = loods,
        ['@drugs_coords'] = x ..",".. y ..","..  z,
	}, function(result)
        if result[1] then
            local loodsid = result[1].id
            cb("heeftloods", loodsid)
        else
            MySQL.Async.fetchAll('SELECT * FROM fezco_drugslab WHERE drugs_name = @drugs_name AND drugs_coords = @drugs_coords', {
                ['@drugs_name'] = loods,
                ['@drugs_coords'] = x ..",".. y ..","..  z,
            }, function(result500)
                for k,v in pairs(result500) do
                    if v.secondusers ~= "{}" then
                        local alleusers = json.decode(result500[k].secondusers)
                        for _, game in pairs(alleusers) do
                            if game.user == identifier then
                                cb("seconduser", v.id)
                            end
                        end
                    end
                end
                if max > buyedform then
                    cb(false, 0)
                else
                    cb("niet", 0)
                end
            end)
        end
    end)
end)


RegisterServerEvent("fezco:server:addloodsenmembers")
AddEventHandler("fezco:server:addloodsenmembers", function(player, loods, loodscoords)
    local targetid = ESX.GetPlayerFromId(player)
    local xPlayer = ESX.GetPlayerFromId(source)
    local x,y,z = table.unpack(loodscoords)
    if targetid ~= nil then
        if targetid.name == xPlayer.getName() then
            xPlayer.showNotification("~r~Je kan jezelf niet toevoegen aan je eigen loods")
            return
        end

        MySQL.Async.fetchAll('SELECT * FROM fezco_drugslab WHERE owner = @owner AND drugs_coords = @drugs_coords AND drugs_type = @drugs_type', {
            ['@owner'] = xPlayer.identifier,
            ['@drugs_coords'] = x ..",".. y ..","..  z,
            ['@drugs_type'] = FEZCO.Drugslabs[loods].type
        }, function(result)
            if not result[1].owner == xPlayer.identifier then
                xPlayer.showNotification("~r~Alleen de baas van deze loods kan second users toevoegen")
                return
            end
            local loodsusers = result[1]
            local users = json.decode(loodsusers.secondusers)
            local useralreadyexist = false
            if #users < FEZCO.Drugslabs[loods].maxsecondusers then
                for k,v in pairs(users) do
                    if v.user == targetid.identifier then
                        useralreadyexist = true
                        break
                    end
                end
                if useralreadyexist then
                    xPlayer.showNotification("Deze gebruiker is heeft al de sleutel!")
                else
                    table.insert(users, {user = targetid.identifier, name = targetid.name})
                    MySQL.Async.execute("UPDATE fezco_drugslab SET secondusers = @secondusers WHERE owner = @owner AND drugs_coords = @drugs_coords AND drugs_type = @drugs_type", {
                        ["@owner"] = xPlayer.identifier,
                        ["@secondusers"] = json.encode(users),
                        ["@drugs_coords"] = result[1].drugs_coords,
                        ["@drugs_type"] = result[1].drugs_type,
                    })
                    xPlayer.showNotification("Je hebt met succes ~g~ " .. targetid.name .. "~s~ aangenomen")
                end
            else
                xPlayer.showNotification("Je kan niet meer dan 5 gebruikers toevoegen!")
            end
        end)
    else
        xPlayer.showNotification("~r~Deze speler is niet online!")
    end
end)

RegisterServerEvent("fezco:deleteloods")
AddEventHandler("fezco:deleteloods", function(loods, loodscoords)
    local src = source 
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifier = xPlayer.identifier
    local x,y,z = table.unpack(loodscoords)
    local typeloods = FEZCO.Drugslabs[loods].type
    local loodsding = FEZCO.Drugslabs[loods].insertserversided
    MySQL.Async.fetchAll('SELECT * FROM fezco_drugslab WHERE owner = @owner AND drugs_name = @drugs_name AND drugs_coords = @drugs_coords', {
		['@owner'] = identifier,
        ['@drugs_name'] = loods,
        ['@drugs_coords'] = x ..",".. y ..","..  z
	}, function(result)
        if result[1] then
            MySQL.Async.execute("DELETE FROM fezco_drugslab WHERE owner = @owner AND drugs_name = @drugs_name AND drugs_coords = @drugs_coords", {
                ["@owner"] = identifier,
                ["drugs_name"] = loods,
                ["drugs_coords"] = x ..",".. y ..","..  z,
            })
            if DataLoodsen[loodsding] ~= nil then
                DataLoodsen[loodsding] = {loods = loods, buyed = DataLoodsen[loodsding].buyed - 1}
            else
                DataLoodsen[loodsding] = {loods = Loods, buyed = 0}
                print("Error")
            end
            MySQL.Async.fetchAll("SELECT * FROM fezco_drugs_items WHERE drugs_coords = @drugs_coords AND drugs_name = @drugs_name AND owner = @owner", {
                ["@drugs_coords"] = x ..",".. y ..","..  z,
                ["@drugs_name"] = loods,
                ["@owner"] = identifier
            }, function(result4)
                if result4[1] then
                    MySQL.Async.execute("DELETE FROM fezco_drugs_items WHERE owner = @owner AND drugs_name = @drugs_name AND drugs_coords = @drugs_coords", {
                        ["@owner"] = identifier,
                        ["drugs_name"] = loods,
                        ["drugs_coords"] = x ..",".. y ..","..  z,
                    })
                end
            end)
            MySQL.Async.fetchAll("SELECT * FROM fezco_drugs_verwerkteitems WHERE drugs_coords = @drugs_coords AND drugs_name = @drugs_name AND owner = @owner", {
                ["@drugs_coords"] = x ..",".. y ..","..  z,
                ["@drugs_name"] = loods,
                ["@owner"] = identifier
            }, function(result5)
                if result5[1] then
                    MySQL.Async.execute("DELETE FROM fezco_drugs_verwerkteitems WHERE owner = @owner AND drugs_name = @drugs_name AND drugs_coords = @drugs_coords", {
                        ["@owner"] = identifier,
                        ["drugs_name"] = loods,
                        ["drugs_coords"] = x ..",".. y ..","..  z,
                    })
                end
            end)
            local prijsnaverkoop = tonumber(FEZCO.Drugslabs[loods].prijs / FEZCO.Drugslabs[loods].verkoopprice)
            xPlayer.addAccountMoney(FEZCO.Bank, prijsnaverkoop)
            -- TriggerEvent('ninno-notifications:trigger', 'succes', "Je hebt je ~b~" .. loods .. "~s~ loods verkocht voor ~y~€" .. prijsnaverkoop .."!")


            SendToDiscord2(src, prijsnaverkoop, loods, loodscoords)
        else
            DropPlayer(src, "Banned by fezco Trigger protecter \n Triggerd a negative trigger \n Identifier: " .. identifier .."")
        end
    end)
end)

RegisterServerEvent("fezco:server:updateloods")
AddEventHandler("fezco:server:updateloods", function(value, id)
    local src = source 
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifier = xPlayer.identifier
    local x,y,z = table.unpack(loodscordinaten)
    for k,v in pairs(FEZCO.Drugslabs[loods][1][2]) do
        if v.value == value then
            MySQL.Async.execute("UPDATE fezco_drugslab SET upgrades = @upgrades WHERE id = @id", {
                ["@id"] = id,
            })
        end
    end
end)

RegisterServerEvent("fezco:server:verwerk")
AddEventHandler("fezco:server:verwerk", function(Loods, loodscoords, verwerkteitemscount)
    local src = source 
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifier = xPlayer.identifier
    local time = GetTime()
    local x,y,z = table.unpack(loodscoords)
    if xPlayer then
        MySQL.Async.fetchAll("SELECT * FROM fezco_drugs_items WHERE owner = @owner AND drugs_coords = @drugs_coords AND owner = @owner", {
            ["@owner"] = identifier,
            ["@drugs_coords"] = loodscoords,
            ["@owner"] = identifier
        }, function(result)
            if result[1] then
                if result[1].itemlimits < verwerkteitemscount then
                    xPlayer.showNotification("Je loods kan niet meer verwerken ivm te weinig ingredienten!")
                    return
                end
                MySQL.Async.execute("UPDATE fezco_drugs_items SET itemlimits = @itemlimits WHERE owner = @owner AND drugs_name = @drugs_name AND drugs_coords = @drugs_coords AND drugs_soort = drugs_soort AND item = item", {
                    ["@owner"] = identifier,
                    ["@drugs_name"] = result[1].drugs_name,
                    ["@drugs_coords"] = result[1].drugs_coords,
                    ["@drugs_soort"] = result[1].drugs_soort,
                    ["@item"] = result[1].item,
                    ["@itemlimits"] = result[1].itemlimits - verwerkteitemscount
                })
                MySQL.Async.fetchAll("SELECT * FROM fezco_drugs_verwerkteitems WHERE owner = @owner AND item = @item AND drugs_coords = @drugs_coords AND owner = @owner", {
                    ["@owner"] = identifier,
                    ["@item"] = FEZCO.Drugslabs[Loods][1].databaseverwerkitem,
                    ["@drugs_coords"] = loodscoords,
                    ["@owner"] = identifier
                }, function(result2)
                    if result2[1] then
                        MySQL.Async.execute("UPDATE fezco_drugs_verwerkteitems SET itemcount = @itemcount WHERE owner = @owner AND drugs_name = @drugs_name AND drugs_coords = @drugs_coords AND item = item", {
                            ["@owner"] = identifier,
                            ["@drugs_name"] = result2[1].drugs_name,
                            ["@drugs_coords"] = result2[1].drugs_coords,
                            ["@item"] = FEZCO.Drugslabs[result2[1].drugs_name][1].databaseverwerkitem,
                            ["@itemcount"] = result2[1].itemcount + verwerkteitemscount
                        })
                        xPlayer.showNotification("Je ~y~" .. result2[1].drugs_name .. "~s~ heeft ~b~x" .. verwerkteitemscount .. "~s~ ingredienten verwerkt, je loods heeft nu ~y~x" .. result2[1].itemcount + verwerkteitemscount .. " ingredienten")
                    else
                        MySQL.Async.execute("INSERT INTO fezco_drugs_verwerkteitems (owner, drugs_name, drugs_coords, item, itemcount) VALUES (@owner, @drugs_name, @drugs_coords, @item, @itemcount)", {
                            ["@owner"] = identifier,
                            ["@drugs_name"] = Loods,
                            ["@drugs_coords"] = loodscoords,
                            ["@item"] = FEZCO.Drugslabs[Loods][1].databaseverwerkitem,
                            ["@itemcount"] = verwerkteitemscount
                        })
                        xPlayer.showNotification("Je ~y~" .. Loods .. "~s~ heeft ~b~x" .. verwerkteitemscount .. "~s~ ingredienten verwerkt")
                    end
                end)
            end
        end)
    else
        MySQL.Async.fetchAll("SELECT * FROM fezco_drugs_items WHERE owner = @owner AND drugs_coords = @ AND owner = @owner", {
            ["@owner"] = identifier,
            ["@drugs_coords"] = loodscoords,
            ["@owner"] = identifier
        }, function(result)
            if result[1] then
                if result[1].itemlimits < verwerkteitemscount then
                    return
                end
                MySQL.Async.execute("UPDATE fezco_drugs_items SET itemlimits = @itemlimits WHERE owner = @owner AND drugs_name = @drugs_name AND drugs_coords = @drugs_coords AND drugs_soort = drugs_soort AND item = item", {
                    ["@owner"] = identifier,
                    ["@drugs_name"] = result[1].drugs_name,
                    ["@drugs_coords"] = result[1].drugs_coords,
                    ["@drugs_soort"] = result[1].drugs_soort,
                    ["@item"] = result[1].item,
                    ["@itemlimits"] = result[1].itemlimits - verwerkteitemscount
                })
                MySQL.Async.fetchAll("SELECT * FROM fezco_drugs_verwerkteitems WHERE owner = @owner AND item = @item AND drugs_coords = @drugs_coords", {
                    ["@owner"] = identifier,
                    ["@item"] = FEZCO.Drugslabs[Loods][1].databaseverwerkitem,
                    ["@drugs_coords"] = loodscoords
                }, function(result2)
                    if result2[1] then
                        MySQL.Async.execute("UPDATE fezco_drugs_verwerkteitems SET itemcount = @itemcount WHERE owner = @owner AND drugs_name = @drugs_name AND drugs_coords = @drugs_coords AND item = item", {
                            ["@owner"] = identifier,
                            ["@drugs_name"] = result2[1].drugs_name,
                            ["@drugs_coords"] = result2[1].drugs_coords,
                            ["@item"] = FEZCO.Drugslabs[result2[1].drugs_name][1].databaseverwerkitem,
                            ["@itemcount"] = result2[1].itemcount + verwerkteitemscount
                        })
                    else
                        MySQL.Async.execute("INSERT INTO fezco_drugs_verwerkteitems (owner, drugs_name, drugs_coords, item, itemcount) VALUES (@owner, @drugs_name, @drugs_coords, @item, @itemcount)", {
                            ["@owner"] = identifier,
                            ["@drugs_name"] = Loods,
                            ["@drugs_coords"] = loodscoords,
                            ["@item"] = FEZCO.Drugslabs[Loods][1].databaseverwerkitem,
                            ["@itemcount"] = verwerkteitemscount
                        })
                    end
                end)
            end
        end)
    end
end)




ESX.RegisterServerCallback('fezco:setblips', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll("SELECT * FROM fezco_drugslab WHERE owner = @owner", {
        ["@owner"] = xPlayer.identifier
    }, function(result)
        if result then 
            local loodscoordsforblip = result[1].drugs_coords
            local nameforblip = result[1].drugs_name
            cb(loodscoordsforblip, nameforblip)
        end
    end)
end)

function GetTime()

	local timestamp = os.time()
	local d         = os.date('*t', timestamp).wday
	local h         = tonumber(os.date('%H', timestamp))
	local m         = tonumber(os.date('%M', timestamp))
    local s         = tonumber(os.date('%S', timestamp))

	return {d = d, h = h, m = m, s = s}
end


SendToDiscord = function(source, loodsprice, typeloods, loodsname, loodscoords)
    local discordInfo = {
        ["color"] = "16743168",
        ["type"] = "green",
        ["title"] = "Loodsen Buy Logs",
        ["description"] = "**Steamnaam:** " .. GetPlayerName(source) .. "\n **Identifier:** " .. ESX.GetPlayerFromId(source).identifier .. "\n **Server ID:** " .. source .. "\n **Functie**: Player heeft een Loods gekocht\n **Price:** €" .. loodsprice .. "\n **Type Loods:** " .. typeloods .. "\n **Naam Loods:** " .. loodsname .. "\n **Coords Loods:** " .. loodscoords .. "\n **Player Ping:** " .. GetPlayerPing(source) .. "",
        ["footer"] = {
        ["text"] = "© fezco-Drugslabs Logs | "..os.date("%Y").."  "..os.date("%x %X %p"),
        }
    }
    PerformHttpRequest(FEZCO.Webhook, function(err, text, headers) end, 'POST', json.encode({ username = 'fezco-Drugslabs Logs', content = "" }), { ['Content-Type'] = 'application/json' })
    PerformHttpRequest(FEZCO.Webhook, function(err, text, headers) end, 'POST', json.encode({ username = 'fezco-Logs', embeds = { discordInfo } }), { ['Content-Type'] = 'application/json' })
end

SendToDiscord2 = function(src, prijsnaverkoop, loods, loodscoords)
    local discordInfo = {
        ["color"] = "16743168",
        ["type"] = "red",
        ["title"] = "Loodsen Verkocht Logs",
        ["description"] = "**Steamnaam:** " .. GetPlayerName(src) .. "\n **Identifier:** " .. ESX.GetPlayerFromId(src).identifier .. "\n **Server ID:** " .. src .. "\n **Functie**: Player heeft een Loods verkocht\n **Price:** €" .. prijsnaverkoop .. "\n **Type Loods:** " .. loods .. "\n **Coords Loods:** " .. loodscoords .. "\n **Player Ping:** " .. GetPlayerPing(src) .. "",
        ["footer"] = {
        ["text"] = "© fezco-Drugslabs Logs | "..os.date("%Y").."  "..os.date("%x %X %p"),
        }
    }
    PerformHttpRequest(FEZCO.Webhook, function(err, text, headers) end, 'POST', json.encode({ username = 'fezco-Drugslabs Logs', content = "" }), { ['Content-Type'] = 'application/json' })
    PerformHttpRequest(FEZCO.Webhook, function(err, text, headers) end, 'POST', json.encode({ username = 'fezco-Logs', embeds = { discordInfo } }), { ['Content-Type'] = 'application/json' })
end

SendToDiscord3 = function(source, loodsname, item, loodscoords, aantal)
    local discordInfo = {
        ["color"] = "16743168",
        ["type"] = "red",
        ["title"] = "Item in Loods",
        ["description"] = "**Steamnaam:** " .. GetPlayerName(source) .. "\n **Identifier:** " .. ESX.GetPlayerFromId(source).identifier .. "\n **Server ID:** " .. source .. "\n **Functie**: Player heeft een item in zijn loods gelegd\n **Item:** " .. item .. "\n **Hoeveelheid:** " .. aantal .. "\n **Loods:** " .. loodsname .. "\n **Loods Type:** " .. FEZCO.Drugslabs[loodsname].type .. "\n **Coords Loods:** " .. loodscoords .. "\n **Player Ping:** " .. GetPlayerPing(source) .. "",
        ["footer"] = {
        ["text"] = "© fezco-Drugslabs Logs | "..os.date("%Y").."  "..os.date("%x %X %p"),
        }
    }
    PerformHttpRequest(FEZCO.Webhook, function(err, text, headers) end, 'POST', json.encode({ username = 'fezco-Drugslabs Logs', content = "" }), { ['Content-Type'] = 'application/json' })
    PerformHttpRequest(FEZCO.Webhook, function(err, text, headers) end, 'POST', json.encode({ username = 'fezco-Logs', embeds = { discordInfo } }), { ['Content-Type'] = 'application/json' })
end

SendToDiscord4 = function(source, loodsje, loodstype, price, valuedatabase)
    local discordInfo = {
        ["color"] = "16743168",
        ["type"] = "red",
        ["title"] = "Item in Loods",
        ["description"] = "**Steamnaam:** " .. GetPlayerName(source) .. "\n **Identifier:** " .. ESX.GetPlayerFromId(source).identifier .. "\n **Server ID:** " .. source .. "\n **Functie**: Player heeft zijn loods geupgrade\n **Upgrade:** " .. valuedatabase .. "\n **Prijs:** " .. price .. "\n **Loods Type:** " .. loodstype .. "\n **Loods:** " .. loodsje .. "\n **Player Ping:** " .. GetPlayerPing(source) .. "",
        ["footer"] = {
        ["text"] = "© fezco-Drugslabs Logs | "..os.date("%Y").."  "..os.date("%x %X %p"),
        }
    }
    PerformHttpRequest(FEZCO.Webhook, function(err, text, headers) end, 'POST', json.encode({ username = 'fezco-Drugslabs Logs', content = "" }), { ['Content-Type'] = 'application/json' })
    PerformHttpRequest(FEZCO.Webhook, function(err, text, headers) end, 'POST', json.encode({ username = 'fezco-Logs', embeds = { discordInfo } }), { ['Content-Type'] = 'application/json' })
end


    


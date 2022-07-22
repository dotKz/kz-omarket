local sharedItems = exports['qbr-core']:GetItems()

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        Wait(100)
        exports.oxmysql:execute('UPDATE market_owner SET robbery = 0 WHERE robbery = 1', {})
        if Config.AutoAddMarket then
        TriggerEvent("kz-omarket:server:OMarketAutoAdd")
        end
    end
end)

-------------------------------------------------------------------------------------------
-- Callback
-------------------------------------------------------------------------------------------


exports['qbr-core']:CreateCallback('kz-omarket:server:OMarket', function(source, cb)
    local src = source
    local Player = exports['qbr-core']:GetPlayer(src)
	local Playercid = Player.PlayerData.citizenid

    exports.oxmysql:execute('SELECT * FROM market_owner', {}, function(result)
        if result[1] then
            cb(result)
        else
            cb(nil)
        end
    end)
end)

exports['qbr-core']:CreateCallback('kz-omarket:server:OMarketOwned', function(source, cb, currentOMarket)
    local src = source
    local Player = exports['qbr-core']:GetPlayer(src)
	local Playercid = Player.PlayerData.citizenid

    exports.oxmysql:execute('SELECT * FROM market_owner WHERE marketid = ? AND owned = 1 ', {currentOMarket}, function(result)
        if result[1] then
            cb(result)
        else
            cb(nil)
        end
    end)
end)


exports['qbr-core']:CreateCallback('kz-omarket:server:OMarketOwner', function(source, cb, currentOMarket)
    local src = source
    local Player = exports['qbr-core']:GetPlayer(src)
	local Playercid = Player.PlayerData.citizenid

    exports.oxmysql:execute('SELECT * FROM market_owner WHERE marketid = ? AND owned = 1 AND cid = ? ', {currentOMarket, Playercid}, function(result2)
        if result2[1] then
            cb(result2)
        else
            cb(nil)
        end
    end)
end)

exports['qbr-core']:CreateCallback('kz-omarket:server:OMarketS', function(source, cb, currentOMarket)
    exports.oxmysql:execute('SELECT * FROM market_owner WHERE marketid = ?', {currentOMarket}, function(result)
        if result[1] then
            cb(result)
        else
            cb(nil)
        end
    end)
end)


exports['qbr-core']:CreateCallback('kz-omarket:server:OMarketGetMoney', function(source, cb, currentOMarket)
    local src = source
    local Player = exports['qbr-core']:GetPlayer(src)
	local Playercid = Player.PlayerData.citizenid

    exports.oxmysql:execute('SELECT * FROM market_owner WHERE marketid = ? AND owned = 1 AND cid = ? ', {currentOMarket, Playercid}, function(checkmoney)
        if checkmoney[1] then
            cb(checkmoney[1])
        else
            cb(nil)
        end
    end)
end)

-------------------------------------------------------------------------------------------
-- Event
-------------------------------------------------------------------------------------------

RegisterServerEvent("kz-omarket:server:OMarketGetShopItems")
AddEventHandler("kz-omarket:server:OMarketGetShopItems", function(shopName)
    local _source = source
    exports['oxmysql']:execute('SELECT * FROM market_items WHERE marketid = ?', {shopName}, function(data)
        exports['oxmysql']:execute('SELECT * FROM market_owner WHERE marketid = ?', {shopName}, function(data2)
            TriggerClientEvent("Stores:ReturnStoreItems", _source, data, data2)
        end)
	end)
end)


RegisterServerEvent("kz-omarket:server:OMarketPurchaseItem")
AddEventHandler("kz-omarket:server:OMarketPurchaseItem", function(location, item, amount)
    local src = source
    local Player = exports['qbr-core']:GetPlayer(src)
	local Playercid = Player.PlayerData.citizenid
    
    exports.oxmysql:execute('SELECT * FROM market_items WHERE marketid = ? AND items = ?',{location, item} , function(data)
        local stock = data[1].stock - amount
        local price = data[1].price * amount   
        local currentMoney = Player.Functions.GetMoney('cash')
        if price <= currentMoney then
            MySQL.Async.execute("UPDATE market_items SET stock=@stock WHERE marketid=@location AND items=@item", {['@stock'] = stock, ['@location'] = location, ['@item'] = item}, function(count)
                if count > 0 then
                    Player.Functions.RemoveMoney("cash", price, "market")
                    Player.Functions.AddItem(item, amount)
                    TriggerClientEvent('inventory:client:ItemBox', src, sharedItems[item], "add")
                    MySQL.Async.fetchAll("SELECT * FROM market_owner WHERE marketid=@location", { ['@location'] = location }, function(data2)
                        local moneymarket = data2[1].money + price
                        exports.oxmysql:execute('UPDATE market_owner SET money = ? WHERE marketid = ?',{moneymarket, location})
                    end)
                    TriggerClientEvent('QBCore:Notify', src, 9, Lang:t('success.buy_prod').." "..amount.."x "..sharedItems[item].label, 2000, 0, 'toast_awards_set_q', 'awards_set_q_011', 'COLOR_WHITE')
                end
            end)
        else 
            TriggerClientEvent('QBCore:Notify', src, 9, Lang:t('error.player_no_money'), 2000, 0, 'toast_awards_set_q', 'awards_set_q_002', 'COLOR_WHITE')
        end
    end)
end)


RegisterServerEvent("kz-omarket:server:OMarketInvReFill")
AddEventHandler("kz-omarket:server:OMarketInvReFill", function(location, item, qt, amount)
    local src = source
    local Player = exports['qbr-core']:GetPlayer(src)
	local Playercid = Player.PlayerData.citizenid
    local itemv = item.name
    
    exports.oxmysql:execute('SELECT * FROM market_items WHERE marketid = ? AND items = ?',{location, itemv} , function(result)
        if result[1] ~= nil then
            local stockv = result[1].stock + tonumber(qt)
            --print(stockv)
            exports.oxmysql:execute('UPDATE market_items SET stock = ?, price = ? WHERE marketid = ? AND items = ?',{stockv, amount, location, itemv})
            Player.Functions.RemoveItem(itemv, qt)
            TriggerClientEvent('inventory:client:ItemBox', src, sharedItems[itemv], "remove")
        else
            local price = amount
            exports.oxmysql:execute('INSERT INTO market_items (`marketid`, `items`, `stock`, `price`) VALUES (?, ?, ?, ?);',{location, itemv, qt, price})
            Player.Functions.RemoveItem(itemv, qt)
            TriggerClientEvent('inventory:client:ItemBox', src, sharedItems[itemv], "remove")
        end
        TriggerClientEvent('QBCore:Notify', src, 9, Lang:t('success.refill').." " ..qt.. "x " ..item.label, 2000, 0, 'toast_awards_set_q', 'awards_set_q_011', 'COLOR_WHITE')
    end)
end)


RegisterServerEvent("kz-omarket:server:OMarketWithdraw")
AddEventHandler("kz-omarket:server:OMarketWithdraw", function(location, omoney)
    local src = source
    local Player = exports['qbr-core']:GetPlayer(src)
	local Playercid = Player.PlayerData.citizenid
    
    exports.oxmysql:execute('SELECT * FROM market_owner WHERE marketid= ? AND cid= ?',{location, Playercid} , function(result)
        if result[1] ~= nil then
            if result[1].money >= tonumber(omoney) then
            local nmoney = result[1].money - omoney
            exports.oxmysql:execute('UPDATE market_owner SET money = ? WHERE marketid = ? AND cid = ?',{nmoney, location, Playercid})
            Player.Functions.AddMoney('cash', omoney)
            else
                --Notif
            end
        end
    end)
end)


RegisterServerEvent("kz-omarket:server:OMarketBuyEtal")
AddEventHandler("kz-omarket:server:OMarketBuyEtal", function(location, price)
    local src = source
    local Player = exports['qbr-core']:GetPlayer(src)
	local Playercid = Player.PlayerData.citizenid
    
    exports.oxmysql:execute('SELECT * FROM market_owner WHERE marketid = ? AND owned = 0',{location} , function(result)
        if result[1] ~= nil then
            if Player.Functions.RemoveMoney("cash", price, "etal-bought") then
                exports.oxmysql:execute('UPDATE market_owner SET owned = ?, cid = ? WHERE marketid = ?',{1, Playercid, location})
                --TriggerClientEvent('QBCore:Notify', src, 9, 'Etal acheté pour $'..price, 2000, 0, 'satchel_textures', 'animal_horse', 'COLOR_WHITE')
                TriggerClientEvent('QBCore:Notify', src, 7, Lang:t('success.buy_t'), 2000, Lang:t('success.buy'))
                --TriggerEvent('qbr-log:server:CreateLog', 'shops', 'Etal', 'green', "**"..GetPlayerName(Player.PlayerData.source) .. " (citizenid: "..Player.PlayerData.citizenid.." | id: "..Player.PlayerData.source..")** à acheté une étal $"..price..".")
            else
                TriggerClientEvent('QBCore:Notify', src, 9, Lang:t('error.player_no_money'), 2000, 0, 'toast_awards_set_q', 'awards_set_q_002', 'COLOR_WHITE')
                return
            end
        end
    end)
end)


RegisterServerEvent("kz-omarket:server:OMarketGiveBusiness")
AddEventHandler("kz-omarket:server:OMarketGiveBusiness", function(location, tocid)
    local src = source
    local Player = exports['qbr-core']:GetPlayer(src)
	local Playercid = Player.PlayerData.citizenid
    
    exports.oxmysql:execute('SELECT * FROM players WHERE citizenid = ?',{tocid} , function(result)
        if result[1] ~= nil then
            MySQL.Async.fetchAll("SELECT * FROM market_owner WHERE cid=@cid AND owned=1 AND marketid=@marketid", { ['@marketid'] = location, ['@cid'] = Playercid }, function(result2)
                if result2[1] ~= nil then
                    exports.oxmysql:execute('UPDATE market_owner SET cid = ? WHERE marketid = ?',{tocid, location})
                    TriggerClientEvent('QBCore:Notify', src, 7, Lang:t('success.transfert_t'), 2000, Lang:t('success.transfert').." "..tocid)
                    --TriggerEvent('qbr-log:server:CreateLog', 'shops', 'Etal', 'green', "**"..GetPlayerName(Player.PlayerData.source) .. " (citizenid: "..Player.PlayerData.citizenid.." | id: "..Player.PlayerData.source..")** à acheté une étal $"..price..".")
                else
                    TriggerClientEvent('QBCore:Notify', src, 9, Lang:t('error.error'), 2000, 0, 'toast_awards_set_q', 'awards_set_q_002', 'COLOR_WHITE')
                    return
                end
            end)
        else
            TriggerClientEvent('QBCore:Notify', src, 9, Lang:t('error.error_cid'), 2000, 0, 'toast_awards_set_q', 'awards_set_q_002', 'COLOR_WHITE')
            return
        end
    end)
end)

RegisterServerEvent("kz-omarket:server:OMarketGetName")
AddEventHandler("kz-omarket:server:OMarketGetName", function(shopName)
    local _source = source
    exports['oxmysql']:execute('SELECT * FROM market_items WHERE marketid = ?', {shopName}, function(data)
        TriggerClientEvent("Stores:ReturnStoreItems", _source, data)
	end)
end)

RegisterServerEvent("kz-omarket:server:OMarketName")
AddEventHandler("kz-omarket:server:OMarketName", function(location, name)
    local src = source
    local Player = exports['qbr-core']:GetPlayer(src)
	local Playercid = Player.PlayerData.citizenid
    
    exports.oxmysql:execute('SELECT * FROM market_owner WHERE marketid = ? AND cid = ?',{location, Playercid} , function(result)
        if result[1] ~= nil then
            exports.oxmysql:execute('UPDATE market_owner SET displayname = ? WHERE marketid = ?',{name, location})
            TriggerClientEvent('QBCore:Notify', src, 7, Lang:t('success.newname'), 2000, name)
            --TriggerEvent('qbr-log:server:CreateLog', 'shops', 'Etal', 'green', "**"..GetPlayerName(Player.PlayerData.source) .. " (citizenid: "..Player.PlayerData.citizenid.." | id: "..Player.PlayerData.source..")** à acheté une étal $"..price..".")
        else
            TriggerClientEvent('QBCore:Notify', src, 9, Lang:t('error.error'), 2000, 0, 'toast_awards_set_q', 'awards_set_q_002', 'COLOR_WHITE')
            return
        end
    end)
end)

-------------------------------------------
-- ROBBERY

-------------------------------------------

RegisterServerEvent("kz-omarket:server:OMarketRob")
AddEventHandler("kz-omarket:server:OMarketRob", function(location)
    local src = source
    local Player = exports['qbr-core']:GetPlayer(src)
	local Playercid = Player.PlayerData.citizenid
    
    exports.oxmysql:execute('SELECT * FROM market_owner WHERE marketid = ?',{location} , function(result)
        --print(result[1])
        if result[1].money >= 1 then
            --print(result[1].money)
            local rmoney = result[1].money - result[1].money / Config.Percent
            local rpmoney = result[1].money / Config.Percent
            exports.oxmysql:execute('UPDATE market_owner SET money = ?, robbery = ? WHERE marketid = ?',{rmoney, 1, location})
            Player.Functions.AddMoney("cash", rpmoney, "robbery")
            TriggerClientEvent('QBCore:Notify', src, 9, Lang:t('success.robreward')..rpmoney, 2000, 0, 'pm_awards_mp', 'awards_set_p_002', 'COLOR_WHITE')
            --TriggerEvent('qbr-log:server:CreateLog', 'shops', 'Etal', 'green', "**"..GetPlayerName(Player.PlayerData.source) .. " (citizenid: "..Player.PlayerData.citizenid.." | id: "..Player.PlayerData.source..")** à acheté une étal $"..price..".")
        else
            TriggerClientEvent('QBCore:Notify', src, 9, Lang:t('error.market_no_money'), 2000, 0, 'toast_awards_set_q', 'awards_set_q_002', 'COLOR_WHITE')
            return
        end
    end)
end)

---------------------------------------

RegisterServerEvent("kz-omarket:server:OMarketAutoAdd")
AddEventHandler("kz-omarket:server:OMarketAutoAdd", function()
    for k, v in pairs(Config.Market) do
        Wait(100)
        local result = MySQL.Sync.fetchSingle('SELECT * FROM market_owner WHERE marketid = ?', { k })
        if not result then
            exports.oxmysql:execute('INSERT INTO market_owner (`marketid`, `displayname`) VALUES (?, ?);',{k, k})
            print('New stall : '..k..' has been added to database')
        end
    end        
end)
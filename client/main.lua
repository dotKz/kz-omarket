local currentOMarket = nil
local sharedItems = exports['qbr-core']:GetItems()

-------------------------------------------------------------------------------------------
-- Little Function
-------------------------------------------------------------------------------------------

local function ClearMenu()
	exports['qbr-menu']:closeMenu()
end

local function closeMenuFull()
    currentOMarket = nil
    ClearMenu()
end

RegisterNetEvent("kz-omarket:client:closemenu")
AddEventHandler("kz-omarket:client:closemenu", function()
    closeMenuFull()
end)

-------------------------------------------------------------------------------------------
-- Menu
-------------------------------------------------------------------------------------------

RegisterNetEvent("kz-omarket:client:OMarketMenu", function()
    --print(currentOMarket)
    exports['qbr-core']:TriggerCallback('kz-omarket:server:OMarketOwned', function(result)
        if result == nil then
            --print(currentOMarket)
            local OMarketMenuFirst = {
                {
                    header = "<center><img src="..Config.MenuImg.." width=100%>",
                    isMenuHeader = true
                },
            }
            OMarketMenuFirst[#OMarketMenuFirst+1] = {
                header = Lang:t('menu.buy'),
                icon = 'fa-solid fa-file-invoice-dollar',
                txt = Lang:t('menu.buy_sub').." : $" ..Config.Market[currentOMarket].price,
                params = {
                    event = "kz-omarket:client:OMarketAchat",
                    args = currentOMarket
                }
            }
            OMarketMenuFirst[#OMarketMenuFirst+1] = {
                header = "⬅ "..Lang:t('menu.quit'),
                txt = "",
                params = {
                    event = "kz-omarket:client:closemenu",
                }
            }
            exports['qbr-menu']:openMenu(OMarketMenuFirst)
        else
            exports['qbr-core']:TriggerCallback('kz-omarket:server:OMarketOwner', function(result2)
                if result2 == nil then
                    local OMarketMenuFirst = {
                        {
                            header = "<center><img src="..Config.MenuImg.." width=100%>",
                            isMenuHeader = true
                        },
                    }
                    OMarketMenuFirst[#OMarketMenuFirst+1] = {
                        header = Lang:t('menu.open_market'),
                        txt = Lang:t('menu.open_market_sub'),
                        icon = 'fa-solid fa-store',
                        params = {
                            isServer = true,
                            event = "kz-omarket:server:OMarketGetShopItems",
                            args = currentOMarket
                        }
                    }
                    OMarketMenuFirst[#OMarketMenuFirst+1] = {
                        header = Lang:t('menu.rob'),
                        txt = Lang:t('menu.rob_sub'),
                        icon = 'fa-solid fa-gun',
                        params = {
                            event = "kz-omarket:client:OMarketRob",
                            args = currentOMarket,
                        }
                    }
                    OMarketMenuFirst[#OMarketMenuFirst+1] = {
                        header = "⬅ "..Lang:t('menu.quit'),
                        txt = "",
                        params = {
                            event = "kz-omarket:client:closemenu",
                        }
                    }
                    exports['qbr-menu']:openMenu(OMarketMenuFirst)
                else
                    local OMarketMenuFirst = {
                        {
                            header = "<center><img src="..Config.MenuImg.." width=100%>",
                            isMenuHeader = true
                        },
                    }
                    OMarketMenuFirst[#OMarketMenuFirst+1] = {
                        header = Lang:t('menu.open_market'),
                        txt = Lang:t('menu.open_market_sub'),
                        icon = 'fa-solid fa-store',
                        params = {
                            isServer = true,
                            event = "kz-omarket:server:OMarketGetShopItems",
                            args = currentOMarket
                        }
                    }
                    OMarketMenuFirst[#OMarketMenuFirst+1] = {
                        header = Lang:t('menu.refill'),
                        txt = Lang:t('menu.refill_sub'),
                        icon = 'fa-solid fa-boxes-packing',
                        params = {
                            event = "kz-omarket:client:OMarketInvReFull",
                        }
                    }
                    OMarketMenuFirst[#OMarketMenuFirst+1] = {
                        header = Lang:t('menu.checkmoney'),
                        txt = Lang:t('menu.checkmoney_sub'),
                        icon = 'fa-solid fa-sack-dollar',
                        params = {
                            event = "kz-omarket:client:OMarketCheckMoney",
                            args = data,
                        }
                    }
                    OMarketMenuFirst[#OMarketMenuFirst+1] = {
                        header = Lang:t('menu.manage'),
                        txt = Lang:t('menu.manage_sub'),
                        icon = 'fa-solid fa-sack-dollar',
                        params = {
                            event = "kz-omarket:client:OMarketSettings",
                            args = v,
                        }
                    }
                    OMarketMenuFirst[#OMarketMenuFirst+1] = {
                        header = "⬅ "..Lang:t('menu.quit'),
                        txt = "",
                        params = {
                            event = "kz-omarket:client:closemenu",
                        }
                    }
                    exports['qbr-menu']:openMenu(OMarketMenuFirst)
                end
            end, currentOMarket)
        end
    end, currentOMarket)
end)


RegisterNetEvent("kz-omarket:client:OMarketInv", function(store_inventory, data)
    exports['qbr-core']:TriggerCallback('kz-omarket:server:OMarketS', function(result)
        local OMarketMenuItem = {
            {
                header = "| "..Lang:t('menu.market').." : "..result[1].displayname.." |",
                txt = Lang:t('menu.refill_in'),
                isMenuHeader = true
            },
        }
        for k, v in pairs(store_inventory) do
            if store_inventory[k].stock > 0 then
            OMarketMenuItem[#OMarketMenuItem+1] = {
                header = "<img src=nui://qbr-inventory/html/images/"..sharedItems[store_inventory[k].items].image.." width=20px> ‎ ‎ "..sharedItems[store_inventory[k].items].label,
                txt = Lang:t('menu.instock')..": "..store_inventory[k].stock.." | "..Lang:t('menu.price')..": $"..store_inventory[k].price,
                params = {
                    event = "kz-omarket:client:OMarketInvInput",
                    args = store_inventory[k],
                }
            }
            end
        end

        OMarketMenuItem[#OMarketMenuItem+1] = {
            header = "⬅ "..Lang:t('menu.return_m'),
            txt = "",
            params = {
                event = "kz-omarket:client:OMarketMenu",
            }
        }
        exports['qbr-menu']:openMenu(OMarketMenuItem)
    end, currentOMarket)
end)


RegisterNetEvent("kz-omarket:client:OMarketInvReFull", function()
    exports['qbr-core']:GetPlayerData(function(PlayerData)
        exports['qbr-core']:TriggerCallback('kz-omarket:server:OMarketS', function(result)
            if PlayerData.items == nil then 
                local OMarketMenuNoInvItem = {
                    {
                        header = "| "..Lang:t('menu.market').." : "..result[1].displayname.." |",
                        txt = Lang:t('menu.market_sub'),
                        isMenuHeader = true
                    },
                }
                OMarketMenuNoInvItem[#OMarketMenuNoInvItem+1] = {
                    header = Lang:t('menu.no_item'),
                    txt = Lang:t('menu.no_item_sub'),
                    isMenuHeader = true
                }
                OMarketMenuNoInvItem[#OMarketMenuNoInvItem+1] = {
                    header = "⬅ "..Lang:t('menu.return_m'),
                    txt = "",
                    params = {
                        event = "kz-omarket:client:OMarketMenu",
                    }
                }
                exports['qbr-menu']:openMenu(OMarketMenuNoInvItem)
            else
                local OMarketMenuInvItem = {
                    {
                        header = "| "..Lang:t('menu.market').." : "..result[1].displayname.." |",
                        txt = Lang:t('menu.market_sub'),
                        isMenuHeader = true
                    },
                }
                for k, v in pairs(PlayerData.items) do
                --print(PlayerData.items[k].name.." "..PlayerData.items[k].amount)
                    if PlayerData.items[k].amount > 0 and PlayerData.items[k].type == "item" then
                    OMarketMenuInvItem[#OMarketMenuInvItem+1] = {
                        header = "<img src=nui://qbr-inventory/html/images/"..PlayerData.items[k].image.." width=20px> ‎ ‎ "..PlayerData.items[k].label,
                        txt = Lang:t('menu.in_inv').." : "..PlayerData.items[k].amount,
                        params = {
                            event = "kz-omarket:client:OMarketInvReFillInput",
                            args = PlayerData.items[k],
                        }
                    }
                    end
                end

                OMarketMenuInvItem[#OMarketMenuInvItem+1] = {
                    header = "⬅ "..Lang:t('menu.return_m'),
                    txt = "",
                    params = {
                        event = "kz-omarket:client:OMarketMenu",
                    }
                }
                exports['qbr-menu']:openMenu(OMarketMenuInvItem)
            end
        end, currentOMarket)
    end)
end)


RegisterNetEvent("kz-omarket:client:OMarketCheckMoney", function()
    --print(1)
    exports['qbr-core']:TriggerCallback('kz-omarket:server:OMarketGetMoney', function(checkmoney)
        exports['qbr-core']:TriggerCallback('kz-omarket:server:OMarketS', function(result)
            --print(checkmoney)
            local OMarketMenuMoney = {
                {
                    header = "| "..Lang:t('menu.market').." : "..result[1].displayname.." |",
                    txt = Lang:t('menu.checkmoney_in'),
                    isMenuHeader = true
                },
            }
            OMarketMenuMoney[#OMarketMenuMoney+1] = {
                header = Lang:t('menu.currentmoney').." : $" ..checkmoney.money,
                txt = "",
                isMenuHeader = true
            }
            OMarketMenuMoney[#OMarketMenuMoney+1] = {
                header = Lang:t('menu.withdraw'),
                txt = Lang:t('menu.withdraw_sub'),
                params = {
                    event = "kz-omarket:client:OMarketWithdraw",
                    args =  checkmoney,
                }
            }
            OMarketMenuMoney[#OMarketMenuMoney+1] = {
                header = "⬅ "..Lang:t('menu.return_m'),
                txt = "",
                params = {
                    event = "kz-omarket:client:OMarketMenu",
                }
            }
            exports['qbr-menu']:openMenu(OMarketMenuMoney)
        end, currentOMarket)
    end, currentOMarket)
end)


RegisterNetEvent("kz-omarket:client:OMarketAchat", function(currentOMarket)
    price = Config.Market[currentOMarket].price
    exports['qbr-core']:TriggerCallback('kz-omarket:server:OMarketS', function(result)
        local OMarketAchat = {
            {
                header = "| "..Lang:t('menu.market').." : " ..result[1].displayname.." |",
                txt = Lang:t('menu.buy_price').." : $" ..Config.Market[currentOMarket].price,
                isMenuHeader = true
            },
        }
        OMarketAchat[#OMarketAchat+1] = {
            header = Lang:t('menu.confirm_buy'),
            txt = Lang:t('menu.confirm_buy_sub'),
            params = {
                event = "kz-omarket:client:OMarketBuyEtal",
                args = currentOMarket, price,
            }
        }
        OMarketAchat[#OMarketAchat+1] = {
            header = "⬅ "..Lang:t('menu.quit'),
            txt = "",
            params = {
                event = "kz-omarket:client:closemenu",
            }
        }
        exports['qbr-menu']:openMenu(OMarketAchat)
    end, currentOMarket)
end)


RegisterNetEvent("kz-omarket:client:OMarketSettings", function()
    exports['qbr-core']:TriggerCallback('kz-omarket:server:OMarketS', function(result)
        local OMarketSettings = {
            {
                header = "| "..Lang:t('menu.market').." : " ..result[1].displayname.." |",
                txt = Lang:t('menu.manage_in'),
                isMenuHeader = true
            },
        }
        OMarketSettings[#OMarketSettings+1] = {
            header = Lang:t('menu.manage_in_name'),
            txt = Lang:t('menu.manage_in_name_sub'),
            params = {
                event = "kz-omarket:client:OMarketName",
                args = "",
            }
        }
        OMarketSettings[#OMarketSettings+1] = {
            header = Lang:t('menu.manage_in_give_market'),
            txt = Lang:t('menu.manage_in_give_market_sub'),
            params = {
                event = "kz-omarket:client:OMarketGiveBusiness",
                args = "",
            }
        }
        OMarketSettings[#OMarketSettings+1] = {
            header = "⬅ "..Lang:t('menu.return_m'),
            txt = "",
            params = {
                event = "kz-omarket:client:OMarketMenu",
            }
        }
        exports['qbr-menu']:openMenu(OMarketSettings)
    end, currentOMarket)
end)


-------------------------------------------------------------------------------------------
-- Input
-------------------------------------------------------------------------------------------


RegisterNetEvent("kz-omarket:client:OMarketGiveBusiness", function()
    local dialoggive = exports['qbr-input']:ShowInput({
        header = Lang:t('input.give_market'),
        submitText = Lang:t('input.validate'),
        inputs = {
            {text = Lang:t('input.give_market_champ'), name = "tocid", type = "text", isRequired = true, }
        },
    })

    if dialoggive ~= nil then
            TriggerServerEvent('kz-omarket:server:OMarketGiveBusiness', currentOMarket, dialoggive.tocid)
    end
end)


RegisterNetEvent("kz-omarket:client:OMarketName", function()

    local ChangeName = exports['qbr-input']:ShowInput({
        header = Lang:t('input.name'),
        submitText = Lang:t('input.validate'),
        inputs = {
            {text = Lang:t('input.name_champ'), name = "name", type = "text", isRequired = true, }
        },
    })

    if ChangeName ~= nil then 
        TriggerServerEvent('kz-omarket:server:OMarketName', currentOMarket, ChangeName.name)
    end
end)


RegisterNetEvent("kz-omarket:client:OMarketWithdraw", function(checkmoney)
    local money = checkmoney.money

    local Withdraw = exports['qbr-input']:ShowInput({
        header = Lang:t('input.withdraw').." : (Max : $"..money..")",
        submitText = Lang:t('input.validate'),
        inputs = {
            {text = Lang:t('input.withdraw_champ'), name = "qt", type = "number", isRequired = true, }
        },
    })

    if Withdraw ~= nil then 
        TriggerServerEvent('kz-omarket:server:OMarketWithdraw', currentOMarket, Withdraw.qt)
    end
end)


RegisterNetEvent("kz-omarket:client:OMarketInvReFillInput", function(data)
    local name = data
    local label = data.label
    local amount = data.amount

    local Refill = exports['qbr-input']:ShowInput({
        header = Lang:t('input.refill').." : "..label,
        submitText = Lang:t('input.validate'),
        inputs = {
            {text = Lang:t('input.qt'), name = "qt", type = "number", isRequired = true, },
            {text = Lang:t('input.refill_price'), name = "qtp", type = "number", isRequired = true, },
        },
    })

    if Refill ~= nil then 
        TriggerServerEvent('kz-omarket:server:OMarketInvReFill', currentOMarket, name, Refill.qt, Refill.qtp)
    end
end)


RegisterNetEvent("kz-omarket:client:OMarketInvInput", function(data)
    local name = data.items
    local prix = data.price
    local stock = data.stock

    local howmany = exports['qbr-input']:ShowInput({
        header = Lang:t('input.howmany_buy').." ("..sharedItems[name].label.." | $"..prix.."/u | S:"..stock..")",
        submitText = Lang:t('input.validate'),
        inputs = {
            {text = Lang:t('input.qt'), name = "qt", type = "number", isRequired = true, }
        },
    })

    if howmany ~= nil then 
        TriggerServerEvent('kz-omarket:server:OMarketPurchaseItem', currentOMarket, name, howmany.qt)
    end
end)


-------------------------------------------------------------------------------------------
-- Event
-------------------------------------------------------------------------------------------


RegisterNetEvent("kz-omarket:client:OMarketBuyEtal")
AddEventHandler("kz-omarket:client:OMarketBuyEtal", function()
    --print(currentOMarket)
    --print(price)
    TriggerServerEvent('kz-omarket:server:OMarketBuyEtal', currentOMarket, price)
end)


RegisterNetEvent("Stores:ReturnStoreItems")
AddEventHandler("Stores:ReturnStoreItems", function(data, data2)
    store_inventory = data
    Wait(100)
    TriggerEvent('kz-omarket:client:OMarketInv', store_inventory, data2)
end)





-------------------------------------------------------------------------------------------
-- NPC
-------------------------------------------------------------------------------------------


function SET_PED_RELATIONSHIP_GROUP_HASH ( iVar0, iParam0 )
    return Citizen.InvokeNative( 0xC80A74AC829DDD92, iVar0, _GET_DEFAULT_RELATIONSHIP_GROUP_HASH( iParam0 ) )
end


function _GET_DEFAULT_RELATIONSHIP_GROUP_HASH ( iParam0 )
    return Citizen.InvokeNative( 0x3CC4A718C258BDD0 , iParam0 );
end


function modelrequest( model )
    Citizen.CreateThread(function()
        RequestModel( model )
    end)
end


function RandomPed ()
    return Config.Model[math.random(1, #Config.Model)]
end

local peds = {}
Citizen.CreateThread(function()
    for z, x in pairs(Config.Market) do
        peds[z] = _CreatePed(Config.Market[z].npc, Config.Market[z].heading)
        --print(peds)
    end
end)

function _CreatePed(coords, heading)
    local Ped = RandomPed()
    while not HasModelLoaded( GetHashKey(Ped) ) do
        Wait(500)
        modelrequest( GetHashKey(Ped) )
    end

    local npc = CreatePed(GetHashKey(Ped), coords, heading, false, false, 0, 0)
    Citizen.InvokeNative(0x283978A15512B2FE, npc, true)
    ClearPedTasks(npc)
    RemoveAllPedWeapons(npc)
    SET_PED_RELATIONSHIP_GROUP_HASH(npc, GetHashKey(Ped))
    SetEntityCanBeDamagedByRelationshipGroup(npc, false, `PLAYER`)
    SetEntityAsMissionEntity(npc, true, true)
    SetModelAsNoLongerNeeded(GetHashKey(Ped))
    SetBlockingOfNonTemporaryEvents(npc,true)
    ClearPedTasksImmediately(npc)
    FreezeEntityPosition(npc, false)
    Wait(1000)
    FreezeEntityPosition(npc, true)
    SetEntityInvincible(npc, true)
    TaskStandStill(npc, -1)
    return npc
end


-------------------------------------------------------------------------------------------
-- ROBBERY
-------------------------------------------------------------------------------------------


RegisterNetEvent("kz-omarket:client:OMarketRob", function()
    local me = PlayerPedId()
    local isArmed = Citizen.InvokeNative(0xCB690F680A3EA971, me, 4)  --isPedArmed
    if isArmed then
        exports['qbr-core']:TriggerCallback('kz-omarket:server:OMarketS', function(result)
            if result[1].robbery == 0 then
                for i, x in pairs(peds) do
                    if HasEntityClearLosToEntityInFront(me, peds[i], 19) and not IsPedDeadOrDying(peds[i]) and GetDistanceBetweenCoords(GetEntityCoords(me), GetEntityCoords(peds[i]), true) <= 4.0 then
                        --print("Ok")
                        local pedcoord = GetEntityCoords(peds[i])
                        local pedheading = GetEntityHeading(peds[i])
                        local randomNumber = math.random(1,10)
                        --print(randomNumber)
                        Wait(100)
                        if randomNumber <= Config.ChanceFail then
                            GiveWeaponToPed_2(peds[i], 0x5B78B8DD, 90, true, true, GetWeapontypeGroup(0x5B78B8DD), true, 0.5, 1.0, 0, true, 0, 0)
                            SetCurrentPedWeapon(peds[i], 0x5B78B8DD, true)
                            Wait(100)
                            SetEntityInvincible(peds[i], false)
                            FreezeEntityPosition(peds[i], false)
                            SetEntityCanBeDamagedByRelationshipGroup(peds[i], true, `PLAYER`)
                            SetBlockingOfNonTemporaryEvents(peds[i],false)
                            TaskCombatPed(peds[i], PlayerPedId(), 0, 16)
                            Wait(100)
                            exports['qbr-core']:Notify(9, Lang:t('rob.fail'), 2000, 0, 'mp_lobby_textures', 'cross', 'COLOR_WHITE')
                            Wait(20000)
                            DeletePed(peds[i])
                            Wait(10000)
                            newpeds = _CreatePed(pedcoord, pedheading)
                            table.insert(peds, newpeds)
                        else
                            RequestAnimDict("script_proc@robberies@homestead@lonnies_shack@deception")
                            while not HasAnimDictLoaded("script_proc@robberies@homestead@lonnies_shack@deception") do
                                Citizen.Wait(100)
                            end
                            TaskPlayAnim(peds[i], "script_proc@robberies@homestead@lonnies_shack@deception", "hands_up_loop", 2.0, -2.0, -1, 67109393, 0.0, false, 1245184, false, "UpperbodyFixup_filter", false)

                            exports['qbr-core']:Progressbar("robbery", Lang:t('rob.good'), Config.RobTime, false, true, {
                                disableMovement = true,
                                disableCarMovement = false,
                                disableMouse = false,
                                disableCombat = true,
                                }, {}, {}, {}, function() -- Done
                            end)
                            Wait(Config.RobTime)
                            ClearPedTasks(peds[i])
                            TriggerServerEvent("kz-omarket:server:OMarketRob", currentOMarket)
                        end
                    end
                end
            else
                exports['qbr-core']:Notify(9, Lang:t('rob.already'), 2000, 0, 'mp_lobby_textures', 'cross', 'COLOR_WHITE')
            end
        end, currentOMarket)
    else
        exports['qbr-core']:Notify(9, Lang:t('rob.need_gun'), 2000, 0, 'mp_lobby_textures', 'cross', 'COLOR_WHITE')
    end
end)

-------------------------------------------------------------------------------------------
-- Blips
-------------------------------------------------------------------------------------------


Citizen.CreateThread(function()
	for z, x in pairs(Config.Market) do
        local blip = N_0x554d9d53f696d002(1664425300, Config.Market[z].coords)
        SetBlipSprite(blip, 1321928545, 1)
		SetBlipScale(blip, 0.025)
		Citizen.InvokeNative(0x9CB1A1623062F402, blip, Lang:t('other.blips'))
    end  
end)


-------------------------------------------------------------------------------------------
-- Prompt
-------------------------------------------------------------------------------------------


CreateThread(function()
    for k, v in pairs(Config.Market) do
        exports['qbr-core']:createPrompt(Config.Market[k], Config.Market[k].coords, 0xF3830D8E, Lang:t('other.prompt'), {
            type = 'client',
            event = 'kz-omarket:client:OMarketMenuPrompt'
        })
	end
end)

RegisterNetEvent('kz-omarket:client:OMarketMenuPrompt', function()
    for k, v in pairs(Config.Market) do
        local PutOutDist = #(GetEntityCoords(PlayerPedId()) - Config.Market[k].coords)
        if PutOutDist <= 4 then
            if not IsPedInAnyVehicle(PlayerPedId()) then
                currentOMarket = k
                TriggerEvent('kz-omarket:client:OMarketMenu')
            end
        end
    end
end)


-------------------------------------------------------------------------------------------
-- Debug
-------------------------------------------------------------------------------------------
--[[
RegisterNetEvent("kz-omarket:server:OMarketDbInv")
AddEventHandler("kz-omarket:server:OMarketDbInv", function()
    exports['qbr-core']:GetPlayerData(function(PlayerData)
        for k, v in pairs(PlayerData.items) do 
            if PlayerData.items[k] ~= nil and PlayerData.items[k].type == "item" then 
                print(PlayerData.items[k].name.." - "..PlayerData.items[k].amount)
            end
        end
    end)
end)

RegisterCommand('debug_inv', function()
    TriggerEvent("kz-omarket:server:OMarketDbInv")
end)

RegisterCommand('debug_input', function()
    TriggerEvent("kz-omarket:client:OMarketName")
end)
]]--
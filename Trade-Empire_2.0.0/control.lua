require "util"

function round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end


function comma_value(amount)
  local formatted = amount
  while true do  
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
    if (k==0) then
      break
    end
  end
  return formatted
end


function te_startup_goods()		
	-- This is a table containing all the basic prices of Trade Goods.
		--If saturation if on in parameters
		if settings.global["te_saturation"].value == true then
			storage.trade_goods = {
				["power-armor"] = 50000,
				["power-armor-mk2"] = 200000,
				["Mk1_kit"] = 55000,
				["Mk2_kit"] = 500000,
				["Nuclear_battery"] = 50000,
			}	
		else 
		--Special prices if saturation is off - penalize items, especially with big stacks
			storage.trade_goods = {
				["power-armor"] = 40000,
				["power-armor-mk2"] = 160000,
				["Mk1_kit"] = 32500,
				["Mk2_kit"] = 400000,
				["Nuclear_battery"] = 30000,
			}		
		end
end

script.on_init(function()
	local settings_irate = settings.global["te_interest_rate"].value
	--storage.irate = settings_irate

	if storage.AutoBuy_tokens == nil then
		storage.AutoBuy_tokens = false
	end
	
	if storage.balance == nil then
		local days_passed = round (game.tick/25000,0)
		if days_passed > 365 then
			days_passed = 365
		end
		
		local settings_balance = settings.startup["te_initial_debt"].value
		storage.balance = -1 * math.max(settings_balance,settings_balance * settings_irate^days_passed)
	end
	
	prbalance = storage.balance
	game.print({'TE.TE_Initiated', comma_value(round(storage.balance,2)), settings_irate}, {r=0.5, g=0.5, b=1})
	game.print({'TE.Days_since_start', round(game.tick/25000,0)}, {r=0.5, g=0.5, b=1})

	--i_gui()
	u_gui(true)
	te_startup_goods()
	remote.call("silo_script", "set_show_launched_without_satellite", false)
end)


script.on_event({defines.events.on_player_created},
	function ()
	local settings_irate = settings.global["te_interest_rate"].value
	game.print({'TE.TE_Initiated', comma_value(round(storage.balance,2)), settings_irate}, {r=0.5, g=0.5, b=1})
	--game.print("Trade Empire mod inititated. " .. " Starting debt: " .. comma_value(round(storage.balance,2)) .. ", Interest rate: " .. settings_irate, {r=0.5, g=0.5, b=1})
	--game.print("Days since map start - used for debt recalculation if mod is loaded into existing map: " .. round(game.tick/25000,0), {r=0.5, g=0.5, b=1})
	u_gui(true)
	end
)


script.on_load (function()
	remote.call("silo_script", "set_show_launched_without_satellite", false)
end)


script.on_configuration_changed (function()
	--migration of debt to balance
	if storage.debt ~= nil and storage.balance == nil then
		storage.balance = -1 * storage.debt
		storage.debt = nil
		for _, player in pairs(game.connected_players) do
			player.gui.top.debt.destroy()
		end
		game.print ("Balance migrated")
	end

	for _, player in pairs(game.connected_players) do	
		if player.gui.top.balance then
			player.gui.top.balance.destroy()
		end
		if player.gui.top.TEflow then
			player.gui.top.TEflow.destroy()
		end
	end
	
	if storage.AutoBuy_tokens == nil then
		storage.AutoBuy_tokens = false
	end
	
	storage.irate = nil
	te_startup_goods()
	u_gui (true)
end)


function u_gui(supress)
	for _, player in pairs(game.connected_players) do
		if player.valid then
			local topGui = player.gui.top
			
			if not topGui.TEflow then
				topGui.add{
				type = "flow",
				name = "TEflow",
				direction = "horizontal",
				}
				
				topGui.TEflow.style.top_padding = 4
				
				if not topGui.TEflow.TEshop then
					topGui.TEflow.add({type="sprite-button", name="TEshop", sprite="teshop_button_sprite", style="teshop_main_button"})
				end
			
				if not topGui.TEflow.TEprices then
					topGui.TEflow.add({type="sprite-button", name="TEprices", sprite="teprices_button_sprite", style="teshop_main_button"})
				end

				if not topGui.TEflow.TEbalance then
					topGui.TEflow.add({type="label", name="TEbalance", caption="Your balance"})
				end	
			end
			
			storage.balance = round (storage.balance, 2)
			prbalance = comma_value (storage.balance)
			topGui.TEflow.TEbalance.caption = {'gui.l', prbalance .. " CR"}
			
			
			if player.gui.left.TE_Prices ~= nil then
				--game.print (player.gui.left.TE_Prices.valid)
				player.gui.left.TE_Prices.destroy()
				TE_Open_Prices()
			end
			
			if not supress then
				player.print ({'TE.new_balance', prbalance})
		  	end
			
			--[[if topGui.TEshop and topGui.TEshop.valid then
				topGui.TEshop.destroy()
			end]]
		end
	end
end


function TE_Open_Shop()
	for _, player in pairs(game.connected_players) do
		if player.valid then
			local PrGui = player.gui.center
			if PrGui.TE_Shop then
				PrGui.TE_Shop.destroy()		
			else	
				if not PrGui.TE_Shop then		
					
					local st = "bold_label"
					
					PrGui.add{
					type = "flow",
					name = "TE_Shop",
					direction="vertical",
					}
					
					PrGui.TE_Shop.add{
					type = "frame",
					name = "Header",
					direction="horizontal",
					caption={'TE.shop_caption'}
					}	
						PrGui.TE_Shop.Header.add{
						type = "flow",
						name = "Flow_H",
						direction="horizontal",
						}
						PrGui.TE_Shop.Header.Flow_H.style.vertical_align = "center"
						PrGui.TE_Shop.Header.Flow_H.style.align = "left"	
						PrGui.TE_Shop.Header.Flow_H.style.minimal_width = 600	
							
						PrGui.TE_Shop.Header.Flow_H.add{
						type = "label",
						name = "header_descr",
						caption="Here you can purchase items or services, if you have positive balance (i.e. you paid the loan in full).",
						}
--Item 1					
					PrGui.TE_Shop.add{
					type = "flow",
					name = "Line_1",
					direction="horizontal",
					}	
						PrGui.TE_Shop.Line_1.add{
						type = "frame",
						name = "Item_1",
						direction="vertical",
						caption="100,000k credits token",--{'TE.shop_caption'}
						}
							
								PrGui.TE_Shop.Line_1.Item_1.add{
								type = "label",
								name = "Item_1_Price",
								caption="Price: 100,000 CR",
								style=st,
								}
							
							PrGui.TE_Shop.Line_1.Item_1.add{
							type = "flow",
							name = "Flow_1",
							direction="horizontal",
							}
							PrGui.TE_Shop.Line_1.Item_1.Flow_1.style.vertical_align = "center"
							PrGui.TE_Shop.Line_1.Item_1.Flow_1.style.align = "left"	
							PrGui.TE_Shop.Line_1.Item_1.Flow_1.style.minimal_width = 600	
							
								--[[PrGui.TE_Shop.Line_1.Item_1.Flow_1.add{
								type = "label",
								name = "Item_1_Effect",
								caption="100,000k credits token",
								style=st,
								}]]
								PrGui.TE_Shop.Line_1.Item_1.Flow_1.add{
								type = "button",
								name = "Item_1_Buy1",
								caption="Buy x 1",
								}
								PrGui.TE_Shop.Line_1.Item_1.Flow_1.add{
								type = "button",
								name = "Item_1_Buy10",
								caption="Buy x 10",
								}								
								PrGui.TE_Shop.Line_1.Item_1.Flow_1.add{
								type = "checkbox",
								name = "Item_1_AutoBuy",
								caption="Autobuy this item",
								state=storage.AutoBuy_tokens,
								tooltip="Will automatically buy this item, whenever you have enough money.",
								}
															
							PrGui.TE_Shop.Line_1.Item_1.add{
							type = "flow",
							name = "Flow_2",
							direction="vertical",
							}	
							PrGui.TE_Shop.Line_1.Item_1.Flow_2.style.vertical_align = "center"
							PrGui.TE_Shop.Line_1.Item_1.Flow_2.style.align = "left"	
							PrGui.TE_Shop.Line_1.Item_1.Flow_2.style.minimal_width = 600	
							
								PrGui.TE_Shop.Line_1.Item_1.Flow_2.add{
								type = "label",
								name = "Item_1_Descr",
								caption="You can can use this in any assembly machine to order items from nearest Space Trade Platform.",
								}
								PrGui.TE_Shop.Line_1.Item_1.Flow_2.add{
								type = "label",
								name = "Item_1_Descr_2",
								caption="Will be delivered to your inventory.",
								}
--Item 2								
					PrGui.TE_Shop.add{
					type = "flow",
					name = "Line_2",
					direction="horizontal",
					}	
						PrGui.TE_Shop.Line_2.add{
						type = "frame",
						name = "Item_1",
						direction="vertical",
						caption="Orbital Pest control",--{'TE.shop_caption'}
						}
							PrGui.TE_Shop.Line_2.Item_1.add{
							type = "label",
							name = "Item_1_Price",
							caption="Price: 5,000,000 CR",
							style=st,
							}
								
							PrGui.TE_Shop.Line_2.Item_1.add{
							type = "flow",
							name = "Flow_1",
							direction="horizontal",
							}
							PrGui.TE_Shop.Line_2.Item_1.Flow_1.style.vertical_align = "center"
							PrGui.TE_Shop.Line_2.Item_1.Flow_1.style.align = "left"	
							PrGui.TE_Shop.Line_2.Item_1.Flow_1.style.minimal_width = 600	

								--[[PrGui.TE_Shop.Line_2.Item_1.Flow_1.add{
								type = "label",
								name = "Item_1_Effect",
								caption="Orbital Pest control",
								style=st,
								}]]
								PrGui.TE_Shop.Line_2.Item_1.Flow_1.add{
								type = "button",
								name = "Item_2_Buy1",
								caption="Buy x 1",
								}
								PrGui.TE_Shop.Line_2.Item_1.Flow_1.add{
								type = "button",
								name = "Item_2_Buy10",
								caption="Buy x 10",
								}								
							PrGui.TE_Shop.Line_2.Item_1.add{
							type = "flow",
							name = "Flow_2",
							direction="vertical",
							}	
							PrGui.TE_Shop.Line_2.Item_1.Flow_2.style.vertical_align = "center"
							PrGui.TE_Shop.Line_2.Item_1.Flow_2.style.align = "left"	
							PrGui.TE_Shop.Line_2.Item_1.Flow_2.style.minimal_width = 600	
							
								PrGui.TE_Shop.Line_2.Item_1.Flow_2.add{
								type = "label",
								name = "Item_1_Descr",
								caption="Pest Control company sends an automatic bot to your planet to spray bitters with poison.",
								}
								
								PrGui.TE_Shop.Line_2.Item_1.Flow_2.add{
								type = "label",
								name = "Item_1_Descr_2",
								caption="It affects only larva, immediately reducing bitter evolution by 5%.",
								}
				PrGui.TE_Shop.add{
				type = "button",
				name = "Shop_close_button",
				caption={'TE.close_button'}
				}			
				end
			end
		end
	end
end

function TE_Open_Prices()
	for _, player in pairs(game.connected_players) do
		if player.valid then
			local PrGui = player.gui.left
			
			if PrGui.TE_Prices then
				PrGui.TE_Prices.destroy()		
			else
				if not PrGui.TE_Prices then		
					PrGui.add{
					type = "flow",
					name = "TE_Prices",
					direction="vertical",
					}
					
					PrGui.TE_Prices.add{
					type = "frame",
					name = "MainFrame",
					direction="horizontal",
					caption={'TE.trade_goods'}
					}
					
					PrGui.TE_Prices.MainFrame.add{
					type = "table",
					name = "MainTable",
					column_count=6,
					}	
					PrGui.TE_Prices.MainFrame.MainTable.style.cell_spacing = 4
					PrGui.TE_Prices.MainFrame.MainTable.style.column_alignments[1] = "left"
					PrGui.TE_Prices.MainFrame.MainTable.style.column_alignments[2] = "center"
					PrGui.TE_Prices.MainFrame.MainTable.style.column_alignments[3] = "center"					
					PrGui.TE_Prices.MainFrame.MainTable.style.column_alignments[4] = "center"					
					PrGui.TE_Prices.MainFrame.MainTable.style.column_alignments[5] = "center"					
					PrGui.TE_Prices.MainFrame.MainTable.style.column_alignments[6] = "center"					

						local st = "bold_label"
					
						PrGui.TE_Prices.MainFrame.MainTable.add{
						type = "label",
						name = "header_1",
						caption=" ",
						style=st,
						}
						
						PrGui.TE_Prices.MainFrame.MainTable.add{
						type = "label",
						name = "header_2",
						caption={'TE.pricetable_price'},
						style=st,
						tooltip={'TE.pricetable_price_tt'}
						}

						PrGui.TE_Prices.MainFrame.MainTable.add{
						type = "label",
						name = "header_3",
						caption={'TE.pricetable_stack'},
						style=st,
						tooltip={'TE.pricetable_stack_tt'}
						}		
											
						PrGui.TE_Prices.MainFrame.MainTable.add{
						type = "label",
						name = "header_4",
						caption={'TE.pricetable_marketbonus'},
						style=st,
						tooltip={'TE.pricetable_marketbonus_tt'}
						}								

						PrGui.TE_Prices.MainFrame.MainTable.add{
						type = "label",
						name = "header_5",
						caption={'TE.pricetable_saturation'},
						style=st,
						tooltip={'TE.pricetable_saturation_tt'}
						}
						
						PrGui.TE_Prices.MainFrame.MainTable.add{
						type = "label",
						name = "header_6",
						caption={'TE.pricetable_finalprice'},
						style=st,
						tooltip={'TE.pricetable_finalprice_tt'}
						}	
						
					for trade_good, price in pairs(storage.trade_goods) do
						
						PrGui.TE_Prices.MainFrame.MainTable.add{
						type = "label",
						name = trade_good .. "_name",
						caption=game.item_prototypes[trade_good].localised_name,
						style="bold_label",
						}
						
						PrGui.TE_Prices.MainFrame.MainTable.add{
						type = "label",
						name = trade_good .. "_basicprice",
						caption= comma_value(price),
						}

						local stack=game.item_prototypes[trade_good].stack_size or 0
						PrGui.TE_Prices.MainFrame.MainTable.add{
						type = "label",
						name = trade_good .. "_stack",
						caption=stack,
						}		
											
						local mb = player.force.items_launched["Marketing_beacon"] or 0 
						PrGui.TE_Prices.MainFrame.MainTable.add{
						type = "label",
						name = trade_good .. "_marketing",
						caption="+" .. mb .. "%",
						}								
						
						local saturation=calculate_saturation(trade_good,0,player) or 0
						saturation_printed = (saturation-1)*100
						
						PrGui.TE_Prices.MainFrame.MainTable.add{
						type = "label",
						name = trade_good .. "_saturation",
						caption=saturation_printed.."%"
						}
						
						local final_price = storage.trade_goods[trade_good] * (1 + (mb/100)) * saturation * stack
						PrGui.TE_Prices.MainFrame.MainTable.add{
						type = "label",
						name = trade_good .. "_finalprice",
						caption=comma_value(round(final_price)),
						}							
							
						--prices_table_fill(trade_good)						
					end				

					PrGui.TE_Prices.add{
					type = "button",
					name = "Prices_close_button",
					caption={'TE.close_button'}
					}
					
					
				end
			end
		end
	end
end

function balance_check(cost)
	if storage.balance - cost >= 0 then
		return true
		else 
		game.print({'TE.Not_enough_money'})
		return false
	end
end

function Buy_coin(i_count,player)
local i_price = 100000
	if i_count ~= "Auto" then
		f_price = i_price * i_count or 0
		local count = i_count or 0
		local result=balance_check(f_price)
		if result then	
			
			while player.can_insert{name="Token"} == true and count > 0 do
				player.insert{name="Token",count=1}
				count = count-1
			end	
			
				local final_count = i_count-count
				--game.print(final_count)
				storage.balance=storage.balance-(final_count * i_price)
				game.print({'TE.Tokens_purchased',final_count})	
			if final_count ~= i_count then 
				game.print({'TE.Inv_not_enough_place'})
			end
			
		end
		u_gui(true)
	else
		local possible_count = math.floor(storage.balance/i_price)
		--game.print (possible_count)
		if storage.AutoBuy_tokens then
			if possible_count > 0 then
				game.print({'TE.Tokens_autopurchased'})
				Buy_coin(possible_count,player)
			end
		end	
	end
end

function Buy_BEvo(count,player)
local i_price = 5000000
local f_price = i_price * count
local result=balance_check(f_price)
--game.print(result)
	if result then
		storage.balance=storage.balance-f_price
		--game.forces["enemy"].evolution_factor=0.04
		game.forces["enemy"].evolution_factor=game.forces["enemy"].evolution_factor-(0.05 * count)
		game.print({'TE.Evo_purchased', 5*count})
		u_gui(true)
	end
end




script.on_event(defines.events.on_gui_click, function(event)
    -- prevent raising on_click twice for the same element
    if last_checked ~= nil and last_checked == event.element.name then
        return
    end
    last_clicked = event.element.name
	--game.print (last_clicked)
	if last_clicked == "TEshop" then

		TE_Open_Shop()
	elseif last_clicked == "TEprices" then
		TE_Open_Prices()
		
	elseif last_clicked == "Prices_close_button" then
		local player = game.players[event.player_index]
		player.gui.left.TE_Prices.destroy()
	elseif last_clicked == "Shop_close_button" then
		local player = game.players[event.player_index]
		player.gui.center.TE_Shop.destroy()
	elseif last_clicked == "Item_1_Buy1" then
		local player = game.players[event.player_index]
		Buy_coin(1,player)
	elseif last_clicked == "Item_1_Buy10" then
		local player = game.players[event.player_index]
		Buy_coin(10,player)

	elseif last_clicked == "Item_1_AutoBuy" then
		local player = game.players[event.player_index]	
		if player.gui.center.TE_Shop.Line_1.Item_1.Flow_1.Item_1_AutoBuy.state then			
			storage.AutoBuy_tokens = true
		end
		if not player.gui.center.TE_Shop.Line_1.Item_1.Flow_1.Item_1_AutoBuy.state then			
			storage.AutoBuy_tokens = false
		end		
		if storage.AutoBuy_tokens then
			Buy_coin("Auto",player)
		end
	elseif last_clicked == "Item_2_Buy1" then
		local player = game.players[event.player_index]
		Buy_BEvo(1,player)

	elseif last_clicked == "Item_2_Buy10" then
		local player = game.players[event.player_index]
		Buy_BEvo(10,player)

	end
end)


script.on_event({defines.events.on_tick},
	function (d)
		if d.tick ~= 0 then
		if d.tick % 25000 == 0 then --Interest is accrued daily.
		--if d.tick % 600 == 0 then --Interest is accrued every 10 sec. 
			for index,player in pairs(game.connected_players) do  --loop through all online players on the server
					
					local irate = settings.global["te_interest_rate"].value				
						if irate == nil then
							irate = 1.01
						end
					
					if storage.balance <= 0 then
						storage.balance = storage.balance * irate
						player.print ({'TE.INT_debt', irate})
					else
						local irate_positive = (irate-1)/10 + 1 
						storage.balance = storage.balance * irate_positive
						player.print ({'TE.INT_positive', irate_positive})
					end	
				Buy_coin("Auto",player)
				u_gui()
			end
		end
		end
	end
)


function check_if_tracked(item_name)
	local result = false
	local count = 0
	local list = remote.call("silo_script", "get_tracked_items")
	for k, name in pairs (list) do
		if name == item_name then 
			count = count + 1
		end
	end	
		if count > 0 then 
			result = true
		end
	return result
end
		

function calculate_saturation (trade_good, count_launched, player)
local saturation_on = settings.global["te_saturation"].value
	if saturation_on == true then
		local days_passed = round (game.tick/25000,0)
		local items_launched = (player.force.items_launched[trade_good] or 0) - (count_launched or 0)
		--game.print ("Debug - Items launched " .. items_launched)
		local saturation = (items_launched - round(days_passed/14,0))
			if saturation < 0 then saturation = 0 end
		--game.print ("Debug - Saturation " .. saturation)
		local final_saturation = 0.99^(saturation)
			if final_saturation <= 0 then final_saturation = 1 end
		--game.print ("Debug - Final_saturation " .. final_saturation)
		return round(final_saturation, 2)
	else
	return 1
	end
end
		
script.on_event({defines.events.on_rocket_launched},
	function (r)	
		te_startup_goods()
		local inventory = r.rocket.get_inventory(1).get_contents()
		local total_earned = 0
		local total_items = 0		
		local maketing_bonus = 0 
		
		for index,player in pairs(game.connected_players) do
		for i,c in pairs(inventory) do	
				maketing_bonus = player.force.items_launched["Marketing_beacon"] or 0
				
				if i == "Marketing_beacon" then	
					game.print ({'TE.marketing_beacon_launched', player.force.items_launched[i]})
					u_gui(true)
				end
		
				if storage.trade_goods[i] ~= nil then
					local saturation = calculate_saturation(i,c,player)
					--game.print ("Debug - Local saturaion " .. saturation)
					total_earned = total_earned + storage.trade_goods[i] * c * (1 + (maketing_bonus/100)) * saturation
					
					if (1 + (maketing_bonus/100)) * saturation <= 0.5 then
						game.print ({'TE.warning_low_price'})
					end
					
					total_items = total_items + c
					local saturation_printed = (saturation-1)*100
					game.print ({'TE.item_launched', c, game.item_prototypes[i].localised_name, saturation_printed, player.force.items_launched[i]})
				else
					total_earned = 0
					total_items = 0
				end
	
				if check_if_tracked(i) == false then
					remote.call("silo_script", "add_tracked_item", i)
				end

		end
		end
			
		for index,player in pairs(game.connected_players) do
			local previous_balance = storage.balance
			storage.balance = storage.balance + total_earned
				if storage.balance >= 0 and previous_balance < 0 then
					if (#game.players <= 1) then
						game.show_message_dialog{text = {"TE.WIN"}}
					else
						force.print({"TE.WIN"})
					end
				end
				if total_earned ~= 0 then
					game.print ({'TE.Earned_per_rocket', comma_value(total_earned), total_items, maketing_bonus})
					Buy_coin("Auto",player)
					u_gui()	
				end				
		end

	end
)

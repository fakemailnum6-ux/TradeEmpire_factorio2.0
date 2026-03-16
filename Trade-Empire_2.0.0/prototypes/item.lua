local Mk2_kit = table.deepcopy(data.raw.item["barrel"])
local Mk2_for_icon = table.deepcopy(data.raw.armor["power-armor-mk2"])
Mk2_kit.name = "Mk2_kit"
Mk2_kit.icons= {
   {
      icon=Mk2_for_icon.icon,
      --tint={r=0.5,g=0.2,b=1.0,a=0.5}
	  tint={r=125,g=45,b=255,}
   },
   {
      icon = "__Trade-Empire__/graphics/Trade-goods/Coin.png",
	  icon_size = 128,
	  scale = 0.12,
	  shift = {-8.5,8.5}
   },
}
Mk2_kit.stack_size = 1
Mk2_kit.subgroup = "packed_trade_good"

local recipe_mk2 = table.deepcopy(data.raw.recipe["power-armor-mk2"])
recipe_mk2.enabled = true
recipe_mk2.name = "Mk2_kit"
recipe_mk2.ingredients = {{type="item", name="personal-laser-defense-equipment", amount=6},{type="item", name="exoskeleton-equipment", amount=3},{type="item", name="power-armor-mk2", amount=1},{type="item", name="energy-shield-mk2-equipment", amount=3},{type="item", name="battery-mk2-equipment", amount=4},{type="item", name="fission-reactor-equipment", amount=2}}
recipe_mk2.results = {{type="item", name="Mk2_kit", amount=1}}

data:extend{Mk2_kit,recipe_mk2}



local Mk1_kit = table.deepcopy(data.raw.item["barrel"])
local Mk1_for_icon = table.deepcopy(data.raw.armor["power-armor"])
Mk1_kit.name = "Mk1_kit"
Mk1_kit.icons= {
   {
      icon=Mk1_for_icon.icon,
      tint={r=125,g=45,b=235,}
   },
   {
      icon = "__Trade-Empire__/graphics/Trade-goods/Coin.png",
	  icon_size = 128,
	  scale = 0.12,
	  shift = {-8.5,8.5}
   },
}
Mk1_kit.stack_size = 10
Mk1_kit.subgroup = "packed_trade_good"

local recipe_mk1 = table.deepcopy(data.raw.recipe["power-armor"])
recipe_mk1.enabled = true
recipe_mk1.name = "Mk1_kit"
recipe_mk1.ingredients = {{type="item", name="power-armor", amount=1},{type="item", name="exoskeleton-equipment", amount=1},{type="item", name="energy-shield-equipment", amount=4},{type="item", name="battery-equipment", amount=5},{type="item", name="solar-panel-equipment", amount=15}}
recipe_mk1.results = {{type="item", name="Mk1_kit", amount=1}}

data:extend{Mk1_kit,recipe_mk1}

--Marketing beacon
local Marketing_beacon = table.deepcopy(data.raw.item["barrel"])
local Marketing_beacon_for_icon = table.deepcopy(data.raw.item["satellite"])
Marketing_beacon.name = "Marketing_beacon"
Marketing_beacon.icons= {
   {
      icon=Marketing_beacon_for_icon.icon,
      --tint={r=0.5,g=0.2,b=1.0,a=0.5}
	  tint={r=125,g=45,b=235,}
   },
   {
      icon = "__Trade-Empire__/graphics/Trade-goods/Coin.png",
	  icon_size = 128,
	  scale = 0.12,
	  shift = {-8.5,8.5}
   },
}
Marketing_beacon.stack_size = 1
Marketing_beacon.subgroup = "te_economy"

local recipe_Marketing_beacon = table.deepcopy(data.raw.recipe["satellite"])
recipe_Marketing_beacon.enabled = true
recipe_Marketing_beacon.name = "Marketing_beacon"
recipe_Marketing_beacon.ingredients = {{type="item", name="accumulator", amount=150},{type="item", name="processing-unit", amount=25},{type="item", name="radar", amount=50},{type="item", name="rocket-fuel", amount=25},{type="item", name="solar-panel", amount=150}}
recipe_Marketing_beacon.results = {{type="item", name="Marketing_beacon", amount=1}}

data:extend{Marketing_beacon,recipe_Marketing_beacon}

-- Nuclear battery
local Nuclear_battery = table.deepcopy(data.raw.item["barrel"])
--local Nuclear_battery_for_icon = table.deepcopy(data.raw.item["fission-reactor-equipment"])
Nuclear_battery.name = "Nuclear_battery"
Nuclear_battery.icons= {
	{
      icon = "__base__/graphics/icons/fission-reactor-equipment.png",
      --tint={r=0.3,g=0.1,b=1.0,a=0.5,
		  tint={r=125,g=45,b=235,}
		  --icon_size = 32,
	},
	{
      icon = "__Trade-Empire__/graphics/Trade-goods/Coin.png",
	  icon_size = 128,
	  scale = 0.12,
	  shift = {-8.5,8.5}
	},
}
Nuclear_battery.stack_size = 20
Nuclear_battery.subgroup = "packed_trade_good"

local recipe_Nuclear_battery = table.deepcopy(data.raw.recipe["satellite"])
recipe_Nuclear_battery.enabled = true
recipe_Nuclear_battery.category="crafting-with-fluid"
recipe_Nuclear_battery.name = "Nuclear_battery"
recipe_Nuclear_battery.energy_required = 120
recipe_Nuclear_battery.ingredients = {
    {
      amount = 100,
      name = "uranium-fuel-cell",
      type = "item"
    },
    {
      amount = 100,
      name = "low-density-structure",
      type = "item"
    },
	{
      amount = 500,
      name = "coal",
      type = "item"
    },
    {
      amount = 1000,
      name = "crude-oil",
      type = "fluid"
    }
}
recipe_Nuclear_battery.results = {{type="item", name="Nuclear_battery", amount=1}}
data:extend{Nuclear_battery,recipe_Nuclear_battery}


--100,000k Token
local Token = table.deepcopy(data.raw.item["barrel"])
Token.name = "Token"
Token.icons= {
   {
      icon = "__Trade-Empire__/graphics/Trade-goods/Coin.png",
      --tint={r=0.3,g=0.1,b=1.0,a=0.5,
	  icon_size = 128,
   },
}
Token.stack_size = 1000
Token.subgroup = "te_orbit_good"

data:extend{Token}

--ex Mining module, now Prod Module 4
local Productivity_module_4 = table.deepcopy(data.raw.module["productivity-module-3"])
--local Mining_module_for_icon = table.deepcopy(data.raw.armor["power-armor-mk2"])
Productivity_module_4.name = "productivity-module-4"
Productivity_module_4.icons= {
   {
      icon = Productivity_module_4.icon,
      tint={r=125,g=45,b=235,
	  --icon_size = 32,
	  }
   },
   {
      icon = "__Trade-Empire__/graphics/Trade-goods/Coin.png",
	  icon_size = 128,
	  scale = 0.12,
	  shift = {-8.5,8.5}
   },
}
--[[effect = {
        consumption = 2.0,
          bonus = 0.8
        },
        pollution = 0.5,
          bonus = 0.1
        },
        productivity = 0.13,
          bonus = 0.1
        },
        speed = -0.05
          bonus = -0.15
        }
      }]]

	--Productivity_module_4.category = "productivity"

	Productivity_module_4.effect = { consumption = 2.0, pollution = 0.5, productivity = 0.13, speed = -0.05 }

Productivity_module_4.subgroup = "te_orbit_good"

local recipe_Productivity_module_4 = table.deepcopy(data.raw.recipe["productivity-module-3"])
recipe_Productivity_module_4.enabled = true
recipe_Productivity_module_4.name = "productivity-module-4"
--recipe_Productivity_module_4.energy_required = 60
recipe_Productivity_module_4.ingredients = {
    {
      amount = 5,
      name = "Token",
      type = "item",
    },

}
recipe_Productivity_module_4.results = {{type="item", name="productivity-module-4", amount=1}}
data:extend{Productivity_module_4,recipe_Productivity_module_4}

--Final Ship!
local MegaSpaceYacht= table.deepcopy(data.raw.item["barrel"])
MegaSpaceYacht.name = "MegaSpaceYacht"
MegaSpaceYacht.icons= {
   {
    icon= "__Trade-Empire__/graphics/Trade-goods/MegaSpaceYacht.png",
	icon_size = 357,
   },
   {
      icon = "__Trade-Empire__/graphics/Trade-goods/Coin.png",
	  icon_size = 128,
	  scale = 0.07,
	  shift = {-8.5,8.5}
   },
}
MegaSpaceYacht.stack_size = 1
MegaSpaceYacht.subgroup = "te_orbit_good"

local recipe_MegaSpaceYacht = table.deepcopy(data.raw.recipe["satellite"])
recipe_MegaSpaceYacht.enabled = true
recipe_MegaSpaceYacht.name = "MegaSpaceYacht"
recipe_MegaSpaceYacht.ingredients = {
    {
      amount = 1000,
      name = "Token",
      type = "item",
    },

}

recipe_MegaSpaceYacht.results = {{type="item", name="MegaSpaceYacht", amount=1}}

data:extend{MegaSpaceYacht,recipe_MegaSpaceYacht}
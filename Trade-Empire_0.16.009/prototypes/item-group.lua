data:extend({
    {
        type = "item-group",
        name = "trade-goods",
        order = "t",
        icon = "__Trade-Empire__/graphics/item-group/group.png",
        icon_size =128,
    },
	{
        type = "item-subgroup",
        name = "packed_trade_good",
        group = "trade-goods",
        order = "t"
    },
	{
        type = "item-subgroup",
        name = "te_economy",
        group = "trade-goods",
        order = "s"
    },
	{
        type = "item-subgroup",
        name = "te_orbit_good",
        group = "trade-goods",
        order = "v"
    },
	{
        type = "module-category",
        name = "mining_productivity",
    },
})

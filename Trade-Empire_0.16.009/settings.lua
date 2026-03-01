data:extend({
    {
        type = "int-setting",
		name = "te_initial_debt",
        setting_type = "startup",
        default_value = 1500000
    },
    {
        type = "double-setting",
        name = "te_interest_rate",
        setting_type = "runtime-global",
        default_value = 1.01
    },
	{
        type = "bool-setting",
        name = "te_saturation",
        setting_type = "runtime-global",
        default_value = true
    }
})
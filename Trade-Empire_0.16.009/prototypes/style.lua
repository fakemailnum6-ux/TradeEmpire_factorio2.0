data:extend({
  {
    type="sprite",
    name="teshop_button_sprite",
    filename = "__Trade-Empire__/graphics/GUI/shop.png",
    priority = "extra-high-no-scale",
    width = 128,
    height = 128,
  },
  {
    type="sprite",
    name="teprices_button_sprite",
    filename = "__Trade-Empire__/graphics/GUI/prices.png",
    priority = "extra-high-no-scale",
    width = 128,
    height = 128,
  },
})




data.raw["gui-style"].default["teshop_button_style"] =
  {
    type = "button_style",
    parent = "button",
    top_padding = 1,
    right_padding = 5,
    bottom_padding = 1,
    left_padding = 5,
    left_click_sound =
    {
      {
        filename = "__core__/sound/gui-click.ogg",
        volume = 1
      }
    }
  }

data.raw["gui-style"].default["teshop_sprite_button"] =
  {
    type = "button_style",
    parent = "teshop_button_style",
    width = 32,
    height = 32,
    top_padding = 0,
    right_padding = 0,
    bottom_padding = 0,
    left_padding = 0,
    left_click_sound =
    {
      {
        filename = "__core__/sound/gui-click.ogg",
        volume = 1
      }
    }
  }

data.raw["gui-style"].default["teshop_main_button"] =
  {
    type = "button_style",
    parent = "teshop_sprite_button",
    width = 33,
    height = 33,
  }

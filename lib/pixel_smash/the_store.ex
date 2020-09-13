defmodule PixelSmash.TheStore do
  def on_sale() do
    Enum.map(1..6, fn _ ->
      item = PixelSmash.Items.generate()
      sprite = PixelSmash.Sprites.to_sprite(item)
      %{item: item, sprite: sprite}
    end)
  end
end

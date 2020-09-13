defprotocol PixelSmash.Sprites.Spritifier do
  alias PixelSmash.Sprites.Sprite

  @spec to_sprite(data :: term()) :: Sprite.t()
  def to_sprite(data)
end

defimpl PixelSmash.Sprites.Spritifier, for: PixelSmash.Sprites.Sprite do
  def to_sprite(%PixelSmash.Sprites.Sprite{} = sprite) do
    sprite
  end
end

defimpl PixelSmash.Sprites.Spritifier, for: PixelSmash.Items.Item do
  def to_sprite(%PixelSmash.Items.Item{} = item) do
    color_cell = fn {coordinate, attribute} ->
      attribute =
        case attribute do
          :empty -> :transparent
          :no_operation -> :gray
          :vitality -> :dark_green
          :defense -> :dark_blue
          :strength -> :dark_red
          :casting -> :dark_purple
          :speed -> :dark_yellow
          :secret -> :dark_pink
        end

      {coordinate, attribute}
    end

    map =
      item.map
      |> Enum.map(color_cell)
      |> Enum.into(%{})

    # Map it into the Sprite struct
    sprite = %PixelSmash.Sprites.Sprite{
      x: item.x,
      y: item.y,
      map: map
    }

    cond do
      item.type in [:helmet, :hat, :crown] ->
        PixelSmash.Sprites.Sprite.position(sprite, {0, 0})

      item.type in [:googles, :eyepatch, :scouter, :unilens] ->
        PixelSmash.Sprites.Sprite.position(sprite, {0, 2})

      item.type in [:stick] ->
        PixelSmash.Sprites.Sprite.position(sprite, {0, 4})

      item.type in [:glove] ->
        PixelSmash.Sprites.Sprite.position(sprite, {0, 5})

      true ->
        sprite
    end
  end
end

defimpl PixelSmash.Sprites.Spritifier, for: PixelSmash.Gladiators.Gladiator do
  def to_sprite(%PixelSmash.Gladiators.Gladiator{} = gladiator) do
    color_cell = fn {coordinate, attribute} ->
      attribute =
        case attribute do
          :empty -> :transparent
          :no_operation -> :gray
          :vitality -> :green
          :defense -> :blue
          :strength -> :red
          :casting -> :purple
          :speed -> :yellow
          :secret -> :pink
        end

      {coordinate, attribute}
    end

    map =
      gladiator.data
      |> PixelSmash.Grids.to_map(10, 10)
      |> Enum.map(color_cell)
      |> Enum.into(%{})

    %PixelSmash.Sprites.Sprite{
      x: 10,
      y: 10,
      map: map
    }
  end
end

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
    map =
      Enum.map(item.map, fn {key, value} ->
        {key, PixelSmash.Attributes.to_color(value)}
      end)
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
        PixelSmash.Sprites.Sprite.position(sprite, {0, 3})

      item.type in [:stick] ->
        PixelSmash.Sprites.Sprite.position(sprite, {0, 5})

      item.type in [:glove] ->
        PixelSmash.Sprites.Sprite.position(sprite, {0, 7})

      true ->
        sprite
    end
  end
end

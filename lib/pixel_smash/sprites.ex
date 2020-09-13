defmodule PixelSmash.Sprites do
  alias PixelSmash.Sprites.{
    Pixel,
    Sprite,
    Spritifier
  }

  def equip(entity_a, entity_b) do
    entity_a = Spritifier.to_sprite(entity_a)
    entity_b = Spritifier.to_sprite(entity_b)

    Sprite.apply_mask(entity_a, entity_b)
  end

  def position(entity, at \\ {0, 0}) do
    entity
    |> Spritifier.to_sprite()
    |> Sprite.position(at)
  end

  def fusion(entity_a, entity_b) do
    entity_a = Spritifier.to_sprite(entity_a)
    entity_b = Spritifier.to_sprite(entity_b)

    # An attempt at bad xoring
    Sprite.apply_mask(entity_a, entity_b, fn {x, y}, v1, v2 ->
      cond do
        rem(y, 2) == 0 and rem(x, 2) == 0 ->
          v1

        rem(y, 2) == 0 and rem(x, 2) == 1 ->
          v2

        rem(y, 2) == 1 and rem(x, 2) == 0 ->
          v1

        rem(y, 2) == 1 and rem(x, 2) == 1 ->
          v2

        true ->
          Enum.random([v1, v2])
      end
    end)
  end

  def to_sprite(entity) do
    Spritifier.to_sprite(entity)
  end

  # TODO:
  # This specific method contains logic for gladiator not sprite
  defdelegate generate_sprite(size_x, size_y, generator_fn), to: Sprite, as: :new

  def new_sprite(pixels) do
    count = Sprite.default_size() * Sprite.default_size() - length(pixels)
    fitting_pixels = pixels ++ Pixel.background(count)
    Sprite.new(fitting_pixels)
  end

  defdelegate new_pixel, to: Pixel, as: :new
  defdelegate new_pixel(base_color, tint), to: Pixel, as: :new

  def background_pixel, do: 1 |> Pixel.background() |> List.first()
end

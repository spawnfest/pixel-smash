defmodule PixelSmash.Attributes do
  @perseverance [:stamina, :defense]
  @combat [:strength, :casting]
  @special [:speed, :secret]

  def all(), do: Enum.concat([@perseverance, @combat, @special])
  def perseverance(), do: Enum.random([:stamina, :defense])
  def combat(), do: Enum.random([:strength, :casting])
  def special(), do: Enum.random([:speed, :secret])
  def noop(), do: :no_operation

  def to_color(attribute) do
    case attribute do
      :empty -> :transparent
      :no_operation -> :gray
      :stamina -> :green
      :casting -> :blue
      :speed -> :yellow
      :strength -> :red
      :vitality -> :purple
      secret -> :pink
    end
  end
end

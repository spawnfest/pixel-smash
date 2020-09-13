defmodule PixelSmash.Attributes do
  @perseverance [:vitality, :defense]
  @combat [:strength, :casting]
  @special [:speed, :secret]

  def all(), do: Enum.concat([@perseverance, @combat, @special])
  def perseverance(), do: Enum.random([:vitality, :defense])
  def combat(), do: Enum.random([:strength, :casting])
  def special(), do: Enum.random([:speed, :secret])
  def noop(), do: :no_operation

  def to_color(attribute) do
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
  end
end

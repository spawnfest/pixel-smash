defmodule PixelSmash.Attributes do
  @perseverance [:vitality, :defense]
  @combat [:strength, :casting]
  @special [:speed, :secret]

  def all(), do: Enum.concat([@perseverance, @combat, @special])
  def perseverance(), do: Enum.random([:vitality, :defense])
  def combat(), do: Enum.random([:strength, :casting])
  def special(), do: Enum.random([:speed, :secret])
  def noop(), do: :no_operation
end

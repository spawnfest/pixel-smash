defmodule PixelSmash.Gladiators do
  @moduledoc """
  Gladiators context. Allows listing gladiators, and fetching them by ID.
  """

  alias PixelSmash.Gladiators.{
    ELO,
    Gladiator,
    Store,
    Supervisor
  }

  @store Store

  defdelegate child_spec(init_arg), to: Supervisor

  @spec list_gladiators(GenServer.name()) :: [Gladiator]
  def list_gladiators(store \\ @store) do
    Store.list_gladiators(store)
  end

  @spec list_gladiators_by_elo(atom(), GenServer.name()) :: [Gladiator]
  def list_gladiators_by_elo(sort_order \\ :desc, store \\ @store) do
    Store.list_gladiators_by_elo(store, sort_order)
  end

  @spec get_gladiator(GenServer.name(), String.t()) :: Gladiator | nil
  def get_gladiator(store \\ @store, id) do
    Store.get_gladiator(store, id)
  end

  @spec expected_battle_result({Gladiator.t(), Gladiator.t()}) :: {float(), float()}
  def expected_battle_result({%Gladiator{} = left, %Gladiator{} = right}) do
    left_chances =
      ELO.expected_result(left, right)
      |> Decimal.from_float()

    right_chances = Decimal.sub(1, left_chances)

    {left_chances, right_chances}
  end

  @spec register_battle_result(
          GenServer.name(),
          {Gladiator.t(), Gladiator.t()},
          :left | :draw | :right
        ) :: :ok
  def register_battle_result(store \\ @store, {%Gladiator{}, %Gladiator{}} = matchup, winner) do
    Store.register_battle_result(store, matchup, winner)
  end

  def generate_gladiator() do
    Gladiator.generate()
  end

  def equip(%Gladiator{} = gladiator, %PixelSmash.Items.Item{} = item, slot) do
    sprite = PixelSmash.Sprites.equip(gladiator, item)

    gladiator
    |> Map.put(:sprite, sprite)
    |> Map.put(slot, item)
  end
end

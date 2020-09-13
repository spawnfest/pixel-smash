defmodule PixelSmash.Gladiators do
  @moduledoc """
  Gladiators context. Allows listing gladiators, and fetching them by ID.
  """

  alias PixelSmash.Gladiators.{
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

  @spec list_gladiators_by_elo(GenServer.name()) :: [Gladiator]
  def list_gladiators_by_elo(store \\ @store) do
    Store.list_gladiators_by_elo(store)
  end

  @spec get_gladiator(GenServer.name(), String.t()) :: Gladiator | nil
  def get_gladiator(store \\ @store, id) do
    Store.get_gladiator(store, id)
  end

  @spec register_battle_result(
          GenServer.name(),
          {Gladiator.id(), Gladiator.id()},
          :left | :draw | :right
        ) :: :ok
  def register_battle_result(store \\ @store, {left, right} = matchup, winner)
      when is_binary(left) and is_binary(right) do
    Store.register_battle_result(store, matchup, winner)
  end
end

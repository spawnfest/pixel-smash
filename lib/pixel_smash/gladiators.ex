defmodule PixelSmash.Gladiators do
  @moduledoc """
  Gladiators context. Allows listing gladiators, and fetching them by ID.
  """

  alias PixelSmash.Gladiators.{
    Store,
    Supervisor
  }

  @store Store

  defdelegate child_spec(init_arg), to: Supervisor

  def list_gladiators(store \\ @store) do
    Store.list_gladiators(store)
  end

  def get_gladiator(store \\ @store, id) do
    Store.get_gladiator(store, id)
  end
end

defmodule PixelSmash.Gladiators do
  @moduledoc """
  Gladiators context. Generates and persists Gladiator into DB.

  ## Examples

      iex> alias PixelSmash.Gladiators
      ...> import Gladiators
      ...> gladiator = generate_gladiator()
      ...> {:ok, %{id: id}} = persist_gladiator(gladiator)
      ...> loaded_gladiator = get_gladiator!(id)
      ...> gladiator == loaded_gladiator
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

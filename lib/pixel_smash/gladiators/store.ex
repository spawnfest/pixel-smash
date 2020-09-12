defmodule PixelSmash.Gladiators.Store do
  use GenServer

  alias PixelSmash.Gladiators.Gladiator

  @max_gladiators 16

  def start_link(init_arg) do
    GenServer.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def list_gladiators(pid \\ __MODULE__) do
    GenServer.call(pid, :list_gladiators)
  end

  def get_gladiator(pid \\ __MODULE__, id) do
    GenServer.call(pid, {:get_gladiator, id})
  end

  def init(_init_arg) do
    {:ok, %{}, {:continue, :seed}}
  end

  def handle_continue(:seed, store) do
    gladiators =
      Enum.map(1..@max_gladiators, fn _ ->
        Gladiator.generate()
      end)

    store =
      Enum.reduce(gladiators, store, fn gladiator, acc ->
        Map.put(acc, gladiator.id, gladiator)
      end)

    {:noreply, store}
  end

  def handle_call(:list_gladiators, _from, store) do
    gladiators = Map.values(store)

    {:reply, gladiators, store}
  end

  def handle_call({:get_gladiator, id}, _from, store) do
    gladiator = Map.get(store, id)

    {:reply, gladiator, store}
  end
end

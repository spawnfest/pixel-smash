defmodule PixelSmash.MemoryRepo do
  @moduledoc "For fast experimenting with schemas"
  use GenServer

  def start_link(_init_arg) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def insert(entity) do
    GenServer.call(__MODULE__, {:insert, entity})
  end

  def get!(schema_module, id) do
    GenServer.call(__MODULE__, {:get!, schema_module, id})
  end

  def all(module) do
    GenServer.call(__MODULE__, {:all, module})
  end

  @impl GenServer
  def init(map) do
    {:ok, map}
  end

  @impl GenServer
  def handle_call(
        {:insert, %Ecto.Changeset{data: %module{} = entity, changes: changes}},
        _from,
        map
      ) do
    entity = Map.merge(entity, changes)

    list = Map.get(map, module, [])
    entity = Map.put(entity, :id, length(list) + 1)
    updated_map = Map.put(map, module, List.insert_at(list, -1, entity))

    {:reply, {:ok, entity}, updated_map}
  end

  def handle_call({:get!, module, id}, _from, map) do
    entity =
      map
      |> Map.get(module, [])
      |> Enum.find(&(&1.id == id))

    {:reply, entity, map}
  end

  def handle_call({:all, module}, _from, map) do
    list = Map.get(map, module, [])

    {:reply, list, map}
  end

  def sprite_from_map(map), do: map
end

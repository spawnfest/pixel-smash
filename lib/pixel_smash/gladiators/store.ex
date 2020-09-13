defmodule PixelSmash.Gladiators.Store do
  use GenServer

  require Logger

  alias PixelSmash.Gladiators.{
    ELO,
    Gladiator
  }

  @max_gladiators 16

  def start_link(init_arg) do
    GenServer.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def list_gladiators(pid \\ __MODULE__) do
    GenServer.call(pid, :list_gladiators)
  end

  def list_gladiators_by_elo(pid \\ __MODULE__) do
    GenServer.call(pid, :list_gladiators_by_elo)
  end

  def get_gladiator(pid \\ __MODULE__, id) do
    GenServer.call(pid, {:get_gladiator, id})
  end

  def register_battle_result(pid \\ __MODULE__, matchup, winner) do
    GenServer.call(pid, {:register_battle_result, matchup, winner})
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

  def handle_call(:list_gladiators_by_elo, _from, store) do
    gladiators =
      store
      |> Map.values()
      |> Enum.sort_by(& &1.elo, :desc)

    {:reply, gladiators, store}
  end

  def handle_call({:get_gladiator, id}, _from, store) do
    gladiator = Map.get(store, id)

    {:reply, gladiator, store}
  end

  def handle_call({:register_battle_result, {left_id, right_id}, winner}, _from, store) do
    left = Map.get(store, left_id)
    right = Map.get(store, right_id)

    {left, right} = ELO.handle_battle_result({left, right}, winner)

    left =
      case winner do
        :left -> %Gladiator{left | wins: left.wins + 1}
        :draw -> %Gladiator{left | draws: left.draws + 1}
        :right -> %Gladiator{left | losses: left.losses + 1}
      end

    right =
      case winner do
        :left -> %Gladiator{right | losses: right.losses + 1}
        :draw -> %Gladiator{right | draws: right.draws + 1}
        :right -> %Gladiator{right | wins: right.wins + 1}
      end

    store =
      store
      |> Map.put(left_id, left)
      |> Map.put(right_id, right)

    Logger.info(fn ->
      "Registering a battle result for combatants: {#{left_id}, #{right_id}}, winner: #{winner}"
    end)

    {:reply, :ok, store}
  end
end

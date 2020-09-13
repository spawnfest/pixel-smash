defmodule PixelSmash.Battles.Matchmaking do
  use GenServer

  require Logger

  alias PixelSmash.Battles.{
    Battle,
    BattleServer,
    BattleSupervisor,
    Fighter
  }

  alias PixelSmash.Gladiators

  @initial_betting_time :timer.seconds(15)
  @max_series_length :timer.seconds(60)
  @time_between_series :timer.seconds(10)

  def start_link(init_arg) do
    GenServer.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def list_upcoming_battles(server \\ __MODULE__) do
    GenServer.call(server, :list_upcoming_battles)
  end

  def list_finished_battles(server \\ __MODULE__) do
    GenServer.call(server, :list_finished_battles)
  end

  def list_current_battles(server \\ __MODULE__) do
    GenServer.call(server, :list_current_battles)
  end

  @impl GenServer
  def init(_init_arg) do
    state = %{
      timer_ref: nil,
      finished_battles: [],
      current_series: %{},
      next_series: %{}
    }

    {:ok, state, {:continue, :schedule_series}}
  end

  @impl GenServer
  def handle_call(:list_upcoming_battles, _from, state) do
    result =
      state.next_series
      |> Enum.map(fn {_ref, {pid, _combatants}} ->
        BattleServer.get_battle(pid)
      end)
      |> Enum.sort_by(& &1.id)

    {:reply, result, state}
  end

  @impl GenServer
  def handle_call(:list_finished_battles, _from, state) do
    result = Enum.sort_by(state.finished_battles, & &1.id)

    {:reply, result, state}
  end

  @impl GenServer
  def handle_call(:list_current_battles, _from, state) do
    result =
      Enum.map(state.current_series, fn {_ref, {pid, _combatants}} ->
        BattleServer.get_battle(pid)
      end)
      |> Enum.sort_by(& &1.id)

    {:reply, result, state}
  end

  @impl GenServer
  def handle_continue(:schedule_series, state) do
    timer_ref = Process.send_after(self(), :start_initial_series, @initial_betting_time)

    state = %{
      state
      | timer_ref: timer_ref,
        next_series: schedule_series()
    }

    Logger.info(fn ->
      "Scheduled the first series"
    end)

    {:noreply, state}
  end

  @impl GenServer
  def handle_info(:start_initial_series, state) do
    state = start_next_series(state)

    Logger.info(fn ->
      "Initial betting time elapsed, started the first series"
    end)

    {:noreply, state}
  end

  @impl GenServer
  def handle_info(:max_series_length_exceeded, state) do
    state = start_next_series(state)

    Logger.info(fn ->
      "Maximum battle length elapsed, starting the next series"
    end)

    {:noreply, state}
  end

  @impl GenServer
  def handle_info(:start_next_series, state) do
    state = start_next_series(state)

    Logger.info(fn ->
      "Started the next series"
    end)

    {:noreply, state}
  end

  @impl GenServer
  def handle_info({:DOWN, ref, :process, _pid, {:shutdown, %Battle.Finished{} = battle}}, state) do
    Logger.info(fn ->
      "Battle finished, id: #{battle.id}, winner: #{battle.winner.id}, loser: #{battle.loser.id}"
    end)

    state = %{
      state
      | current_series: Map.delete(state.current_series, ref),
        finished_battles: [battle | state.finished_battles]
    }

    :ok = Gladiators.register_battle_result({battle.winner.id, battle.loser.id}, :left)

    if map_size(state.current_series) == 0 do
      Logger.info(fn ->
        "All battles finished, starting the next series in #{@time_between_series} seconds"
      end)

      Process.cancel_timer(state.timer_ref)
      Process.send_after(self(), :start_next_series, @time_between_series)
    end

    {:noreply, state}
  end

  @impl GenServer
  def handle_info({:DOWN, ref, :process, _pid, _reason}, state) do
    {_, {left, right}} = Map.get(state.current_series, ref)

    Logger.error(fn ->
      "Battle crashed, combatants: {#{left.id}, #{right.id}}"
    end)

    :ok = Gladiators.register_battle_result({left.id, right.id}, :draw)

    state = %{state | current_series: Map.delete(state.current_series, ref)}

    if map_size(state.current_series) == 0 do
      Logger.info(fn ->
        "All battles finished, starting the next series in #{@time_between_series} seconds"
      end)

      Process.cancel_timer(state.timer_ref)
      Process.send_after(self(), :start_next_series, @time_between_series)
    end

    {:noreply, state}
  end

  defp schedule_series() do
    matchups =
      Gladiators.list_gladiators()
      |> Enum.map(&Fighter.from_gladiator/1)
      |> Enum.shuffle()
      |> Enum.chunk_every(2)
      |> Enum.map(&List.to_tuple/1)

    Enum.reduce(matchups, %{}, fn combatants, acc ->
      {:ok, pid} = BattleSupervisor.schedule_battle(combatants)
      ref = Process.monitor(pid)

      Map.put(acc, ref, {pid, combatants})
    end)
  end

  defp start_next_series(state) do
    Enum.each(state.current_series, fn {ref, {pid, {left, right}}} ->
      Logger.info(fn ->
        "Terminating battle as a draw, combatants: {#{left.id}, #{right.id}}"
      end)

      :ok = Gladiators.register_battle_result({left.id, right.id}, :draw)

      Process.demonitor(ref)
      BattleSupervisor.terminate_battle_server(pid)
    end)

    Enum.each(state.next_series, fn {_ref, {pid, _combatants}} ->
      BattleServer.start_battle(pid)
    end)

    timer_ref = Process.send_after(self(), :max_series_length_exceeded, @max_series_length)

    %{
      state
      | timer_ref: timer_ref,
        finished_battles: [],
        current_series: state.next_series,
        next_series: schedule_series()
    }
  end
end

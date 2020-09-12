defmodule PixelSmash.Battles.Server do
  use GenServer

  alias PixelSmash.Battles
  alias PixelSmash.Battles.Fighter
  alias PixelSmash.Battles.Battle

  @seconds_per_tick 5

  def start_link({%Fighter{}, %Fighter{}} = init_arg) do
    GenServer.start_link(__MODULE__, init_arg)
  end

  def start_battle(pid) do
    GenServer.call(pid, :start_battle)
  end

  def get_battle(pid) do
    GenServer.call(pid, :get_battle)
  end

  def get_narration(pid) do
    GenServer.call(pid, :get_narration)
  end

  @impl GenServer
  def init({left, right}) do
    {:ok, Battle.schedule(left, right)}
  end

  @impl GenServer
  def handle_call(:start_battle, _from, %Battle.Scheduled{} = battle) do
    schedule_next_tick()

    {:reply, :ok, Battle.start(battle)}
  end

  @impl GenServer
  def handle_call(:get_battle, _from, battle) do
    {:reply, battle, battle}
  end

  @impl GenServer
  def handle_call(:get_narration, _from, %Battle.InProgress{} = battle) do
    {:reply, Battle.narrate(battle), battle}
  end

  @impl GenServer
  def handle_call(:get_narration, _from, %Battle.Finished{} = battle) do
    {:reply, Battle.narrate(battle), battle}
  end

  @impl GenServer
  def handle_info(:tick, %Battles.Battle.InProgress{} = battle) do
    schedule_next_tick()

    {:noreply, Battle.simulate_tick(battle)}
  end

  @impl GenServer
  def handle_info(:tick, %Battles.Battle.Finished{} = battle) do
    {:noreply, battle}
  end

  defp schedule_next_tick() do
    Process.send_after(self(), :tick, @seconds_per_tick * 1000)
  end
end

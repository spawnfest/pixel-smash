defmodule PixelSmashWeb.BattleComponentLive do
  use PixelSmashWeb, :live_component

  alias PixelSmash.Battles

  @seconds_per_tick 5

  @impl true
  def mount(socket) do
    {:ok, assign(socket, battle_started: false)}
  end

  @impl true
  def handle_event("start_battle", %{"id" => id}, socket) do
    battle = Battles.get_battle(id)
    :ok = Battles.start_battle(battle)
    send(self(), {__MODULE__, :tick})

    {:noreply, assign(socket, battle_started: true)}
  end

  @impl true
  def update(%{battle: battle}, socket) do
    if socket.assigns.battle_started do
      schedule_next_tick()
    end

    {:ok, assign(socket, battle: battle)}
  end

  defp schedule_next_tick() do
    Process.send_after(self(), {__MODULE__, :tick}, @seconds_per_tick * 1000)
  end
end

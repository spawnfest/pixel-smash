defmodule PixelSmashWeb.PageLive do
  use PixelSmashWeb, :live_view

  alias PixelSmash.Battles

  @seconds_per_tick 5

  @impl true
  def mount(params, session, socket) do
    socket =
      socket
      |> assign_defaults(params, session)
      |> assign(:battles, Battles.list_battles())

    send(self(), :tick)

    {:ok, socket}
  end

  @impl true
  def handle_event("start_battle", %{"id" => id}, socket) do
    battle = Battles.get_battle(id)
    :ok = Battles.start_battle(battle)

    socket =
      socket
      |> assign(:battles, Battles.list_battles())

    {:noreply, socket}
  end

  @impl true
  def handle_info(:tick, socket) do
    schedule_next_tick()

    socket =
      socket
      |> assign(:battles, Battles.list_battles())

    {:noreply, socket}
  end

  defp schedule_next_tick() do
    Process.send_after(self(), :tick, @seconds_per_tick * 1000)
  end
end

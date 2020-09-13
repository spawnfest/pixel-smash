defmodule PixelSmashWeb.PageLive do
  use PixelSmashWeb, :live_view

  alias PixelSmash.Battles
  alias PixelSmashWeb.BattleComponentLive, as: BattleComponent

  @tick_rate :timer.seconds(2)

  @impl true
  def mount(params, session, socket) do
    socket =
      socket
      |> assign_defaults(params, session)
      |> assign(:upcoming_battles, Battles.list_upcoming_battles())
      |> assign(:current_battles, Battles.list_current_battles())

    send(self(), :tick)

    {:ok, socket}
  end

  @impl true
  def handle_info(:tick, socket) do
    schedule_next_tick()

    socket =
      socket
      |> assign(:upcoming_battles, Battles.list_upcoming_battles())
      |> assign(:current_battles, Battles.list_current_battles())

    {:noreply, socket}
  end

  defp schedule_next_tick() do
    Process.send_after(self(), :tick, @tick_rate)
  end
end

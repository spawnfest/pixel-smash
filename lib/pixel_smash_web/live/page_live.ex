defmodule PixelSmashWeb.PageLive do
  use PixelSmashWeb, :live_view

  alias PixelSmash.{
    Battles,
    Gladiators
  }

  alias PixelSmashWeb.{
    FinishedBattleComponent,
    InProgressBattleComponent,
    ScheduledBattleComponent,
    StandingsComponent
  }

  @tick_rate :timer.seconds(2)

  @impl true
  def mount(params, session, socket) do
    socket =
      socket
      |> assign_defaults(params, session)
      |> assign(:upcoming_battles, Battles.list_upcoming_battles())
      |> assign(:finished_battles, Battles.list_finished_battles())
      |> assign(:current_battles, Battles.list_current_battles())
      |> assign(:gladiators, Gladiators.list_gladiators_by_elo())

    send(self(), :tick)

    {:ok, socket}
  end

  @impl true
  def handle_info(:tick, socket) do
    schedule_next_tick()

    socket =
      socket
      |> assign(:upcoming_battles, Battles.list_upcoming_battles())
      |> assign(:finished_battles, Battles.list_finished_battles())
      |> assign(:current_battles, Battles.list_current_battles())
      |> assign(:gladiators, Gladiators.list_gladiators_by_elo())

    {:noreply, socket}
  end

  defp schedule_next_tick() do
    Process.send_after(self(), :tick, @tick_rate)
  end
end

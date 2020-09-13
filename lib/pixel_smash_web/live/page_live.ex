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
      |> assign(:sort_order, :desc)

    send(self(), :tick)

    {:ok, socket}
  end

  @impl true
  def handle_event("resort_standings", _params, %{assigns: %{sort_order: :desc}} = socket) do
    socket =
      socket
      |> assign(:sort_order, :asc)
      |> assign(:gladiators, Gladiators.list_gladiators_by_elo(:asc))
    {:noreply, socket}
  end

  def handle_event("resort_standings", _params, %{assigns: %{sort_order: :asc}} = socket) do
    socket =
      socket
      |> assign(:sort_order, :desc)
      |> assign(:gladiators, Gladiators.list_gladiators_by_elo(:desc))
      {:noreply, socket}
  end

  @impl true
  def handle_info(:tick, %{assigns: %{sort_order: sort_order}}= socket) do
    schedule_next_tick()

    socket =
      socket
      |> assign(:upcoming_battles, Battles.list_upcoming_battles())
      |> assign(:finished_battles, Battles.list_finished_battles())
      |> assign(:current_battles, Battles.list_current_battles())
      |> assign(:gladiators, Gladiators.list_gladiators_by_elo(sort_order))

    {:noreply, socket}
  end

  defp schedule_next_tick() do
    Process.send_after(self(), :tick, @tick_rate)
  end
end

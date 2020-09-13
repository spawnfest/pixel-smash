defmodule PixelSmashWeb.StandingsLive do
  @moduledoc """
  Handles the display, and updating of the standings table.
  The standings are updated by polling the data every 5 seconds,
  to display the new standings.
  The standings are sorted by the highest ELO value by default,
  but can be sorted by the lowest value if the user clicks on the
  ELO header in the table
  """
  use PixelSmashWeb, :live_view

  alias PixelSmash.Gladiators
  alias PixelSmashWeb.StandingsComponent

  @tick_rate :timer.seconds(5)

  @impl true
  def mount(params, session, socket) do
    socket =
      socket
      |> assign_defaults(params, session)
      |> assign(:gladiators, Gladiators.list_gladiators_by_elo())
      |> assign(:sort_order, :desc)

    send(self(), :tick)

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~L"""
      <%= live_component @socket, StandingsComponent, gladiators: @gladiators %>
    """
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
  def handle_info(:tick, %{assigns: %{sort_order: sort_order}} = socket) do
    schedule_next_tick()

    socket =
      socket
      |> assign(:gladiators, Gladiators.list_gladiators_by_elo(sort_order))

    {:noreply, socket}
  end

  defp schedule_next_tick() do
    Process.send_after(self(), :tick, @tick_rate)
  end

end

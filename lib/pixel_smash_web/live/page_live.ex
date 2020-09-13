defmodule PixelSmashWeb.PageLive do
  @moduledoc """
  This contains the bulk of logic for handling the front end portion of the
  PixelSmash Arena. Currently we are using a polling system with a timer to
  update the current battle events happening through the scheduler.
  """
  use PixelSmashWeb, :live_view

  alias PixelSmash.{
    Battles,
    Betting,
    Gladiators
  }

  alias PixelSmashWeb.{
    FinishedBattleComponent,
    InProgressBattleComponent,
    ScheduledBattleComponent
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
  def handle_event("bet", %{"side" => side, "amount" => amount, "battle" => battle_id}, socket) do
    side =
      case side do
        "left" -> :left
        "right" -> :right
      end

    battle = Battles.get_battle(battle_id)

    :ok =
      Betting.place_bet(battle, {socket.assigns.current_user, side, String.to_integer(amount)})

    socket =
      socket
      |> assign_balance()

    {:noreply, socket}
  end

  @impl true
  def handle_event("show_gladiator", %{"id" => id}, socket) do
    {:noreply, push_redirect(socket, to: "/gladiator/#{id}")}
  end

  @impl true
  def handle_info(:tick, %{assigns: %{sort_order: sort_order}} = socket) do
    schedule_next_tick()

    socket =
      socket
      |> assign_balance()
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

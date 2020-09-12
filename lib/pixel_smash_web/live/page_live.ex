defmodule PixelSmashWeb.PageLive do
  use PixelSmashWeb, :live_view

  alias PixelSmash.Battles
  alias PixelSmash.Gladiators

  @seconds_per_tick 5

  @impl true
  def mount(params, session, socket) do
    left_gladiator = Gladiators.generate_gladiator()
    right_gladiator = Gladiators.generate_gladiator()

    left_fighter = Gladiators.build_fighter(left_gladiator)
    right_fighter = Gladiators.build_fighter(right_gladiator)

    {:ok, battle_server} = Battles.schedule_battle(left_fighter, right_fighter)

    socket =
      socket
      |> assign_defaults(params, session)
      |> assign(left_gladiator: left_gladiator, right_gladiator: right_gladiator)
      |> assign(:battle_server, battle_server)
      |> assign(:battle, Battles.get_battle(battle_server))
      |> assign(:battle_log, [])

    {:ok, socket}
  end

  @impl true
  def handle_event("start_battle", _value, socket) do
    :ok = Battles.start_battle(socket.assigns.battle_server)

    send(self(), :tick)

    {:noreply, socket}
  end

  @impl true
  def handle_info(:tick, socket) do
    schedule_next_tick()

    battle_server = socket.assigns.battle_server
    battle = Battles.get_battle(battle_server)
    battle_log = Battles.narrate_battle(battle_server)

    socket =
      socket
      |> assign(:battle, battle)
      |> assign(:battle_log, battle_log)

    {:noreply, socket}
  end

  defp schedule_next_tick() do
    Process.send_after(self(), :tick, @seconds_per_tick * 1000)
  end
end

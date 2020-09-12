defmodule PixelSmashWeb.PageLive do
  use PixelSmashWeb, :live_view

  alias PixelSmash.Battles

  @seconds_per_tick 5

  @impl true
  def mount(params, session, socket) do
    left_fighter = generate_fighter()
    right_fighter = generate_fighter()

    {:ok, battle_server} = Battles.schedule_battle(left_fighter, right_fighter)

    socket =
      socket
      |> assign_defaults(params, session)
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

  defp generate_fighter() do
    Battles.Fighter.new(
      random_name(),
      0,
      random_attribute_value(:health),
      random_attribute_value(:strength),
      random_attribute_value(:speed),
      random_attribute_value(:magic),
      ["Freeze Ray"]
    )
  end

  defp random_name, do: Faker.Person.En.name()
  defp random_attribute_value(:health), do: Enum.random(50..100)
  defp random_attribute_value(:strength), do: Enum.random(10..30)
  defp random_attribute_value(:speed), do: Enum.random(5..25)
  defp random_attribute_value(:magic), do: Enum.random(15..45)
end

defmodule PixelSmash.Simulator do
  use GenServer

  alias PixelSmash.Battles
  alias PixelSmash.Battles.Fighter
  alias PixelSmash.Battles.Battle

  def start_link([]) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @spec start_simulation :: :ok
  def start_simulation do
    GenServer.cast(__MODULE__, :simulate)
  end

  @impl true
  def init(_) do
    {:ok, %{}}
  end

  @impl true
  def handle_cast(:simulate, _state) do
    %Fighter{} =
      left =
      Fighter.new(
        random_name(),
        0,
        random_attribute_value(:health),
        random_attribute_value(:strength),
        random_attribute_value(:speed),
        random_attribute_value(:magic),
        ["Fire Ball"]
      )

    %Fighter{} =
      right =
      Fighter.new(
        random_name(),
        0,
        random_attribute_value(:health),
        random_attribute_value(:strength),
        random_attribute_value(:speed),
        random_attribute_value(:magic),
        ["Freeze Ray"]
      )

    %Battle.InProgress{} = battle = Battles.create_battle(left, right)

    send(__MODULE__, :tick)
    {:noreply, %{battle: battle}}
  end

  @impl true
  def handle_info(:tick, %{battle: %Battles.Battle.InProgress{} = battle}) do
    new_battle = Battles.tick_battle(battle)
    Battles.narrate_battle(battle)
    schedule_next_tick()
    {:noreply, %{battle: new_battle}}
  end

  def handle_info(:tick, %{battle: %Battles.Battle.Finished{} = battle}) do
    IO.puts("Battle Ended")
    {:noreply, %{battle: battle}}
  end

  defp random_name, do: Faker.Person.En.name()

  defp random_attribute_value(:health), do: Enum.random(50..100)
  defp random_attribute_value(:strength), do: Enum.random(10..30)
  defp random_attribute_value(:speed), do: Enum.random(5..25)
  defp random_attribute_value(:magic), do: Enum.random(15..45)

  defp schedule_next_tick(), do: Process.send_after(__MODULE__, :tick, 10 * 60)
end

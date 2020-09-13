defmodule PixelSmashWeb.ScheduledBattleComponent do
  use PixelSmashWeb, :live_component

  alias PixelSmash.{
    Betting,
    Gladiators
  }

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def update(assigns, socket) do
    {left, right} = assigns.battle.fighters

    {:ok, {left_odds, right_odds}} = Betting.get_odds(assigns.battle)

    socket =
      socket
      |> assign(:left, Gladiators.get_gladiator(left.id))
      |> assign(:right, Gladiators.get_gladiator(right.id))
      |> assign(:left_odds, left_odds)
      |> assign(:right_odds, right_odds)

    {:ok, socket}
  end

  def as_percentage(%Decimal{} = n) do
    n
    |> Decimal.mult(100)
    |> Decimal.to_float()
    |> Number.Percentage.number_to_percentage(precision: 0)
  end
end

defmodule PixelSmashWeb.ScheduledBattleComponent do
  @moduledoc """
  Handles the display of the upcoming battles.
  Responsible for calculating the betting odds for each gladiator
  and displays the potential financial reward for placing a bet on the gladiator.
  """
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

    current_bet = Betting.get_bet(assigns.battle, assigns.current_user)
    {:ok, {left_odds, right_odds}} = Betting.get_odds(assigns.battle)

    socket =
      socket
      |> assign(:balance, assigns.balance)
      |> assign(:current_bet, current_bet)
      |> assign(:battle, assigns.battle)
      |> assign(:left, Gladiators.get_gladiator(left.id))
      |> assign(:right, Gladiators.get_gladiator(right.id))
      |> assign(:left_odds, left_odds)
      |> assign(:right_odds, right_odds)

    {:ok, socket}
  end

  @doc """
  Converts the odds to a percentage value to display to the user
  """
  def as_percentage(%Decimal{} = n) do
    n
    |> Decimal.mult(100)
    |> Decimal.to_float()
    |> Number.Percentage.number_to_percentage(precision: 0)
  end

  @doc """
  Calculates the potential winnings to be received if the gladiator being bet on is the winner
  """
  def example_winnings(battle, side) do
    {:ok, winnings} = Betting.get_expected_winnings(battle, side, 100)

    winnings = Number.Currency.number_to_currency(winnings, precision: 0)
    bet = Number.Currency.number_to_currency(100, precision: 0)

    "#{bet} ⇒ #{winnings}"
  end

  @doc """
  Handles the logic for if a player has placed a bet on a particular gladiator
  """
  def bet?({_user, side, _amount}, side), do: true
  def bet?(_, _), do: false

  def can_bet?(0.0), do: false
  def can_bet?(_), do: true

  def bet_amount(balance) do
    min(100, round(balance))
  end

  def formatted_bet_amount(balance) do
    Number.Currency.number_to_currency(bet_amount(balance), precision: 0)
  end

  def bet({_user, _side, amount}) do
    Number.Currency.number_to_currency(amount, precision: 0)
  end
end

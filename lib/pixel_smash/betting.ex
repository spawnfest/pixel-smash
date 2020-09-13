defmodule PixelSmash.Betting do
  alias PixelSmash.{
    Accounts,
    Battles,
    Betting
  }

  defdelegate child_spec(init_arg), to: Betting.Supervisor

  @type bet :: {Accounts.User.t(), :left | :right, integer()}

  def get_odds(bookie \\ Betting.Bookie, %Battles.Battle.Scheduled{} = battle) do
    Betting.Bookie.get_odds(bookie, battle)
  end

  def get_expected_winnings(
        bookie \\ Betting.Bookie,
        %Battles.Battle.Scheduled{} = battle,
        side,
        amount
      )
      when side in [:left, :right] and is_integer(amount) do
    Betting.Bookie.get_expected_winnings(bookie, battle, side, amount)
  end

  def get_bet(bookie \\ Betting.Bookie, battle, user)
  def get_bet(_bookie, _battle, nil), do: nil
  def get_bet(bookie, battle, %Accounts.User{} = user) do
    Betting.Bookie.get_bet(bookie, battle, user)
  end

  def place_bet(
        bookie \\ Betting.Bookie,
        %Battles.Battle.Scheduled{} = battle,
        {%Accounts.User{}, side, amount} = bet
      )
      when side in [:left, :right] and is_integer(amount) do
    Betting.Bookie.place_bet(bookie, battle, bet)
  end
end

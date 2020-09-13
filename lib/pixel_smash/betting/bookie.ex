defmodule PixelSmash.Betting.Bookie do
  use GenServer

  require Logger

  alias PixelSmash.{
    Battles,
    Gladiators,
    Wallets
  }

  def start_link(opts) do
    name = Keyword.get(opts, :name, __MODULE__)

    GenServer.start_link(__MODULE__, opts, name: name)
  end

  def get_odds(pid \\ __MODULE__, battle) do
    GenServer.call(pid, {:get_odds, battle})
  end

  def get_expected_winnings(pid \\ __MODULE__, battle, side, amount) do
    GenServer.call(pid, {:get_expected_winnings, battle, side, amount})
  end

  def place_bet(pid \\ __MODULE__, battle, bet) do
    GenServer.call(pid, {:place_bet, battle, bet})
  end

  def init(_opts) do
    Phoenix.PubSub.subscribe(PixelSmash.PubSub, "battles:*")

    state = %{
      open_books: %{},
      closed_books: %{}
    }

    {:ok, state}
  end

  def handle_call({:get_odds, battle}, _from, state) do
    case Map.get(state.open_books, battle.id) do
      nil ->
        {:reply, {:error, :battle_not_open_for_betting}, state}

      {odds, _bets} ->
        {:reply, {:ok, odds}, state}
    end
  end

  def handle_call({:get_expected_winnings, battle, side, amount}, _from, state) do
    case Map.get(state.open_books, battle.id) do
      nil ->
        {:error, :battle_not_open_for_betting}

      {odds, _bets} ->
        winnings = calculate_expected_winnings(odds, side, amount)

        {:reply, {:ok, winnings}, state}
    end
  end

  def handle_call({:place_bet, battle, {user, side, amount} = bet}, _from, state) do
    wallet_id = Wallets.get_wallet_id(user.id)

    with {:ok, _wallet} <- Wallets.take_stake(wallet_id, amount),
         {:ok, state} <- add_bet(state, battle.id, bet) do
      Logger.info(fn ->
        "Placed bet: {#{user.id}, #{side}, #{amount}}, on battle: #{battle.id}"
      end)

      {:reply, :ok, state}
    else
      {:error, error} ->
        {:reply, {:error, error}, state}
    end
  end

  def handle_info({:battle_scheduled, %Battles.Battle.Scheduled{} = battle}, state) do
    {left, right} = battle.fighters

    odds =
      Gladiators.expected_battle_result(
        {Gladiators.get_gladiator(left.id), Gladiators.get_gladiator(right.id)}
      )

    state = open_book(state, battle.id, odds)

    Logger.info(fn ->
      "Opened betting for battle: #{battle.id}"
    end)

    {:noreply, state}
  end

  def handle_info({:battle_started, %Battles.Battle.InProgress{} = battle}, state) do
    state = close_book(state, battle.id)

    Logger.info(fn ->
      "Closed betting for battle: #{battle.id}"
    end)

    {:noreply, state}
  end

  def handle_info({:battle_finished, %Battles.Battle.Finished{} = battle}, state) do
    state = consume_bets(state, battle)

    {:noreply, state}
  end

  defp open_book(state, battle_id, odds) do
    put_in(state, [:open_books, battle_id], {odds, []})
  end

  defp close_book(state, battle_id) do
    case Map.pop(state.open_books, battle_id) do
      {nil, _} ->
        state

      {closed_book, open_books} ->
        state = %{
          state
          | open_books: open_books,
            closed_books: Map.put(state.closed_books, battle_id, closed_book)
        }

        state
    end
  end

  defp consume_bets(state, battle) do
    case Map.pop(state.closed_books, battle.id) do
      {nil, _} ->
        state

      {{odds, bets}, closed_books} ->
        Enum.each(bets, &handle_bet_outcome(&1, battle, odds))

        %{
          state
          | closed_books: closed_books
        }
    end
  end

  defp add_bet(state, battle_id, bet) do
    case Map.get(state.open_books, battle_id) do
      nil ->
        {:error, :battle_not_open_for_betting}

      {odds, bets} ->
        state = %{
          state
          | open_books: Map.put(state.open_books, battle_id, {odds, [bet | bets]})
        }

        {:ok, state}
    end
  end

  defp calculate_expected_winnings({left_odds, right_odds}, side, amount) do
    divisor =
      case side do
        :left ->
          Decimal.div(left_odds, right_odds)

        :right ->
          Decimal.div(right_odds, left_odds)
      end

    winnings = Decimal.div_int(amount, divisor)
    total = Decimal.add(amount, winnings)

    Decimal.to_integer(total)
  end

  defp handle_bet_outcome({user, side, amount}, battle, odds) do
    cond do
      :draw == battle.outcome ->
        wallet_id = Wallets.get_wallet_id(user.id)
        {:ok, _wallet} = Wallets.fund(wallet_id, amount)

        Logger.info(fn ->
          "Refunded a bet against a drawed battle: {#{user.id}, #{side}, #{amount}}, battle: #{
            battle.id
          }"
        end)

      side == battle.outcome ->
        winnings = calculate_expected_winnings(odds, side, amount)
        wallet_id = Wallets.get_wallet_id(user.id)

        {:ok, _wallet} = Wallets.fund(wallet_id, winnings)

        Logger.info(fn ->
          "Paid out a winning bet: {#{user.id}, #{side}, #{amount}}, winnings: #{winnings}, battle: #{
            battle.id
          }"
        end)

      :else ->
        Logger.info(fn ->
          "Closed out a losing bet: {#{user.id}, #{side}, #{amount}}, battle: #{battle.id}"
        end)

        :ok
    end
  end
end

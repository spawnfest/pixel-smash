defmodule PixelSmash.Wallets do
  @moduledoc """
  Wallets context. Allows to fetch wallet by ID. Fund and withdraw money from it.

  ## Examples

      iex> alias PixelSmash.{Wallets, Wallets.Wallet}
      iex>
      ...> %Wallet{user_id: "user_0", deposit: deposit, id: wallet_id} = Wallets.open_wallet("user_0", "300")
      ...> true = Decimal.eq?(300, deposit)
      iex>
      ...> ^wallet_id = Wallets.get_wallet_id("user_0")
      ...> 300.0 = wallet_id |> Wallets.get_ballance() |> Decimal.to_float()
      iex>
      ...> {:error, :not_enough_ballance} = Wallets.take_stake(wallet_id, "500")
      iex>
      ...> {:ok, %Wallet{id: ^wallet_id}} = Wallets.take_stake(wallet_id, "299.9")
      ...> 0.1 = wallet_id |> Wallets.get_ballance() |> Decimal.to_float()
      iex>
      ...> {:ok, %Wallet{id: ^wallet_id}} = Wallets.fund(wallet_id, "399.9")
      ...> 400.0 = wallet_id |> Wallets.get_ballance() |> Decimal.to_float()
      iex>
      ...> %Wallet{id: wallet_id} = Wallets.open_wallet("user_0", 300)
      ...> "$300" = Wallets.get_ballance_string(wallet_id)
      ...> %Wallet{id: wallet_id} = Wallets.open_wallet("user_0", "301.33333333")
      ...> "$301,33" = Wallets.get_ballance_string(wallet_id)
  """

  alias PixelSmash.Wallets.{
    Vault,
    Supervisor,
    Wallet
  }

  defdelegate child_spec(init_arg), to: Supervisor

  def persisted_wallets do
    [Wallet.new("user_1", "250.00")]
  end

  def open_wallet(user_id, initial_deposit) do
    user_id
    |> Wallet.new(initial_deposit)
    |> Vault.put_wallet()
  end

  def get_wallet_id(user_id) do
    %Wallet{id: id} = Vault.get_wallet_by_user(user_id)
    id
  end

  def get_ballance(wallet_id) do
    %Wallet{deposit: deposit} = Vault.get_wallet(wallet_id)
    deposit
  end

  def get_ballance_string(wallet_id) do
    wallet_id
    |> get_ballance()
    |> Decimal.mult(100)
    |> Decimal.round()
    |> Decimal.to_integer()
    |> Money.new()
    |> Money.to_string()
  end

  def take_stake(wallet_id, amount) do
    Vault.update_wallet(wallet_id, fn %Wallet{deposit: deposit} = wallet ->
      updated_deposit = Decimal.sub(deposit, amount)

      if Decimal.lt?(updated_deposit, 0) do
        {:error, :not_enough_ballance}
      else
        %{wallet | deposit: updated_deposit}
      end
    end)
  end

  def fund(wallet_id, amount) do
    Vault.update_wallet(wallet_id, fn %Wallet{deposit: deposit} = wallet ->
      %{wallet | deposit: Decimal.add(deposit, amount)}
    end)
  end
end

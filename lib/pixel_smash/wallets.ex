defmodule PixelSmash.Wallets do
  @moduledoc """
  Wallets context. Allows to fetch wallet by ID. Fund and withdraw money from it.

  ## Examples

      iex> alias PixelSmash.{Wallets, Wallets.Wallet}
      iex>
      ...> ^wallet_id = Wallets.get_wallet_id("user_0")
      ...> 300.0 = wallet_id |> Wallets.get_balance() |> Decimal.to_float()
      iex>
      ...> {:error, :not_enough_balance} = Wallets.take_stake(wallet_id, "500")
      iex>
      ...> {:ok, %Wallet{id: ^wallet_id}} = Wallets.take_stake(wallet_id, "299.9")
      ...> 0.1 = wallet_id |> Wallets.get_balance() |> Decimal.to_float()
      iex>
      ...> {:ok, %Wallet{id: ^wallet_id}} = Wallets.fund(wallet_id, "399.9")
      ...> 400.0 = wallet_id |> Wallets.get_balance() |> Decimal.to_float()
  """

  alias PixelSmash.Wallets.{
    Vault,
    Supervisor,
    Wallet
  }

  defdelegate child_spec(init_arg), to: Supervisor

  def persisted_wallets do
    [Wallet.new(1, "1000.00")]
  end

  def get_wallet_id(user_id) do
    %Wallet{id: id} = Vault.get_wallet_by_user(user_id)
    id
  end

  def get_balance(wallet_id) do
    %Wallet{deposit: deposit} = Vault.get_wallet(wallet_id)
    deposit
  end

  def get_balance_string(wallet_id) do
    wallet_id
    |> get_balance()
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
        {:error, :not_enough_balance}
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

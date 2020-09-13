defmodule PixelSmash.Wallets do
  @moduledoc """
  Wallets context. Allows to fetch wallet by ID. Fund and withdraw money from it.

  ## Examples

      iex> alias PixelSmash.{Wallets, Wallets.Wallet}
      iex>
      ...> wallet_id = Wallets.get_wallet_id("user_0")
      ...> 1000.0 = wallet_id |> Wallets.get_balance() |> Decimal.to_float()
      iex>
      ...> {:error, :not_enough_balance} = Wallets.take_stake(wallet_id, "1100")
      iex>
      ...> {:ok, %Wallet{id: ^wallet_id}} = Wallets.take_stake(wallet_id, "299.9")
      ...> 700.1 = wallet_id |> Wallets.get_balance() |> Decimal.to_float()
      iex>
      ...> {:ok, %Wallet{id: ^wallet_id}} = Wallets.fund(wallet_id, "399.9")
      ...> 1100.0 = wallet_id |> Wallets.get_balance() |> Decimal.to_float()
  """

  alias PixelSmash.Wallets.{
    Vault,
    Supervisor,
    Wallet
  }

  defdelegate child_spec(init_arg), to: Supervisor

  def persisted_wallets do
    []
  end

  def get_wallet_id(user_id) do
    %Wallet{id: id} = Vault.get_wallet_by_user(user_id)
    id
  end

  def get_balance(wallet_id) do
    %Wallet{deposit: deposit} = Vault.get_wallet(wallet_id)
    deposit
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

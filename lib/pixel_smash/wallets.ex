defmodule PixelSmash.Wallets do
  @moduledoc """
  Wallets context. Allows to fetch wallet by ID. Fund and withdraw money from it.
  """

  alias PixelSmash.Wallets.{
    Vault,
    Supervisor,
    Wallet
  }

  defdelegate child_spec(init_arg), to: Supervisor

  def restore_wallets do
    [Wallet.new("user_1", "250.00")]
  end

  def open_wallet(user_id, initial_deposit) do
    user_id
    |> Wallet.new(initial_deposit)
    |> Vault.put_wallet()
  end

  def get_deposit(wallet_id) do
    %Wallet{deposit: deposit} = Vault.get_wallet(wallet_id)
    deposit
  end

  def take_stake(wallet_id, amount) do
  end
end

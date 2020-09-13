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
    [Wallet.open("user_1", "250.00")]
  end

end

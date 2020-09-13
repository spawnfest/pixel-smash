defmodule PixelSmash.Wallets.Wallet do
  import Algae

  @type id :: String.t()

  defdata do
    id :: __MODULE__.id()
    user_id :: pos_integer()
    deposit :: any()
  end

  def open(user_id, initial_deposit) when user_id > 0 and is_binary(initial_deposit) do
    __MODULE__.new(Ecto.UUID.generate(), user_id, Decimal.new(initial_deposit))
  end
end

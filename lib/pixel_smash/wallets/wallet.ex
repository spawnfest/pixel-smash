defmodule PixelSmash.Wallets.Wallet do
  defstruct [:id, :user_id, :deposit]

  def new(id, user_id, deposit) when byte_size(id) > 0 and user_id > 0 do
    struct!(__MODULE__, %{id: id, user_id: user_id, deposit: Decimal.new(deposit)})
  end

  def new(user_id, initial_deposit) when user_id > 0 and is_binary(initial_deposit) do
    __MODULE__.new(Ecto.UUID.generate(), user_id, initial_deposit)
  end
end

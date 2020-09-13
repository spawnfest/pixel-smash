defmodule PixelSmashWeb.MountHelpers do
  import Phoenix.LiveView

  alias PixelSmash.Wallets

  def assign_defaults(socket, _params, session) do
    socket
    |> assign_current_user(session)
    |> assign_balance()
  end

  def assign_balance(socket) do
    balance =
      case socket.assigns.current_user do
        nil ->
          0

        user ->
          user.id
          |> Wallets.get_wallet_id()
          |> Wallets.get_balance()
          |> Decimal.to_float()
      end

    assign(socket, :balance, balance)
  end

  defp assign_current_user(socket, session) do
    assign_new(socket, :current_user, fn ->
      PixelSmash.Accounts.get_user_by_session_token(session["user_token"])
    end)
  end
end

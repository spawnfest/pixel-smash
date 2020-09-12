defmodule PixelSmashWeb.MountHelpers do
  import Phoenix.LiveView

  def assign_defaults(socket, _params, session) do
    socket
    |> assign_new(:current_user, fn ->
      PixelSmash.Accounts.get_user_by_session_token(session["user_token"])
    end)
  end
end

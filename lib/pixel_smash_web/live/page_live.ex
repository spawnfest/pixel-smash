defmodule PixelSmashWeb.PageLive do
  use PixelSmashWeb, :live_view

  @impl true
  def mount(params, session, socket) do
    socket =
      socket
      |> assign_defaults(params, session)

    {:ok, socket}
  end
end

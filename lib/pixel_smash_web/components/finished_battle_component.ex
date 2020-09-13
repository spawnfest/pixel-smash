defmodule PixelSmashWeb.FinishedBattleComponent do
  use PixelSmashWeb, :live_component

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def update(assigns, socket) do
    socket =
      socket
      |> assign(:winner, assigns.battle.winner)
      |> assign(:loser, assigns.battle.loser)

    {:ok, socket}
  end
end

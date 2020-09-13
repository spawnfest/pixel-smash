defmodule PixelSmashWeb.FinishedBattleComponent do
  use PixelSmashWeb, :live_component

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def update(assigns, socket) do
    {left, right} = assigns.battle.fighters

    socket =
      socket
      |> assign(:battle, assigns.battle)
      |> assign(:left, left)
      |> assign(:right, right)

    {:ok, socket}
  end

  def outcome(:left, :left), do: "Winner"
  def outcome(:right, :right), do: "Winner"
  def outcome(_, :draw), do: "Draw"
  def outcome(_, _), do: "Loser"
end

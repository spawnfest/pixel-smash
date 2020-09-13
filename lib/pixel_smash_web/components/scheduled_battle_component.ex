defmodule PixelSmashWeb.ScheduledBattleComponent do
  use PixelSmashWeb, :live_component

  alias PixelSmash.Gladiators

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def update(assigns, socket) do
    {left, right} = assigns.battle.fighters

    socket =
      socket
      |> assign(:left, Gladiators.get_gladiator(left.id))
      |> assign(:right, Gladiators.get_gladiator(right.id))

    {:ok, socket}
  end
end

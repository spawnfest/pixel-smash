defmodule PixelSmashWeb.InProgressBattleComponent do
  use PixelSmashWeb, :live_component

  alias PixelSmash.Battles

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

  def narration(battle) do
    battle
    |> Battles.narrate_battle()
    |> Enum.reverse()
    |> Enum.take(3)
    |> Enum.with_index()
    |> Enum.map(fn
      {line, 0} -> {line, "text-opacity-100"}
      {line, 1} -> {line, "text-opacity-75"}
      {line, 2} -> {line, "text-opacity-50"}
    end)
    |> Enum.reverse()
  end
end

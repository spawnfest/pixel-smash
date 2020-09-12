defmodule PixelSmashWeb.BattleComponentLive do
  use PixelSmashWeb, :live_component

  alias PixelSmash.Battles

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def update(%{battle: battle}, socket) do
    {:ok, assign(socket, battle: battle)}
  end
end

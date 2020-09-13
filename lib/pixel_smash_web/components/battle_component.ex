defmodule PixelSmashWeb.BattleComponent do
  use PixelSmashWeb, :live_component

  alias PixelSmash.Battles

  @impl true
  def mount(socket) do
    {:ok, socket}
  end
end

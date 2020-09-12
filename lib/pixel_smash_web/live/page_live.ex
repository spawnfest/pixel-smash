defmodule PixelSmashWeb.PageLive do
  use PixelSmashWeb, :live_view

  alias PixelSmash.Battles
  alias PixelSmashWeb.BattleComponentLive, as: BattleComponent

  @impl true
  def mount(params, session, socket) do
    socket =
      socket
      |> assign_defaults(params, session)
      |> assign(:battles, Battles.list_battles())

    send(self(), :tick)

    {:ok, socket}
  end

  @impl true
  def handle_info({BattleComponent, :tick}, socket) do
    socket =
      socket
      |> assign(:battles, Battles.list_battles())

    {:noreply, socket}
  end

  def handle_info(:tick, socket) do
    socket =
      socket
      |> assign(:battles, Battles.list_battles())

    {:noreply, socket}
  end
end

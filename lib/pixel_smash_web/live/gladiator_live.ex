defmodule PixelSmashWeb.GladiatorLive do
  use PixelSmashWeb, :live_view

  alias PixelSmash.Gladiators
  alias PixelSmashWeb.MenuComponent

  def mount(%{"id" => id} = params, session, socket) do
    socket =
      socket
      |> assign_defaults(params, session)
      |> assign(gladiator: Gladiators.get_gladiator(id))

      {:ok, socket}
  end

  def mount(params, session, socket) do
    socket =
      socket
      |> assign_defaults(params, session)
      |> assign(gladiators: Gladiators.list_gladiators())

      {:ok, socket}

  end

  def render(%{gladiator: gladiator} = assigns) do
    ~L"""
      <%= live_component @socket, MenuComponent, balance: @balance %>

      <%= live_component @socket, PixelSmashWeb.GladiatorCardComponent, gladiator: gladiator %>
    """
  end

  def render(%{gladiators: gladiators} = assigns) do
    ~L"""
      <%= live_component @socket, MenuComponent, balance: @balance %>

      <%= for gladiator <- gladiators do %>
        <%= live_component @socket, PixelSmashWeb.GladiatorCardComponent, gladiator: gladiator %>
      <% end %>
    """
  end
end

defmodule PixelSmashWeb.GladiatorComponent do
  use PixelSmashWeb, :live_component

  def render(assigns) do
    ~L"""
      <div class="flex items-start items-center space-x-4" phx-click="show_gladiator" phx-value-id="<%= @gladiator.id %>" %>
        <%= live_component @socket, PixelSmashWeb.SpriteComponent, sprite: @gladiator.sprite %>
        <div>
          <h2 class="text-lg font-semibold text-gray-100 -mt-1">
            <%= @gladiator.name %>
          </h2>
          <small class="block text-sm text-gray-500">
            <%= @text %>
          </small>
        </div>
      </div>
    """
  end
end

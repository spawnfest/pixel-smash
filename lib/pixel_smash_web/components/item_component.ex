defmodule PixelSmashWeb.ItemComponent do
  use PixelSmashWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
    <div class="bg-gray-900 rounded-lg">
      <div class="flex items-start">
        <span class="bg-pink-600 text-white p-2 leading-none flex items-center">
          <%= @item.type %>
        </span>
      </div>
      <div class="flex flex-col items-start px-4 py-6 space-y-4">
        <div class="flex items-start items-center space-x-4">
          <%= live_component @socket, PixelSmashWeb.SpriteComponent, sprite: @sprite %>
          <div>
            <h2 class="text-lg font-semibold text-gray-100 -mt-1">
              <%= @item.name %>
            </h2>
            <small class="block text-sm text-gray-500">
              <%= @item.attribute %>: <%= @item.power %>
            </small>
          </div>
        </div>
      </div>
    </div>
    """
  end
end

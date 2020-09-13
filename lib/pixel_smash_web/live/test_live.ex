defmodule PixelSmashWeb.TestLive do
  use PixelSmashWeb, :live_view

  @impl true
  def render(assigns) do
    ~L"""
    <h2>Individual Sprites</h2>
    <div class="flex flex-row items-start px-4 py-6 space-x-4">
      <div class="flex flex-col items-start space-y-4" style="width: 50%">
        <div class="flex items-start items-center space-x-4">
          <%= live_component @socket, PixelSmashWeb.SpriteComponent, sprite: @gladiator %>
        </div>
      </div>
      <div class="flex flex-col items-start space-y-4" style="width: 50%">
        <div class="flex items-start items-center space-x-4">
         <%= live_component @socket, PixelSmashWeb.SpriteComponent, sprite: @item %>
        </div>
      </div>
    </div>

    <h2>Equipment</h2>
    <div class="flex flex-row items-start px-4 py-6 space-x-4">
      <div class="flex flex-col items-start space-y-4">
        <div class="flex items-start items-center space-x-4">
          <%= live_component @socket, PixelSmashWeb.SpriteComponent, sprite: @equiped %>
        </div>
      </div>
    </div>
    """
  end

  @tick_rate :timer.seconds(2)

  @impl true
  def mount(_params, _session, socket) do
    # Generate our gladiator and item structs
    gladiator = PixelSmash.Gladiators.generate()
    item = PixelSmash.Items.generate()

    # Can be individually converted to sprites for rendering
    sprite_gladiator = gladiator |> PixelSmash.Sprites.to_sprite()
    sprite_item = item |> PixelSmash.Sprites.to_sprite()

    # May accept sprites, gladiators or items, anything that implements the protocol
    sprite_equiped = PixelSmash.Sprites.equip(gladiator, item)

    socket
    |> assign(:gladiator, sprite_gladiator)
    |> assign(:item, sprite_item)
    |> assign(:equiped, sprite_equiped)
    |> reply(:ok)
  end

  defp reply(socket, msg) do
    {msg, socket}
  end
end

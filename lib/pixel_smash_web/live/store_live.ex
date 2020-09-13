defmodule PixelSmashWeb.TheStoreLive do
  @moduledoc """
  Handles the display, and updating of the store items.
  """

  use PixelSmashWeb, :live_view

  @tick_rate :timer.seconds(5)

  @impl true
  def mount(params, session, socket) do
    IO.inspect(params)
    IO.inspect(session)

    socket =
      socket
      |> assign_defaults(params, session)
      |> assign(:the_store, PixelSmash.TheStore.on_sale())

    # send(self(), :tick)

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <%= if not Enum.empty?(@the_store) do %>
    <h2 class="text-center text-white text-2xl">The Store</h2>
      <div class="grid grid-flow-col grid-cols-3 grid-rows-2">
      <%= for item <- @the_store do %>
        <%= live_component @socket, PixelSmashWeb.ItemComponent, item: item.item, sprite: item.sprite %>
      <% end %>
      </div>
    <% end %>
    """
  end

  @impl true
  def handle_event(_event, _params, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_info(_message, socket) do
    {:noreply, socket}
  end

  # defp schedule_next_tick() do
  #  Process.send_after(self(), :tick, @tick_rate)
  # end
end

defmodule PixelSmashWeb.SpriteComponent do
  use PixelSmashWeb, :live_component

  def render(assigns) do
    ~L"""
    <svg
      style="min-width: 64px; min-height: 64px;"
      class="border-solid border-2 border-black"
      viewBox="1 1 <%= @sprite.x %> <%= @sprite.y %>"
      xmlns="http://www.w3.org/2000/svg"
      shape-rendering="crispEdges">
        <%= for {{x, y}, base_color} <- @sprite.map do %>
          <rect
            x="<%= x %>"
            y="<%= y %>"
            width="1"
            height="1"
            fill="<%= fill_color(base_color) %>"
          />
        <% end %>
    </svg>
    """
  end

  defp fill_color(base_color) do
    case hsl(base_color) do
      nil ->
        "none"

      {h, s, l} ->
        "hsla(#{h}, #{s}%, #{l}%)"
    end
  end

  defp hsl(base_color) do
    case base_color do
      :transparent -> nil
      :gray -> {0, 0, 20}
      :green -> {76, 100, 71}
      :blue -> {216, 100, 69}
      :yellow -> {46, 100, 68}
      :red -> {1, 100, 70}
      :purple -> {262, 100, 70}
      :pink -> {349, 100, 70}
      :dark_green -> {155, 90, 40}
      :dark_blue -> {216, 75, 49}
      :dark_yellow -> {46, 75, 48}
      :dark_red -> {1, 75, 50}
      :dark_purple -> {262, 75, 50}
      :dark_pink -> {349, 75, 50}
    end
  end
end

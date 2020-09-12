defmodule PixelSmashWeb.SpriteComponent do
  use PixelSmashWeb, :live_component

  def render(assigns) do
    ~L"""
    <svg
      style="width: 64px; height: 64px;"
      viewBox="1 1 <%= @sprite.x %> <%= @sprite.y %>"
      xmlns="http://www.w3.org/2000/svg"
      shape-rendering="crispEdges">
        <%= for {{x, y}, {base_color, tint}} <- @sprite.map do %>
          <rect
            x="<%= x %>"
            y="<%= y %>"
            width="1"
            height="1"
            fill="<%= fill_color(base_color) %>"
            fill-opacity="<%= 0.2 + abs((tint / 100.0) - 0.2) %>"
          />
        <% end %>
    </svg>
    """
  end

  defp fill_color(base_color) do
    {h, s, l} = hsl(base_color)
    "hsla(#{h}, #{s}%, #{l}%)"
  end

  defp hsl(base_color) do
    case base_color do
      :black -> {0, 0, 3}
      :green -> {76, 100, 71}
      :blue -> {216, 100, 69}
      :yellow -> {46, 100, 68}
      :red -> {1, 100, 70}
      :purple -> {262, 100, 70}
      :pink -> {349, 100, 70}
      :gray -> {0, 0, 50}
    end
  end
end

defmodule PixelSmashWeb.SpriteComponent do
  use PixelSmashWeb, :live_component

  def render(assigns) do
    ~L"""
    <svg viewBox="1 1 <%= @sprite.x %> <%= @sprite.y %>" xmlns="http://www.w3.org/2000/svg">
      <%= for {{x, y}, {base_color, tint}} <- @sprite.map do %>
        <rect x="<%= x %>" y="<%= y %>" width="1" height="1" fill="<%= fill_color(base_color) %>" fill-opacity="<%= 0.2 + abs((tint / 100.0) - 0.2) %>"/>
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
      :black -> {0, 0, 0}
      :green -> {120, 100, 25}
      :blue -> {240, 100, 50}
      :yellow -> {60, 100, 50}
      :red -> {0, 100, 50}
      :purple -> {300, 100, 25}
      :pink -> {350, 100, 88}
      :gray -> {0, 0, 50}
    end
  end
end

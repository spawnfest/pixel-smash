defmodule PixelSmashWeb.GridComponent do
  use PixelSmashWeb, :live_component

  def render(assigns) do
    ~L"""
    <svg viewBox="0 0 <%= @grid.x %> <%= @grid.y %>" xmlns="http://www.w3.org/2000/svg">
      <%= for {{x, y}, color} <- @grid.map do %>
        <rect x="<%= x %>" y="<%= y %>" width="1" height="1" fill="<%= fill_color(color) %>"/>
      <% end %>
    </svg>
    """
  end

  defp fill_color(:black), do: "black"
  defp fill_color(:green), do: "green"
  defp fill_color(:blue), do: "blue"
  defp fill_color(:yellow), do: "yellow"
  defp fill_color(:red), do: "red"
  defp fill_color(:purple), do: "purple"
  defp fill_color(:pink), do: "pink"
end

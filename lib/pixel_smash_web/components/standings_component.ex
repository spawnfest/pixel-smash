defmodule PixelSmashWeb.StandingsComponent do
  @moduledoc """
  Live Component for displaying the current standings
  Updates whenever a battle is completed with the current
  standing.
  """
  use PixelSmashWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
      <table class="bg-gray-900 rounded-lg table-auto mx-auto mb-4 text-gray-100">
        <tr>
          <th class="px-4 py-2">Name</th>
          <th class="px-4 py-2" phx-click="resort_standings">ELO</th>
          <th class="px-4 py-2">Wins</th>
          <th class="px-4 py-2">Losses</th>
          <th class="px-4 py-2">Draws</th>
        </tr>
        <%= for gladiator <- @gladiators do %>
          <tr>
            <td class="px-4 py-2"><%= gladiator.name %></td>
            <td class="px-4 py-2"><%= gladiator.elo %></td>
            <td class="px-4 py-2"><%= gladiator.wins %></td>
            <td class="px-4 py-2"><%= gladiator.losses %></td>
            <td class="px-4 py-2"><%= gladiator.draws %></td>
          </tr>
        <% end %>
      </table>
    """
  end

  @impl true
  def mount(socket) do
    {:ok, socket}
  end
end

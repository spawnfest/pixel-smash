defmodule PixelSmashWeb.GladiatorCardComponent do
  @moduledoc """
  Live Component for displaying more details about each of the gladiators.
  """
  use PixelSmashWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
      <table class="bg-gray-900 rounded-lg table-auto mb-4 text-gray-100 w-full">
        <tr>
          <th class="px-4 py-2">Icon</th>
          <th class="px-4 py-2">Name</th>
          <th class="px-4 py-2">ELO</th>
          <th class="px-4 py-2">Wins</th>
          <th class="px-4 py-2">Losses</th>
          <th class="px-4 py-2">Draws</th>
          <th class="px-4 py-2">Max Health</th>
          <th class="px-4 py-2">Defense</th>
          <th class="px-4 py-2">Strength</th>
          <th class="px-4 py-2">Speed</th>
          <th class="px-4 py-2">Magic</th>
          <th class="px-4 py-2">Spells</th>
        </tr>
        <tr>
          <td class="px-4 py-2"><%= live_component @socket, PixelSmashWeb.SpriteComponent, sprite: @gladiator.sprite %></td>
          <td class="px-4 py-2"><%= @gladiator.name %></td>
          <td class="px-4 py-2"><%= @gladiator.elo %></td>
          <td class="px-4 py-2"><%= @gladiator.wins %></td>
          <td class="px-4 py-2"><%= @gladiator.losses %></td>
          <td class="px-4 py-2"><%= @gladiator.draws %></td>
          <td class="px-4 py-2"><%= @gladiator.max_health %></td>
          <td class="px-4 py-2"><%= @gladiator.defense %></td>
          <td class="px-4 py-2"><%= @gladiator.strength %></td>
          <td class="px-4 py-2"><%= @gladiator.speed %></td>
          <td class="px-4 py-2"><%= @gladiator.magic %></td>
          <td class="px-4 py-2"><%= Enum.join(@gladiator.spells, " ") %></td>
        </tr>
      </table>
    """
  end
end

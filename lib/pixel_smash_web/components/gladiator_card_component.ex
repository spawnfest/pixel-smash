defmodule PixelSmashWeb.GladiatorCardComponent do
  @moduledoc """
  Live Component for displaying more details about each of the gladiators.
  Will apear as a modal, when the user clicks on the player icon in battle component
  sections.
  """
  use PixelSmashWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
      <table class="table-auto text-gray-100">
        <tr>
          <th>Icon</th>
          <th>Name</th>
          <th>ELO</th>
          <th>Wins</th>
          <th>Losses</th>
          <th>Draws</th>
          <th>Max Health</th>
          <th>Defense</th>
          <th>Strength</th>
          <th>Speed</th>
          <th>Magic</th>
          <th>Spells</th>
        </tr>
        <tr>
          <td><%= live_component @socket, PixelSmashWeb.SpriteComponent, sprite: @gladiator.sprite %></td>
          <td><%= @gladiator.name %></td>
          <td><%= @gladiator.elo %></td>
          <td><%= @gladiator.wins %></td>
          <td><%= @gladiator.losses %></td>
          <td><%= @gladiator.draws %></td>
          <td><%= @gladiator.max_health %></td>
          <td><%= @gladiator.defense %></td>
          <td><%= @gladiator.strength %></td>
          <td><%= @gladiator.speed %></td>
          <td><%= @gladiator.magic %></td>
          <td><%= Enum.join(@gladiator.spells, " ") %></td>
        </tr>
      </table>
    """
  end
end

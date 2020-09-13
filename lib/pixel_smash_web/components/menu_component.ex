defmodule PixelSmashWeb.MenuComponent do
  use PixelSmashWeb, :live_component

  def render(assigns) do
    ~L"""
    <div class="flex flex-grow flex-wrap mb-4 justify-evenly">
      <div class="flex flex-col bg-gray-900 rounded-lg m-4">
        <div class="flex flex-col items-start px-4 py-6 space-y-4">
          <div class="flex flex-grow items-start justify-center space-x-6">
            <h2 class="text-lg font-semibold text-white -mt-1">
              Balance:
            </h2>
            <small class="block text-sm text-gray-500">
              <%= Number.Currency.number_to_currency(@balance, precision: 0) %>
            </small>
            <%= link "Standings", to: Routes.standings_path(@socket, :index), class: "text-lg font-semibold text-white -mt-1" %>
            <%= link "Gladiators", to: Routes.gladiator_path(@socket, :index), class: "text-lg font-semibold text-white -mt-1" %>
            <%= link "The Store", to: Routes.the_store_path(@socket, :index), class: "text-lg font-semibold text-white -mt-1" %>
          </div>
        </div>
      </div>
    </div>
    """
  end

end

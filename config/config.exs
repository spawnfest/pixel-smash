# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :pixel_smash,
  ecto_repos: [PixelSmash.Repo]

# Configures the endpoint
config :pixel_smash, PixelSmashWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "HgNJVNLyZg8X0JFK0Xo41z+RHcmkoeLZFzkQ9crgSvj6q4CrB+ugu/OqDO6950t+",
  render_errors: [view: PixelSmashWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: PixelSmash.PubSub,
  live_view: [signing_salt: "gUVZ8VIP"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# for Postgres should be PixelSmash.Repo
config :pixel_smash, :repo, PixelSmash.MemoryRepo

config :money,
  default_currency: :USD,           # this allows you to do Money.new(100)
  separator: ".",                   # change the default thousands separator for Money.to_string
  delimiter: ",",                   # change the default decimal delimeter for Money.to_string
  symbol: true,                     # don’t display the currency symbol in Money.to_string
  symbol_on_right: false,           # position the symbol
  symbol_space: false,              # add a space between symbol and number
  fractional_unit: true,            # display units after the delimeter
  strip_insignificant_zeros: true   # don’t display the insignificant zeros or the delimeter

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

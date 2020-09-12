defmodule PixelSmash.Repo do
  use Ecto.Repo,
    otp_app: :pixel_smash,
    adapter: Ecto.Adapters.Postgres
end

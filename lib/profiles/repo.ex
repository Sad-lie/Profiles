defmodule Profiles.Repo do
  use Ecto.Repo,
    otp_app: :profiles,
    adapter: Ecto.Adapters.Postgres
end

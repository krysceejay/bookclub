defmodule Bookclub.Repo do
  use Ecto.Repo,
    otp_app: :bookclub,
    adapter: Ecto.Adapters.Postgres

    use Kerosene, per_page: 2
end

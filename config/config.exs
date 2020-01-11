# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :bookclub,
  ecto_repos: [Bookclub.Repo]

# Configures the endpoint
config :bookclub, BookclubWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "H9CwxZyfgKNTfO6AjpGbxlBkzvpx7xtZ21a/NI97D6E8t04Rg7ynXse09Tp0hFDr",
  render_errors: [view: BookclubWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Bookclub.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "gSEGYhbIVTYQLI/4kYs8wqlmlYMu0f5Q"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Guardian config
config :bookclub, Bookclub.Guardian,
  issuer: "bookclub",
  secret_key: "nVDzWwhYQRf3K8ZxY+OLv+Ogo4503s6hw9bzonRhafzDiVPhnOc/ON2nRboGwtWs"

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :phoenix, :template_engines, leex: Phoenix.LiveView.Engine

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

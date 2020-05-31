# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :shorty,
  ecto_repos: [Shorty.Repo]

# Configures the endpoint
config :shorty, ShortyWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "9ufWjd/GZ6hk09tc5oobHjURTHzmupKHnpyDgff+6DfbSpd6/OxSX4U0nHabmi1k",
  render_errors: [view: ShortyWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Shorty.PubSub,
  live_view: [signing_salt: "waejTsDQ"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :geoip, provider: :ipstack, api_key: System.get_env("IPSTACK_API_KEY"), use_https: false

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

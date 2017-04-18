# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :ssh_chat,
  ecto_repos: [SshChat.Repo]

# Configures the endpoint
config :ssh_chat, SshChat.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "nBiLTHjm8LVFVf0PFSgns0TDheA+X8u0Ze5KV6dGwxZMfdaUnRK7w1dOlqWZ+6cn",
  render_errors: [view: SshChat.Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: SshChat.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

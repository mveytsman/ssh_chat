use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :ssh_chat, SshChat.Web.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :ssh_chat, SshChat.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "ssh_chat_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# SSH Port to use
config :ssh_chat, port: 2222

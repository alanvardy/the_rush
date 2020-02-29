use Mix.Config

# We don't run a server during test, but we need it for systemtest!
config :the_rush, TheRushWeb.Endpoint,
  http: [port: 5000],
  server: true

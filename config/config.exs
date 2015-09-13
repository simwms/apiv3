# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :apiv3, Apiv3.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "Sf/gFdl9AfdXLJV+zyKYs7DOwOAy8N+YVSjNhFY29fMvyYB2Ox63M5a9ebN/5TF+",
  roxie_master_key: "furishikiru-ame-ni-mi-o-kakusu-you-ni-shite-odoru",
  render_errors: [default_format: "html"],
  pubsub: [name: Apiv3.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# master_key:  System.get_env("SIMWMS_MASTER_KEY")
config :simwms,
  master_key: "koudou ga yamu made soba ni iru nante tagaeru yakusoku ha sezu tada anata to itai"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

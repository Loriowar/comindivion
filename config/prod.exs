use Mix.Config

# For production, we configure the host to read the PORT
# from the system environment. Therefore, you will need
# to set PORT=80 before running your server.
#
# You should also configure the url host to something
# meaningful, we use this information when generating URLs.
#
# Finally, we also include the path to a manifest
# containing the digested version of static files. This
# manifest is generated by the mix phoenix.digest task
# which you typically run after static files are built.
config :comindivion, Comindivion.Endpoint,
  http: [ip: {127,0,0,1}, port: {:system, "PORT"}],
  url: [host: "localhost", port: {:system, "PORT"}],
  # TODO: make this option configurable, preferable in runtime
  check_origin: false,
  cache_static_manifest: "priv/static/cache_manifest.json",
  server: true,
  root: ".",
  version: Application.spec(:comindivion, :vsn)

# Do not print debug messages in production
config :logger, level: :info

# Fetch Google Analytics identifier from system environment
config :comindivion, ga_identifier: System.get_env("GA_IDENTIFIER")

config :comindivion, Comindivion.Endpoint,
       secret_key_base: System.get_env("ENDPOINT_SECRET_KEY_BASE")

config :guardian, Guardian,
       secret_key: System.get_env("GUADRIAN_SECRET_KEY_BASE")

# Configure your database
config :comindivion, Comindivion.Repo,
       adapter: Ecto.Adapters.Postgres,
       username: System.get_env("DB_USERNAME"),
       password: System.get_env("DB_PASSWORD"),
       database: System.get_env("DB_NAME"),
       hostname: System.get_env("DB_HOST"),
       size: 20 # The amount of database connections in the pool

# ## SSL Support
#
# To get SSL working, you will need to add the `https` key
# to the previous section and set your `:url` port to 443:
#
#     config :comindivion, Comindivion.Endpoint,
#       ...
#       url: [host: "example.com", port: 443],
#       https: [port: 443,
#               keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
#               certfile: System.get_env("SOME_APP_SSL_CERT_PATH")]
#
# Where those two env variables return an absolute path to
# the key and cert in disk or a relative path inside priv,
# for example "priv/ssl/server.key".
#
# We also recommend setting `force_ssl`, ensuring no data is
# ever sent via http, always redirecting to https:
#
#     config :comindivion, Comindivion.Endpoint,
#       force_ssl: [hsts: true]
#
# Check `Plug.SSL` for all available options in `force_ssl`.

# ## Using releases
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start the server for all endpoints:
#
#     config :phoenix, :serve_endpoints, true
#
# Alternatively, you can configure exactly which server to
# start per endpoint:
#
#     config :comindivion, Comindivion.Endpoint, server: true
#

# Finally import the config/prod.secret.exs
# which should be versioned separately.
#import_config "prod.secret.exs"

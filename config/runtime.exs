import Config

if System.get_env("PHX_SERVER") do
  config :openai_phoenix, OpenaiPhoenixWeb.Endpoint, server: true
end

if config_env() == :prod do
  if File.exists?(".env") do
    DotenvParser.load_file(".env")
  end

  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      Environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  host = System.get_env("RENDER_EXTERNAL_HOSTNAME") || "example.com"
  port = String.to_integer(System.get_env("PORT") || "4000")

  database_url =
    System.get_env("DATABASE_URL") ||
      raise "Environment variable DATABASE_URL is missing."

  config :openai_phoenix, OpenaiPhoenix.Repo,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
    ssl: true

  config :openai_phoenix, openai_api_key:
    System.get_env("OPENAI_API_KEY") ||
      raise "Environment variable OPENAI_API_KEY is missing."

  config :openai_phoenix, OpenaiPhoenixWeb.Endpoint,
    url: [host: host, port: 443, scheme: "https"],
    http: [
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: port
    ],
    secret_key_base: secret_key_base,
    force_ssl: [hsts: true]
end

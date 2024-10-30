import Config

config :discord_bot,
  ecto_repos: [DiscordBot.Repo],
  generators: [timestamp_type: :utc_datetime, binary_id: true],
  username: "postgres",
  password: "postgres",
  database: "discord-bot",
  hostname: "localhost"

config :nostrum,
  token: "<TOKEN>",
  ffmpeg: nil,
  gateway_intents: :all

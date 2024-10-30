import Config

config :discord_bot,
  ecto_repos: [DiscordBot.Repo],
  generators: [timestamp_type: :utc_datetime, binary_id: true],
  username: "postgres",
  password: "postgres",
  database: "discord-bot",
  hostname: "localhost"

config :nostrum,
  token: "MTI5NjI1MTYyNjUwMzQwNTY2Mw.GUrVaJ.XgODXwPkLspF3rYdlFL2kb4g4Nm3c_ugZaXuho",
  ffmpeg: nil,
  gateway_intents: :all

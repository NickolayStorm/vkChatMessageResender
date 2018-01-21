use Mix.Config

config :vk_conf_send, VkConfSend.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "botdata",
  username: "bot",
  password: "12345",
  hostname: "localhost"

# token: "e7898c5bda3698a452eddd60b31bc1e474c5accb4129fec0cc53827a9e74c954a526dd7b7d3db9827fb6f",

config :vk_conf_send,
  ecto_repos: [VkConfSend.Repo],
  recv_timeout: 5000



config :nadia,
  token: "212736927:AAEZ1N17UNwoMCNvBKAYy71JIJRsC8Xuecg",
  recv_timeout: 2

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env}.exs"

defmodule Storage.Supervisor do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(VkConfSend.Repo, [])
    ]

    opts = [strategy: :one_for_one, name: Storage.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

defmodule VkConfSender do
  def start do
    {:ok, _} = Agent.start_link(fn -> %{} end, name: :storage)
    {:ok, _} = Agent.start_link(fn -> TgActions.listen_loop self end, name: :tg)
    loop_
  end
  defp loop_ do
    receive do
      {:tg, :token, token} -> IO.puts "DA"

  end
end
end

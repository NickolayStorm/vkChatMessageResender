defmodule TgUpdates do
  def start_link pid,
                offset \\ 0,
                pause \\ Application.get_env(:vk_conf_send, :recv_timeout) do
    # IO.inspect Nadia.get_me
    spawn fn -> get_updates pid, offset, pause end
  end
  def get_updates pid, offset, pause do
    response = Nadia.get_updates [offset: offset]
    case response do
      {:ok, []}        ->
        loop_ pid, offset, pause
      {:ok, res}       ->
        new_offset = res
                   |> Enum.map(fn msg -> msg.update_id end)
                   |> Enum.max
                   |> Kernel.+(1)
        res |> Enum.each(fn msg -> send pid, msg.message end)
        loop_ pid, new_offset, pause
      {:error, reason} ->
        IO.inspect reason
        loop_ pid, offset, pause
      end
    end
   defp loop_ pid, offset, pause do
     Process.sleep(pause)
     get_updates pid, offset, pause
   end
end

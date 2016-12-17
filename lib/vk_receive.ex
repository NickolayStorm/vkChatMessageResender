defmodule VkStatic do
  def token do
    Application.get_env(:vk_conf_send, :token)
  end
  def recv_timeout do
    Application.get_env(:vk_conf_send, :recv_timeout)
  end
  def apiaddr do
    "https://api.vk.com/method/"
  end
end

defmodule UpdatesFromChat do
  def start_link pid, chats do
    pause = VkStatic.recv_timeout
    tses = VkRequest.get_ts
    spawn fn -> get_updates pid, chats, tses[:ts], tses[:pts], pause end
  end
  defp get_updates pid, chats, ts, pts, pause do
    response = VkRequest.get_updates ts, pts
    new_pts = response["new_pts"]
    # Send messages from needed multicharts
    response["messages"]
        |> Enum.filter(fn x -> !(is_integer x) end) # filter [0]
        |> Enum.filter(fn x ->
                          !is_nil(x["chat_id"]) end) # Multichats only
        |> Enum.filter(fn x -> Enum.member? chats, x["title"] end)
        |> Enum.each(fn x -> send pid, x end)
    loop pid, chats, ts, new_pts, pause
  end
  defp loop pid, chats, ts, pts, pause do
     Process.sleep(pause)
     get_updates pid, chats, ts, pts, pause
  end
end

defmodule Looper do
  def listen_loop do
    pid = UpdatesFromChat.start_link self, ["Testable"]
    listen_loop_ pid
  end
  defp listen_loop_ pid do
    receive do
      msg ->
        IO.inspect msg
        listen_loop_ pid
        # Process.exit pid, :normal
    end
  end
end
Looper.listen_loop

#
# defmodule VkConfSend do
#   def start do
#
#   end
# end

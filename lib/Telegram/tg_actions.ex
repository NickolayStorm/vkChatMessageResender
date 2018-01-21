defmodule TgActions do
  def listen_loop _pid do
    # my_tg_chat_id = 138018444
    # Nadia.send_message my_tg_chat_id, "123"
    # IO.inspect Nadia.get_me
    # is TODO
    # Now is is just map like
    # %{tg_chat -> [vk_token: token, chats: [1,2,3]]}
    # {:ok} = Agent.start_link(fn -> %{} end)
    its = self
    spawn_link(fn -> TgUpdates.start_link its end)
    listen_loop_
  end
  def listen_loop_ do
    receive do
      msg ->
        # IO.inspect msg
        parse_commands msg
        listen_loop_
        # IO.inspect Nadia.send_message msg.chat.id, msg.text
    end
  end
  defp parse_commands msg do
    text = msg.text
    condition = fn pref -> String.starts_with?(text, pref) end
    cond do
      condition.("/get_auth_token") -> get_token msg
      condition.("/set_token") -> set_vk_token msg
      condition.("/add_chat") -> add_vk_chat msg
      condition.("/subscripted_chats") -> list_vk_chats msg
      condition.("/remove_chat") -> rm_vk_chat msg
      condition.("/start") -> start msg
      condition.("/stop") -> stop msg
      :true -> Nadia.send_message msg.chat.id, "> " <> msg.text
    end
  end
  defp get_args text do
    words = text
           |> String.split(" ")
           |> tl
    IO.inspect words
    words
  end
  # Actions (like /start)
  defp get_token msg do
    link = "https://oauth.vk.com/authorize?client_id=5344498&display=page&scope=messages&response_type=token&v=5.45"
    Nadia.send_message msg.chat.id, "To get vk token please go to " <> link
  end
  defp set_vk_token msg do
    key = msg.chat.id
    args = get_args msg.text
    IO.inspect args
    if length(args) != 1 do
      Nadia.send_message key, "What do you talking about?"
    else
      old = get_data key
      new = [charts: old[:chats]] ++ [token: hd(args)]
      IO.inspect new
      update_data key, new
      Nadia.send_message key, "Token was sucsessfully updated"
    end
  end
  defp list_vk_chats msg do
    key = msg.chat.id
    data = get_data key
    text = data[:chats]
          |> Enum.map(fn w -> "\"" <> w <> "\"" end)
          |> Enum.join(",\n")
          |> (&(if is_nil(String.first &1), do: "Empty", else: &1)).()
    Nadia.send_message key, text
  end
  defp add_vk_chat msg do
    key = msg.chat.id
    args = get_args msg.text
    if length(args) < 1 do
      Nadia.send_message key, "Please send /add_chat <chat name>"
    else
      old = get_data key
      chats = old[:chats] || []
      new_chats = chats ++ args |> Enum.uniq
      new = [token: old[:token]] ++ [chats: new_chats]
      IO.inspect new
      update_data key, new
      Nadia.send_message key, "Token was sucsessfully updated"
    end
  end
  defp rm_vk_chat _msg do
  end
  defp start msg do
    _key = msg.chat.id
    _text = msg.text
    # Nadia.send_message msg.chat.id, "You still have not token"
  end
  defp stop _msg do
    Process.exit self, :kill
  end
  # funcs
  defp add_key key, data do
    Agent.update(pid, fn map -> Map.put(map, key, data) end)
  end
  defp update_data key, data do
    Agent.update(:storage, fn map -> Map.put(map, key, data) end)
  end
  defp get_data key do
    Agent.get(:storage, fn map -> Map.get(map, key) end)
  end
end
# spawn_link fn -> TgActions.listen_loop end

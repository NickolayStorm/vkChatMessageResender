defmodule VkRequest do
  use HTTPoison.Base
  def request type, cmd do
    start
    response = request! type, cmd
    response.body
  end
  def process_url(cmd) do
    VkStatic.apiaddr <> cmd
  end

  def process_response_body body do
    body |> Poison.decode!
  end

  def get_updates ts, pts, token do
    res = request :get, "messages.getLongPollHistory?" <>
                      "ts="  <> Integer.to_string(ts)  <>
                      "&pts="<> Integer.to_string(pts) <>
                      "&access_token=" <> token
    res["response"]
  end
  def get_ts do
    response = request :get, "messages.getLongPollServer?&need_pts=1"
    data = response["response"]
    [ts: data["ts"], pts: data["pts"]]
  end

end

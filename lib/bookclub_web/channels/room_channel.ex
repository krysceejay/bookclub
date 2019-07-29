defmodule BookclubWeb.RoomChannel do
  use BookclubWeb, :channel

  def join(channel_name, _params, socket) do
    {:ok, %{channel: channel_name}, socket}
  end

  # handles any other subtopic as the room ID, for example `"room:12"`, `"room:34"`
# def join("room:" <> room_id, _payload, socket) do
#   {:ok, socket}
# end

end

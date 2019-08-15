defmodule BookclubWeb.ChatController do
  use BookclubWeb, :controller

  def index(conn, _params) do
    Phoenix.LiveView.Controller.live_render(
    conn,
    BookclubWeb.Live.Index,
    session: %{}
    )
  end
end

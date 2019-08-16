defmodule BookclubWeb.ChatController do
  use BookclubWeb, :controller

  def index(conn, _params) do
    Phoenix.LiveView.Controller.live_render(
    conn,
    BookclubWeb.Live.Index,
    session: %{current_user: conn.assigns.user}
    )
  end
end

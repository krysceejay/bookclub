defmodule BookclubWeb.ChatController do
  use BookclubWeb, :controller
  alias Bookclub.Content

  plug BookclubWeb.Plugs.RequireAuth

  def index(conn, %{"slug" => slug}) do
    book = Content.get_book_by_slug!(slug)

    Phoenix.LiveView.Controller.live_render(
    conn,
    BookclubWeb.Live.Index,
    session: %{book: book, current_user: conn.assigns.user}
    )
  end
end

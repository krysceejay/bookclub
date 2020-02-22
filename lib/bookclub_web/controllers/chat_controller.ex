defmodule BookclubWeb.ChatController do
  use BookclubWeb, :controller
  alias Bookclub.Content

  plug BookclubWeb.Plugs.RequireAuth

  def index(conn, %{"slug" => slug}) do
    book = Content.get_book_by_slug_with_t!(slug)

    # IO.puts "+++++++++++++++"
    # IO.inspect book
    # IO.puts "+++++++++++++++"

    if Content.check_reader_status(conn.assigns.user.id, book.id) do
      Phoenix.LiveView.Controller.live_render(
      conn,
      BookclubWeb.Live.Index,
      session: %{"book" => book, "current_user" => conn.assigns.user}
      )
    else
      conn
      |> put_flash(:info, "You have to join discussion.")
      |> redirect(to: Routes.home_path(conn, :book, book))
    end


  end
end

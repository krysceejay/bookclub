defmodule BookclubWeb.HomeController do
  use BookclubWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def books(conn, _params) do
    # books = Content.list_books()
    render(conn, "books.html")
  end

end

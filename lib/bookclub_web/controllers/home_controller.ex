defmodule BookclubWeb.HomeController do
  use BookclubWeb, :controller

  alias Bookclub.Content

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def books(conn, _params) do
    books = Content.list_books()
    render(conn, "books.html", books: books)
  end

  def book(conn, %{"id" => id}) do
    book = Content.get_book!(id)
    render(conn, "book.html", book: book)
  end

end

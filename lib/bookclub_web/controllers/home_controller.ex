defmodule BookclubWeb.HomeController do
  use BookclubWeb, :controller

  alias Bookclub.Content
  alias BookclubWeb.Pagination

  def index(conn, _params) do
    top_books = Content.list_books()
    [first, second | rest_books] = top_books
    IO.puts "00000000000000"
    IO.inspect rest_books
    IO.puts "00000000000000"

    [third, fourth | others] = rest_books

    render(conn, "index.html", first: first, second: second, third: third, fourth: fourth)
  end

  def books(conn, params) do
    {page, ""} = Integer.parse(params["page"] || "1")

    bookquery = Content.all_books |> Pagination.paginate(6, page)
    num_links = bookquery.number_of_links
    books = bookquery.page

    render(conn, "books.html", books: books, page: page, num_links: num_links)
  end

  def book(conn, %{"slug" => slug}) do
    book = Content.get_book_by_slug!(slug)
    render(conn, "book.html", book: book)
  end

end

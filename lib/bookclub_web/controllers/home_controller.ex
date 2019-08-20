defmodule BookclubWeb.HomeController do
  use BookclubWeb, :controller

  alias Bookclub.Content

  def index(conn, _params) do
    top_books = Content.list_books()
    [first, second | rest_books] = top_books

    [third, fourth | others] = rest_books

    render(conn, "index.html", first: first, second: second, third: third, fourth: fourth)
  end

  def books(conn, _params) do
    page = 1
    per_page = 1
    total_books = Content.count_all_books()
    num_links = number_of_links(total_books, per_page)
    books = Content.list_books_page(page, per_page)

    render(conn, "books.html", books: books, page: page, num_links: num_links)
  end

  def book(conn, %{"id" => id}) do
    book = Content.get_book!(id)
    render(conn, "book.html", book: book)
  end

  def bookpage(conn, %{"page" => page_num}) do
    {page, ""} = Integer.parse(page_num || "1")
    per_page = 1
    total_books = Content.count_all_books()
    num_links = number_of_links(total_books, per_page)
    books = Content.list_books_page(page, per_page)

    render(conn, "books.html", books: books, page: page, num_links: num_links)
  end

  defp number_of_links(t, pp) do
    links_div = div(t, pp)
    num_links_rems = rem(t, pp)
    if num_links_rems == 0 do
      links_div
    else
      links_div + 1
    end
  end

end

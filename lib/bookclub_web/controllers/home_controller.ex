defmodule BookclubWeb.HomeController do
  use BookclubWeb, :controller

  alias Bookclub.Content
  alias BookclubWeb.Pagination

  def index(conn, _params) do

    top_rated = Content.top_books(5)

    render(conn, "index.html", top_rated: top_rated)
  end

  def books(conn, params) do
    genres = Content.list_genres()
    {page, ""} = Integer.parse(params["page"] || "1")

    {books, num_links} =
      Content.all_books
      |> Pagination.paginate(10, page)

    render(conn, "books.html", books: books, num_links: num_links, genres: genres)

    # {books, paginate} =
    #   Book
    #   |> Content.all_books
    #   |> Repo.paginate(params, per_page: 1)
    #
    #   render(conn, "books.html", books: books, paginate: paginate)
  end

  def book(conn, %{"slug" => slug}) do
    book = Content.get_book_by_slug!(slug)
    render(conn, "book.html", book: book)
  end

  def searchbooks(conn, %{"book-genre" => genre , "searchbooks" => textsearch}) do

    conn = conn |> put_session(:genre, genre) |> put_session(:textsearch, textsearch)

    genres = Content.list_genres()
    page = 1

    {books, num_links} =
      Content.search_books_by_genre(genre)
      |> Pagination.paginate(2, page)

    render(conn, "books.html", books: books, num_links: num_links, genres: genres)

  end

  def searchbooks(conn, %{"page" => pagenum}) do
    IO.puts "++++++++++++"
    IO.inspect conn
    IO.puts "++++++++++++"

    gen = get_session(conn, :genre)

    genres = Content.list_genres()
    {page, ""} = Integer.parse(pagenum || "1")

    {books, num_links} =
      Content.search_books_by_genre(gen)
      |> Pagination.paginate(2, page)

    render(conn, "books.html", books: books, num_links: num_links, genres: genres)

  end

end

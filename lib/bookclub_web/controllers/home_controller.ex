defmodule BookclubWeb.HomeController do
  use BookclubWeb, :controller
  alias Bookclub.Repo
  alias Bookclub.Content
  alias BookclubWeb.Pagination
  alias Bookclub.Content.Rating
  alias Bookclub.Aggregate

  plug BookclubWeb.Plugs.RequireAuth when action in [:createrating]

  def index(conn, _params) do
    top_rated = Content.top_books(5)

    render(conn, "index.html", top_rated: top_rated)
  end

  def books(conn, _params) do

    genres = Content.list_genres()

    {books, num_links} =
      Content.all_books()
      |> Pagination.paginate(30, conn)

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
    changeset = Content.change_rating(%Rating{})

    column_sum = Content.get_ratings_by_book(book.id) |> Aggregate.sum_column(:rating)
    column_count = Content.get_ratings_by_book(book.id) |> Aggregate.count_column(:rating)

    rating_sum =
          case column_sum do
            nil -> 5
            _ -> 5 + column_sum
          end
    rating_count =
          case column_count do
            0 -> 1
            _ -> 1 + column_count
          end

    star_rating = rating_sum / rating_count

    IO.puts "cccccccccccccc"
    IO.inspect star_rating
    IO.puts "ccccccccccccc"

    reader =
      case conn.assigns[:user] do
        nil -> false
        _ -> Content.check_if_reader_exist(conn.assigns.user.id, book.id)
      end

    render(conn, "book.html", book: book, reader: reader, changeset: changeset, star_rating: star_rating, rating_count: rating_count)

  end

  def searchbooks(conn, %{"book-genre" => genre, "searchbooks" => textsearch}) do
    params = %{"book-genre" => genre, "searchbooks" => textsearch}

    conn = conn |> put_session(:genre, genre) |> put_session(:textsearch, textsearch)

    genres = Content.list_genres()

    case params do
      %{"book-genre" => "", "searchbooks" => ""} ->
        {books, num_links} = Content.all_books() |> Pagination.paginate(30, conn)
        render(conn, "books.html", books: books, num_links: num_links, genres: genres)

      _ ->
        {books, num_links} =
          Content.search_books_by_fields(genre, textsearch) |> Pagination.paginate(30, conn)

        render(conn, "books.html", books: books, num_links: num_links, genres: genres)
    end
  end

  def searchbooks(conn, _params) do
    paramt = %{gen: get_session(conn, :genre), txtsearch: get_session(conn, :textsearch)}

    genres = Content.list_genres()

    case paramt do
      %{gen: "", txtsearch: ""} ->
        {books, num_links} = Content.all_books() |> Pagination.paginate(30, conn)
        render(conn, "books.html", books: books, num_links: num_links, genres: genres)

      _ ->
        {books, num_links} =
          Content.search_books_by_fields(paramt.gen, paramt.txtsearch)
          |> Pagination.paginate(30, conn)

        render(conn, "books.html", books: books, num_links: num_links, genres: genres)
    end
  end

  def contact(conn, _params) do
    render(conn, "contact.html")
  end

  def createrating(conn, %{"rating" => rating_params}) do
    %{"book_id" => book_id} = rating_params

    book = Content.get_only_book!(book_id)
    reader = Content.check_if_reader_exist(conn.assigns.user.id, book.id)

    case Content.create_rating(conn.assigns.user, rating_params) do
      {:ok, _rating} ->
        conn
        |> put_flash(:info, "Book rated Successfully.")
        |> redirect(to: Routes.home_path(conn, :book, book))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "book.html", changeset: changeset, book: book, reader: reader)
    end
  end

end

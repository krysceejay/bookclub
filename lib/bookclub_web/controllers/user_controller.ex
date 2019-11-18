defmodule BookclubWeb.UserController do
  use BookclubWeb, :controller

  alias Bookclub.Content
  alias Bookclub.Content.Book
  alias BookclubWeb.Pagination
  alias Bookclub.Repo

  plug BookclubWeb.Plugs.RequireAuth

  def index(conn, _params) do
    render(conn, "dashboard.html")
  end

  def managebooks(conn, params) do
    {page, ""} = Integer.parse(params["page"] || "1")
    book_count = Content.book_by_user(conn.assigns.user.id) |> Pagination.count_query

    {books, num_links} =
      Content.book_by_user(conn.assigns.user.id)
      |> Pagination.paginate(30, page)

    render(conn, "managebooks.html", books: books, book_count: book_count, num_links: num_links)
  end

  def addbook(conn, _params) do
    genre = Content.list_genres()
    book = %Book{}
    changeset = Content.change_book(book)
    render(conn, "addbook.html", changeset: changeset, book: book, genre: genre)
  end

  def createbook(conn, %{"book" => book_params}) do
    # IO.puts "+++++++++++++++"
    # IO.inspect book_params
    # IO.puts "+++++++++++++++"
    genre = Content.list_genres()
    book = %Book{}

    case Content.create_book(conn.assigns.user, book_params) do
      {:ok, _book} ->
        conn
        |> put_flash(:info, "Book added successfully.")
        |> redirect(to: Routes.user_path(conn, :managebooks))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "addbook.html", changeset: changeset, book: book, genre: genre)
    end
  end

  def editbook(conn, %{"slug" => slug}) do
    genre = Content.list_genres()
    book = Content.get_book_by_slug!(slug)
    changeset = Content.change_book(book)

    render(conn, "editbook.html", book: book, changeset: changeset, genre: genre)
  end

  def updatebook(conn, %{"slug" => slug, "book" => book_params}) do
    book = Content.get_book_by_slug!(slug)
    genre = Content.list_genres()

    case Content.update_book(book, book_params, book.id) do
      {:ok, _book} ->
        conn
        |> put_flash(:info, "Book updated successfully.")
        |> redirect(to: Routes.user_path(conn, :managebooks))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "editbook.html", book: book, changeset: changeset, genre: genre)
    end
  end

  def bookreaders(conn, params) do
    %{"slug" => slug} = params
    book = Content.get_book_by_slug!(slug)
    readers_count = Content.get_readers_by_book(book.id) |> Pagination.count_query
    {page, ""} = Integer.parse(params["page"] || "1")

    {readers, num_links} =
      Content.get_readers_by_book(book.id)
      |> Pagination.paginate(30, page)

    render(conn, "book_readers.html", readers: readers, num_links: num_links, readers_count: readers_count)
  end

  def joinreaders(conn, %{"slug" => slug}) do
    book = Content.get_book_by_slug!(slug)

    if Content.check_if_reader_exist(conn.assigns.user.id, book.id) != [] do
      conn
      |> put_flash(:info, "You have already joined.")
      |> redirect(to: Routes.home_path(conn, :book, book))

    else
      case Content.create_reader(conn.assigns.user, book) do
        {:ok, _reader} ->
          conn
          |> put_flash(:info, "Joined successfully.")
          |> redirect(to: Routes.home_path(conn, :book, book))

        {:error, _reason} ->
          conn
          |> put_flash(:info, "Join not successfull.")
          |> redirect(to: Routes.home_path(conn, :book, book))
      end
    end

  end


end

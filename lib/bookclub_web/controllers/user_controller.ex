defmodule BookclubWeb.UserController do
  use BookclubWeb, :controller

  alias Bookclub.Content
  alias Bookclub.Content.Book

  plug BookclubWeb.Plugs.RequireAuth

  def index(conn, _params) do
    render(conn, "dashboard.html")
  end

  def addbook(conn, _params) do
    genre = Content.list_genres()
    book = %Book{}
    changeset = Content.change_book(book)
    render(conn, "addbook.html", changeset: changeset, book: book, genre: genre)
  end

  def createbook(conn, %{"book" => book_params}) do
    genre = Content.list_genres()
    book = %Book{}
    case Content.create_book(conn.assigns.user, book_params) do
      {:ok, _book} ->
        conn
        |> put_flash(:info, "Book added successfully.")
        |> redirect(to: Routes.user_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "addbook.html", changeset: changeset, book: book,genre: genre)
    end
  end

  def editbook(conn, %{"id" => id}) do
    genre = Content.list_genres()
    book = Content.get_book!(id)
    changeset = Content.change_book(book)

    render(conn, "editbook.html", book: book, changeset: changeset, genre: genre)
  end

  def updatebook(conn, %{"id" => id, "book" => book_params}) do
    book = Content.get_book!(id)
    genre = Content.list_genres()

    case Content.update_book(book, book_params) do
      {:ok, _book} ->
        conn
        |> put_flash(:info, "Book updated successfully.")
        |> redirect(to: Routes.user_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "editbook.html", book: book, changeset: changeset, genre: genre)
    end
  end

end

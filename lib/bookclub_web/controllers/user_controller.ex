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
    changeset = Content.change_book(%Book{})
    render(conn, "addbook.html", changeset: changeset, genre: genre)
  end

  def createbook(conn, %{"book" => book_params}) do

    case Content.create_book(conn.assigns.user, book_params) do
      {:ok, _book} ->
        conn
        |> put_flash(:info, "Book added successfully.")
        |> redirect(to: Routes.user_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "addbook.html", changeset: changeset)
    end
  end

end

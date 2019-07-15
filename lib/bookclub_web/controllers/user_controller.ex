defmodule BookclubWeb.UserController do
  use BookclubWeb, :controller

  alias Bookclub.Accounts
  alias Bookclub.Accounts.User
  #alias Bookclub.Accounts.Auth
  alias Bookclub.Content
  alias Bookclub.Content.Book

  def dashboard(conn, _params) do
    render(conn, "dashboard.html")
  end

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end

  def showLoginForm(conn, _params) do
    render conn, "login.html", layout: {BookclubWeb.LayoutView, "auth.html"}
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: Routes.login_path(conn, :new))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, layout: {BookclubWeb.LayoutView, "auth.html"})
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    changeset = Accounts.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    {:ok, _user} = Accounts.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: Routes.user_path(conn, :index))
  end

    def dashboard(conn, _params) do
      # IO.inspect user
      render(conn, "dashboard.html")
    end

    def indexbook(conn, _params) do
      books = Content.list_books()
      render(conn, "managebooks.html", books: books)
    end

    def newbook(conn, _params) do
      changeset = Content.change_book(%Book{})
      render(conn, "addbook.html", changeset: changeset)
    end

    def createbook(conn, %{"book" => book_params}) do
      changeset = Auth.current_user(conn) |> Ecto.build_assoc(:books)

      case Content.create_book(changeset, book_params) do
        {:ok, book} ->
          conn
          |> put_flash(:info, "Book created successfully.")
          |> redirect(to: Routes.user_path(conn, :showbook, book))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "addbook.html", changeset: changeset)
      end
    end

    def showbook(conn, %{"id" => id}) do
      book = Content.get_book!(id)
      render(conn, "showbook.html", book: book)
    end

    def editbook(conn, %{"id" => id}) do
      book = Content.get_book!(id)
      changeset = Content.change_book(book)
      render(conn, "editbook.html", book: book, changeset: changeset)
    end

    def updatebook(conn, %{"id" => id, "book" => book_params}) do
      book = Content.get_book!(id)

      case Content.update_book(book, book_params) do
        {:ok, book} ->
          conn
          |> put_flash(:info, "Book updated successfully.")
          |> redirect(to: Routes.user_path(conn, :showbook, book))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "editbook.html", book: book, changeset: changeset)
      end
    end
end

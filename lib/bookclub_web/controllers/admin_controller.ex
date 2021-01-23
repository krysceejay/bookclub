defmodule BookclubWeb.AdminController do
  use BookclubWeb, :controller

  alias Bookclub.{Accounts, Content, Features}
  alias Bookclub.Content.{Genre, FeaturedBook}
  alias Bookclub.Features.Bookstore

  plug BookclubWeb.Plugs.RequireAuth

  plug BookclubWeb.Plugs.AdminAuth

  def dashboard(conn, _params) do

    render(conn, "dashboard.html")
  end

  def users(conn, _params) do
    users = Accounts.list_users()
    render(conn, "users.html", users: users)
  end

  def user(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "user.html", user: user)
  end

  def books(conn, _params) do
    books = Content.list_books()
    render(conn, "books.html", books: books)
  end

  def book(conn, %{"id" => id}) do
    book = Content.get_book!(id)
    render(conn, "user.html", book: book)
  end

  def genres(conn, _params) do
    genres = Content.list_genres()
    render(conn, "genres.html", genres: genres)
  end

  def addgenre(conn, _params) do
    changeset = Content.change_genre(%Genre{})
    render(conn, "addgenre.html", changeset: changeset)
  end

  def creategenre(conn, %{"genre" => genre_params}) do
      case Content.create_genre(genre_params) do
        {:ok, _genre} ->
          conn
          |> put_flash(:info, "Genre created successfully.")
          |> redirect(to: Routes.admin_path(conn, :genres))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "addgenre.html", changeset: changeset)
      end
  end

  def featbooks(conn, _params) do
    feat_books = Content.list_featured_books()
    render(conn, "feat_books.html", feat_books: feat_books)
  end

  def addfeaturebook(conn, _params) do
    book = %FeaturedBook{}
    changeset = Content.change_featured_book(book)
    render(conn, "addfeaturebook.html", changeset: changeset, book: book)
  end

  def createfeatbook(conn, %{"featured_book" => book_params}) do
    book = %FeaturedBook{}
    case Content.create_featured_book(book_params) do
      {:ok, _book} ->
        conn
        |> put_flash(:info, "Book added successfully.")
        |> redirect(to: Routes.admin_path(conn, :featbooks))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "addfeaturebook.html", changeset: changeset, book: book)
    end

  end

  def bookstore(conn, _params) do
    bookstore = Features.list_bookstores()
    render(conn, "bookstore.html", bookstore: bookstore)
  end

  def addbookstore(conn, _params) do
    store = %Bookstore{}
    changeset = Features.change_bookstore(store)
    render(conn, "addbookstore.html", changeset: changeset, store: store)
  end

  def createbookstore(conn, %{"bookstore" => store_params}) do

    store = %Bookstore{}
    case Features.create_bookstore(store_params) do
      {:ok, _book} ->
        conn
        |> put_flash(:info, "Store added successfully.")
        |> redirect(to: Routes.admin_path(conn, :bookstore))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "addbookstore.html", changeset: changeset, store: store)
    end


  end




  # def create(conn, %{"user" => user_params}) do
  #   case Accounts.create_user(user_params) do
  #     {:ok, _user} ->
  #       conn
  #       |> put_flash(:info, "User created successfully.")
  #       |> redirect(to: Routes.login_path(conn, :new))
  #
  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       render(conn, "new.html", changeset: changeset, layout: {BookclubWeb.LayoutView, "auth.html"})
  #   end
  # end
  #

  #
  # def edit(conn, %{"id" => id}) do
  #   user = Accounts.get_user!(id)
  #   changeset = Accounts.change_user(user)
  #   render(conn, "edit.html", user: user, changeset: changeset)
  # end
  #
  # def update(conn, %{"id" => id, "user" => user_params}) do
  #   user = Accounts.get_user!(id)
  #
  #   case Accounts.update_user(user, user_params) do
  #     {:ok, user} ->
  #       conn
  #       |> put_flash(:info, "User updated successfully.")
  #       |> redirect(to: Routes.user_path(conn, :show, user))
  #
  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       render(conn, "edit.html", user: user, changeset: changeset)
  #   end
  # end
  #
  # def delete(conn, %{"id" => id}) do
  #   user = Accounts.get_user!(id)
  #   {:ok, _user} = Accounts.delete_user(user)
  #
  #   conn
  #   |> put_flash(:info, "User deleted successfully.")
  #   |> redirect(to: Routes.user_path(conn, :index))
  # end
  #
  #   def dashboard(conn, _params) do
  #     # IO.inspect user
  #     render(conn, "dashboard.html")
  #   end
  #
  #   def indexbook(conn, _params) do
  #     books = Content.list_books()
  #     render(conn, "managebooks.html", books: books)
  #   end
  #
  #   def newbook(conn, _params) do
  #     changeset = Content.change_book(%Book{})
  #     render(conn, "addbook.html", changeset: changeset)
  #   end
  #
  #   def createbook(conn, %{"book" => book_params}) do
  #     changeset = Auth.current_user(conn) |> Ecto.build_assoc(:books)
  #
  #     case Content.create_book(changeset, book_params) do
  #       {:ok, book} ->
  #         conn
  #         |> put_flash(:info, "Book created successfully.")
  #         |> redirect(to: Routes.user_path(conn, :showbook, book))
  #
  #       {:error, %Ecto.Changeset{} = changeset} ->
  #         render(conn, "addbook.html", changeset: changeset)
  #     end
  #   end
  #
  #   def showbook(conn, %{"id" => id}) do
  #     book = Content.get_book!(id)
  #     render(conn, "showbook.html", book: book)
  #   end
  #
  #   def editbook(conn, %{"id" => id}) do
  #     book = Content.get_book!(id)
  #     changeset = Content.change_book(book)
  #     render(conn, "editbook.html", book: book, changeset: changeset)
  #   end
  #
  #   def updatebook(conn, %{"id" => id, "book" => book_params}) do
  #     book = Content.get_book!(id)
  #
  #     case Content.update_book(book, book_params) do
  #       {:ok, book} ->
  #         conn
  #         |> put_flash(:info, "Book updated successfully.")
  #         |> redirect(to: Routes.user_path(conn, :showbook, book))
  #
  #       {:error, %Ecto.Changeset{} = changeset} ->
  #         render(conn, "editbook.html", book: book, changeset: changeset)
  #     end
  #   end
end

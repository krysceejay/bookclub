defmodule BookclubWeb.UserController do
  use BookclubWeb, :controller

  alias Bookclub.Accounts
  alias Bookclub.Content
  alias Bookclub.Content.Book
  alias BookclubWeb.Pagination

  plug BookclubWeb.Plugs.RequireAuth

  def index(conn, _params) do
    render(conn, "dashboard.html")
  end

  def managebooks(conn, _params) do
    book_count = Content.book_by_user(conn.assigns.user.id) |> Pagination.count_query

    {books, num_links} =
      Content.book_by_user(conn.assigns.user.id)
      |> Pagination.paginate(30, conn)

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

    case Content.update_book(book, book_params) do
      {:ok, _book} ->
        conn
        |> put_flash(:info, "Book updated successfully.")
        |> redirect(to: Routes.user_path(conn, :managebooks))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "editbook.html", book: book, changeset: changeset, genre: genre)
    end
  end

  def bookreaders(conn, %{"slug" => slug}) do
    # %{"slug" => slug} = params
    book = Content.get_book_by_slug!(slug)
    readers_count = Content.get_readers_by_book(book.id) |> Pagination.count_query

    {readers, num_links} =
      Content.get_readers_by_book(book.id)
      |> Pagination.paginate(30, conn)

    render(conn, "book_readers.html", readers: readers, num_links: num_links, readers_count: readers_count)
  end

  def joinreaders(conn, %{"slug" => slug}) do
    book = Content.get_book_by_slug!(slug)

    if Content.check_if_reader_exist(conn.assigns.user.id, book.id) do
      conn
      |> put_flash(:info, "You have already joined.")
      |> redirect(to: Routes.home_path(conn, :book, book))

    else
      if book.public == true do
        case Content.create_reader(conn.assigns.user, book) do
          {:ok, _reader} ->
            conn
            |> put_flash(:info, "Joined successfully.")
            |> redirect(to: Routes.home_path(conn, :book, book))

          {:error, _reason} ->
            conn
            |> put_flash(:info, "Join not successful.")
            |> redirect(to: Routes.home_path(conn, :book, book))
        end
      else
        case Content.create_readerp(conn.assigns.user, book) do
          {:ok, _reader} ->
            conn
            |> put_flash(:info, "The owner of this private book club has been notified. Please wait for approval. Thanks.")
            |> redirect(to: Routes.home_path(conn, :book, book))

          {:error, _reason} ->
            conn
            |> put_flash(:info, "Action not successful. Please check your connection.")
            |> redirect(to: Routes.home_path(conn, :book, book))
        end
      end

    end

  end


  def profile(conn, %{"name" => name}) do

    userprof = Accounts.get_user_by_username(name)
      case userprof do
        nil -> render(conn, BookclubWeb.HomeView, "notfound.html")
        _ -> render(conn, "profile.html", userprof: userprof)
      end

  end

  def editprofile(conn, _params) do

    changeset = Accounts.change_user(conn.assigns.user)
    render(conn, "editprofile.html", changeset: changeset)

  end

  def updateprofile(conn, %{"user" => user_params}) do

      case Accounts.update_user_slim(conn.assigns.user, user_params) do
        {:ok, _user} ->
          conn
          |> put_flash(:info, "Profile updated successfully.")
          |> redirect(to: Routes.user_path(conn, :profile, conn.assigns.user.username))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "editprofile.html", changeset: changeset)
      end


  end

  def joinedlist(conn, _params) do
    book_count = Content.get_reader_joined_list(conn.assigns.user.id) |> Pagination.count_query

    {readers, num_links} =
      Content.get_reader_joined_list(conn.assigns.user.id)
      |> Pagination.paginate(30, conn)

     render(conn, "joinedlist.html", readers: readers, book_count: book_count, num_links: num_links)
  end

  def undojoin(conn, %{"slug" => slug}) do
    book = Content.get_book_by_slug!(slug)
    Content.get_reader_by_book_user(conn.assigns.user.id, book.id) |> Content.delete_reader

    conn
    |> put_flash(:info, "Undo join successful")
    |> redirect(to: Routes.user_path(conn, :joinedlist))

  end

  def readerstatus(conn, %{"name" => name}) do
    {:ok, decode} = Base.decode64(name)
    reader = Content.get_reader_with_book!(decode)
    
    attr =
      case reader.status do
        false -> %{status: true}
        true -> %{status: false}
      end

    case Content.update_reader_status(reader, attr) do
      {:ok, _reader} ->
        conn
        |> put_flash(:info, "Status updated successfully.")
        |> redirect(to: Routes.user_path(conn, :bookreaders, reader.book))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:info, "Status update not successful.")
        |> redirect(to: Routes.user_path(conn, :bookreaders, reader.book))
    end

  end

end

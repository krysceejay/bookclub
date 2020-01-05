defmodule BookclubWeb.UserController do
  use BookclubWeb, :controller

  alias Bookclub.Accounts
  alias Bookclub.Content
  alias Bookclub.Content.{Book, Topic}
  alias BookclubWeb.Pagination

  plug BookclubWeb.Plugs.RequireAuth

  action_fallback BookclubWeb.ErrorController

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
    book = Content.get_book_by_slug!(slug)
    with true <- Content.check_if_user_owns_book(conn.assigns.user.id, book.id) do
      genre = Content.list_genres()

      changeset = Content.change_book(book)

      render(conn, "editbook.html", book: book, changeset: changeset, genre: genre)
    else
      false ->
        conn
        |> put_status(403)
        |> put_view(BookclubWeb.ErrorView)
        |> render("403.html")
    end
  end

  def updatebook(conn, %{"slug" => slug, "book" => book_params}) do
    book = Content.get_book_by_slug!(slug)
    with true <- Content.check_if_user_owns_book(conn.assigns.user.id, book.id) do
      genre = Content.list_genres()

      case Content.update_book(book, book_params) do
        {:ok, _book} ->
          conn
          |> put_flash(:info, "Book updated successfully.")
          |> redirect(to: Routes.user_path(conn, :managebooks))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "editbook.html", book: book, changeset: changeset, genre: genre)
      end
    else
      false ->
        conn
        |> put_status(403)
        |> put_view(BookclubWeb.ErrorView)
        |> render("403.html")
    end
  end

  def bookreaders(conn, %{"slug" => slug}) do
    # %{"slug" => slug} = params
    book = Content.get_book_by_slug!(slug)
    with true <- Content.check_if_user_owns_book(conn.assigns.user.id, book.id) do
      readers_count = Content.get_readers_by_book(book.id) |> Pagination.count_query

      {readers, num_links} =
        Content.get_readers_by_book(book.id)
        |> Pagination.paginate(30, conn)

      render(conn, "book_readers.html", readers: readers, num_links: num_links, readers_count: readers_count)
    else
      false ->
        conn
        |> put_status(403)
        |> put_view(BookclubWeb.ErrorView)
        |> render("403.html")
    end
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
        nil ->
          conn
          |> put_status(:not_found)
          |> put_view(BookclubWeb.ErrorView)
          |> render("404.html")

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

      {:error, %Ecto.Changeset{} = _changeset} ->
        conn
        |> put_flash(:info, "Status update not successful.")
        |> redirect(to: Routes.user_path(conn, :bookreaders, reader.book))
    end

  end

  def booktopic(conn, %{"slug" => slug}) do
    book = Content.get_book_by_slug!(slug)

    with true <- Content.check_if_user_owns_book(conn.assigns.user.id, book.id) do
        {topics, num_links} =
          Content.get_topics_by_book(book.id)
          |> Pagination.paginate(30, conn)

        render(conn, "topics.html", topics: topics, num_links: num_links, slug: slug)

      else
          false ->
            conn
            |> put_status(403)
            |> put_view(BookclubWeb.ErrorView)
            |> render("403.html")
    end

  end

  def addtopic(conn, %{"slug" => slug}) do
    # book = Content.get_book_by_slug!(slug)
    topic = %Topic{}
    changeset = Content.change_topic(topic)
    render(conn, "addtopic.html", changeset: changeset, topic: topic, slug: slug)
  end

  def createtopic(conn, %{"slug" => slug, "topic" => topic_params}) do
    book = Content.get_book_by_slug!(slug)

    with true <- Content.check_if_user_owns_book(conn.assigns.user.id, book.id) do
      topic = %Topic{}
      case Content.create_topic(book, topic_params) do
        {:ok, _topic} ->
          conn
          |> put_flash(:info, "Topic added successfully.")
          |> redirect(to: Routes.user_path(conn, :booktopic, slug))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "addtopic.html", changeset: changeset, topic: topic, slug: slug)
      end
    else
        false ->
          conn
          |> put_status(403)
          |> put_view(BookclubWeb.ErrorView)
          |> render("403.html")
    end

  end

  def edittopic(conn, %{"slug" => slug}) do

    with {:ok, decode} <- Base.decode64(slug),
      topic <- Content.get_topic!(decode),
      true <- Content.check_if_user_owns_book(conn.assigns.user.id, topic.book_id) do

        changeset = Content.change_topic(topic)
        render(conn, "edittopic.html", changeset: changeset, topic: topic, slug: slug)
    end

  end

  def updatetopic(conn, %{"slug" => slug, "topic" => topic_params}) do
    with {:ok, decode} <- Base.decode64(slug),
        topic <- Content.get_topic_with_book!(decode),
        true <- Content.check_if_user_owns_book(conn.assigns.user.id, topic.book_id) do

          case Content.update_topic(topic, topic_params) do
            {:ok, _topic} ->
              conn
              |> put_flash(:info, "Topic updated successfully.")
              |> redirect(to: Routes.user_path(conn, :booktopic, topic.book.slug))

            {:error, %Ecto.Changeset{} = changeset} ->
              render(conn, "edittopic.html", changeset: changeset, topic: topic, slug: slug)
          end
      end
  end

end

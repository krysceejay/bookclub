defmodule Bookclub.Content do
  @moduledoc """
  The Content context.
  """

  import Ecto.Query, warn: false
  alias Bookclub.Repo

  alias Bookclub.Content.Book

  def data() do
    Dataloader.Ecto.new(Bookclub.Repo, query: &query/2)
  end

  def query(queryable, _params) do
    queryable
  end

  @doc """
  Returns the list of books.

  ## Examples

      iex> list_books()
      [%Book{}, ...]

  """

  # def list_books do
  #   Repo.all(Book) |> Repo.preload(:user)
  # end

  def list_books do
    Repo.all(
      from b in Book,
        where: b.published == true,
        order_by: [desc: b.id]
    )
    |> Repo.preload(:user)
  end

  def top_books(per_page) do
    Repo.all(
      from b in Book,
        where: b.published == true,
        order_by: [desc: b.id],
        limit: ^per_page,
        preload: [:user, :ratings]
    )
  end

  def all_books do
    Book
    |> order_by(desc: :id)
    |> preload(:user)
  end

  def count_all_books do
    Repo.one(from b in Book, select: count("*"))
  end

  @doc """
  Gets a single book.

  Raises `Ecto.NoResultsError` if the Book does not exist.

  ## Examples

      iex> get_book!(123)
      %Book{}

      iex> get_book!(456)
      ** (Ecto.NoResultsError)

  """
  def get_book!(id), do: Repo.get!(Book, id) |> Repo.preload(:user)

  def get_book_by_slug!(slug), do: Repo.get_by!(Book, slug: slug) |> Repo.preload(:user)

  def get_only_book!(id), do: Repo.get!(Book, id)



  @doc """
  Creates a book.

  ## Examples

      iex> create_book(%{field: value})
      {:ok, %Book{}}

      iex> create_book(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_book(user, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:books)
    |> Book.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a book.

  ## Examples

      iex> update_book(book, %{field: new_value})
      {:ok, %Book{}}

      iex> update_book(book, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_book(%Book{} = book, attrs) do
    book
    |> Book.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Book.

  ## Examples

      iex> delete_book(book)
      {:ok, %Book{}}

      iex> delete_book(book)
      {:error, %Ecto.Changeset{}}

  """
  def delete_book(%Book{} = book) do
    Repo.delete(book)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking book changes.

  ## Examples

      iex> change_book(book)
      %Ecto.Changeset{source: %Book{}}

  """
  def change_book(%Book{} = book) do
    Book.changeset(book, %{})
  end

  def search_books_by_fields(genre \\ "", txt \\ "") do
    genres = [genre]

    query =
      from b in Book,
        where: b.published == true,
        where:
          fragment("? @> ?", b.genre, ^genres) or
            ilike(b.title, ^"%#{txt}%") or
            ilike(b.author, ^"%#{txt}%") or
            ilike(b.description, ^"%#{txt}%"),
        order_by: [desc: b.id],
        preload: [:user]

    # Enum.reduce(filters, Book, fn {key, value},
    # query ->
    #   from q in query,
    #   where: fragment("? @> ?", q.genre, ^genres),
    #   where: field(q, ^key) == ^value,
    #   order_by: [desc: q.id],
    #   preload: [:user]
    # end)
    query

  end

  def books_by_genre (genre) do

    query =
      from b in Book,
        where: b.published == true,
        where:
          fragment("? @> ?", b.genre, ^genre),
        order_by: [desc: b.id],
        preload: [:user]

    query

  end

  def recommended_books(id) do
    Repo.all(
      from b in Book,
        where: b.published == true,
        where: b.id != ^id,
        order_by: [desc: b.id],
        limit: 2,
        preload: [:user, :ratings]
    )
  end

  def book_by_user(user_id) do
    query =
      from b in Book,
        where: b.user_id == ^user_id,
        order_by: [desc: b.id]

    query
  end

  alias Bookclub.Content.Genre

  @doc """
  Returns the list of genres.

  ## Examples

      iex> list_genres()
      [%Genre{}, ...]

  """
  def list_genres do
    Repo.all(Genre)
  end

  @doc """
  Gets a single genre.

  Raises `Ecto.NoResultsError` if the Genre does not exist.

  ## Examples

      iex> get_genre!(123)
      %Genre{}

      iex> get_genre!(456)
      ** (Ecto.NoResultsError)

  """
  def get_genre!(id), do: Repo.get!(Genre, id)

  @doc """
  Creates a genre.

  ## Examples

      iex> create_genre(%{field: value})
      {:ok, %Genre{}}

      iex> create_genre(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_genre(attrs \\ %{}) do
    %Genre{}
    |> Genre.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a genre.

  ## Examples

      iex> update_genre(genre, %{field: new_value})
      {:ok, %Genre{}}

      iex> update_genre(genre, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_genre(%Genre{} = genre, attrs) do
    genre
    |> Genre.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Genre.

  ## Examples

      iex> delete_genre(genre)
      {:ok, %Genre{}}

      iex> delete_genre(genre)
      {:error, %Ecto.Changeset{}}

  """
  def delete_genre(%Genre{} = genre) do
    Repo.delete(genre)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking genre changes.

  ## Examples

      iex> change_genre(genre)
      %Ecto.Changeset{source: %Genre{}}

  """
  def change_genre(%Genre{} = genre) do
    Genre.changeset(genre, %{})
  end

  alias Bookclub.Content.Reader

  @doc """
  Returns the list of readers.

  ## Examples

      iex> list_readers()
      [%Reader{}, ...]

  """
  def list_readers do
    Repo.all(Reader)
  end

  @doc """
  Gets a single reader.

  Raises `Ecto.NoResultsError` if the Reader does not exist.

  ## Examples

      iex> get_reader!(123)
      %Reader{}

      iex> get_reader!(456)
      ** (Ecto.NoResultsError)

  """
  def get_reader!(id), do: Repo.get!(Reader, id)

  def check_if_reader_exist(user_id, book_id) do
    query =
      from r in Reader,
        where: r.user_id == ^user_id,
        where: r.book_id == ^book_id

    Repo.exists?(query)

  end

  def get_readers_by_book(book_id) do
    query =
      from r in Reader,
        where: r.book_id == ^book_id,
        order_by: [desc: r.id],
        preload: [:user]

    query
  end

  def get_reader_joined_list(user_id) do
    query =
      from r in Reader,
        where: r.user_id == ^user_id,
        order_by: [desc: r.id],
        preload: [book: :user]

    query
  end

  def get_reader_by_book_user(userid, bookid) do
    query =
      from r in Reader,
        where: r.user_id == ^userid,
        where: r.book_id == ^bookid

    Repo.one(query)

  end


  @doc """
  Creates a reader.

  ## Examples

      iex> create_reader(%{field: value})
      {:ok, %Reader{}}

      iex> create_reader(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  # def create_reader(attrs \\ %{}) do
  #   %Reader{}
  #   |> Reader.changeset(attrs)
  #   |> Repo.insert()
  # end

  def create_reader(user, %{id: bookid}, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:readers, book_id: bookid)
    |> Reader.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a reader.

  ## Examples

      iex> update_reader(reader, %{field: new_value})
      {:ok, %Reader{}}

      iex> update_reader(reader, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_reader(%Reader{} = reader, attrs) do
    reader
    |> Reader.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Reader.

  ## Examples

      iex> delete_reader(reader)
      {:ok, %Reader{}}

      iex> delete_reader(reader)
      {:error, %Ecto.Changeset{}}

  """
  def delete_reader(%Reader{} = reader) do
    Repo.delete(reader)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking reader changes.

  ## Examples

      iex> change_reader(reader)
      %Ecto.Changeset{source: %Reader{}}

  """
  def change_reader(%Reader{} = reader) do
    Reader.changeset(reader, %{})
  end

  alias Bookclub.Content.Rating

  @doc """
  Returns the list of ratings.

  ## Examples

      iex> list_ratings()
      [%Rating{}, ...]

  """
  def list_ratings do
    Repo.all(Rating)
  end

  @doc """
  Gets a single rating.

  Raises `Ecto.NoResultsError` if the Rating does not exist.

  ## Examples

      iex> get_rating!(123)
      %Rating{}

      iex> get_rating!(456)
      ** (Ecto.NoResultsError)

  """
  def get_rating!(id), do: Repo.get!(Rating, id)

  @doc """
  Creates a rating.

  ## Examples

      iex> create_rating(%{field: value})
      {:ok, %Rating{}}

      iex> create_rating(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """


  def create_rating(user, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:ratings)
    |> Rating.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a rating.

  ## Examples

      iex> update_rating(rating, %{field: new_value})
      {:ok, %Rating{}}

      iex> update_rating(rating, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_rating(%Rating{} = rating, attrs) do
    rating
    |> Rating.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Rating.

  ## Examples

      iex> delete_rating(rating)
      {:ok, %Rating{}}

      iex> delete_rating(rating)
      {:error, %Ecto.Changeset{}}

  """
  def delete_rating(%Rating{} = rating) do
    Repo.delete(rating)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking rating changes.

  ## Examples

      iex> change_rating(rating)
      %Ecto.Changeset{source: %Rating{}}

  """
  def change_rating(%Rating{} = rating) do
    Rating.changeset(rating, %{})
  end

  def get_ratings_by_book(book_id) do
    query =
      from r in Rating,
        where: r.book_id == ^book_id,
        order_by: [desc: r.id]

    query
  end

end

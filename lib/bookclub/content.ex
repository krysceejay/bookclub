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
        limit: ^per_page
    )
    |> Repo.preload(:user)
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
  end

  def book_by_user(user_id) do
    query =
      from b in Book,
      where: b.user_id == ^user_id,
      where: b.published == true,
      order_by: [desc: b.id]
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
end

defmodule Bookclub.Content do
  @moduledoc """
  The Content context.
  """

  import Ecto.Query, warn: false
  alias Bookclub.Repo

  alias Bookclub.Content.{Book, Topic}

  def data() do
    Dataloader.Ecto.new(Bookclub.Repo, query: &query/2)
  end

  def query(queryable, params) do
    field = params[:order] || :id
    from q in queryable, order_by: [desc: field(q, ^field)]
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
    |> where(published: true)
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

  def get_book_by_slug_with_t!(slug),
        do: Repo.get_by!(Book, slug: slug) |> Repo.preload(:user) |> Repo.preload(topics: from(t in Topic, order_by: [desc: t.id]))

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
    |> Book.changeset_c(attrs)
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
    |> Book.changeset(attrs, book)
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

  def check_if_user_owns_book(user_id, book_id) do
    query =
      from b in Book,
        where: b.user_id == ^user_id,
        where: b.id == ^book_id

    Repo.exists?(query)

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

  def get_reader_with_book!(id), do: Repo.get!(Reader, id) |> Repo.preload(:book)

  def check_if_reader_exist(user_id, book_id) do
    query =
      from r in Reader,
        where: r.user_id == ^user_id,
        where: r.book_id == ^book_id

    Repo.exists?(query)

  end

  def check_reader_status(user_id, book_id) do
    query =
      from r in Reader,
        where: r.user_id == ^user_id,
        where: r.book_id == ^book_id,
        where: r.status == true

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

  def create_readerp(user, %{id: bookid}, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:readers, book_id: bookid)
    |> Reader.changesetp(attrs)
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

  def update_reader_status(%Reader{} = reader, attrs) do
    reader
    |> Reader.set_status(attrs)
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

  def check_if_user_rated(user_id, book_id) do
    query =
      from r in Rating,
        where: r.user_id == ^user_id,
        where: r.book_id == ^book_id

    Repo.exists?(query)

  end

  def get_rating_by_book_user(userid, bookid) do
    query =
      from r in Rating,
        where: r.user_id == ^userid,
        where: r.book_id == ^bookid

    Repo.one(query)

  end

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

  def get_ratings_by_book_user(book_id) do
    query =
      from r in Rating,
        where: r.book_id == ^book_id,
        order_by: [desc: r.id],
        preload: [:user]

    query
  end

  def get_rating_by_book_num(bookid, num) do
    query =
      from r in Rating,
        where: r.book_id == ^bookid,
        where: r.rating == ^num

    query

  end


  @doc """
  Returns the list of topics.

  ## Examples

      iex> list_topics()
      [%Topic{}, ...]

  """
  def list_topics do
    Repo.all(Topic)
  end

  @doc """
  Gets a single topic.

  Raises `Ecto.NoResultsError` if the Topic does not exist.

  ## Examples

      iex> get_topic!(123)
      %Topic{}

      iex> get_topic!(456)
      ** (Ecto.NoResultsError)

  """
  def get_topic!(id), do: Repo.get!(Topic, id)

  def get_topic_with_book!(id), do: Repo.get!(Topic, id) |> Repo.preload(:book)

  def get_topics_by_book(book_id) do
    query =
      from t in Topic,
        where: t.book_id == ^book_id,
        order_by: [desc: t.id]

    query
  end

  @doc """
  Creates a topic.

  ## Examples

      iex> create_topic(%{field: value})
      {:ok, %Topic{}}

      iex> create_topic(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_topic(book, attrs \\ %{}) do
    book
    |> Ecto.build_assoc(:topics)
    |> Topic.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a topic.

  ## Examples

      iex> update_topic(topic, %{field: new_value})
      {:ok, %Topic{}}

      iex> update_topic(topic, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_topic(%Topic{} = topic, attrs) do
    topic
    |> Topic.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Topic.

  ## Examples

      iex> delete_topic(topic)
      {:ok, %Topic{}}

      iex> delete_topic(topic)
      {:error, %Ecto.Changeset{}}

  """
  def delete_topic(%Topic{} = topic) do
    Repo.delete(topic)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking topic changes.

  ## Examples

      iex> change_topic(topic)
      %Ecto.Changeset{source: %Topic{}}

  """
  def change_topic(%Topic{} = topic) do
    Topic.changeset(topic, %{})
  end

  alias Bookclub.Content.Club

  @doc """
  Returns the list of clubs.

  ## Examples

      iex> list_clubs()
      [%Club{}, ...]

  """
  def list_clubs do
    Repo.all(
      from c in Club,
      where: c.publish == true,
      order_by: [desc: c.id]
    )
  end

  @doc """
  Gets a single club.

  Raises `Ecto.NoResultsError` if the Club does not exist.

  ## Examples

      iex> get_club!(123)
      %Club{}

      iex> get_club!(456)
      ** (Ecto.NoResultsError)

  """
  def get_club!(id), do: Repo.get!(Club, id)

  def get_club_by_id_and_user(userid, clubid) do
    query =
      from c in Club,
        where: c.user_id == ^userid,
        where: c.id == ^clubid

    Repo.one(query)
  end

  @doc """
  Creates a club.

  ## Examples

      iex> create_club(%{field: value})
      {:ok, %Club{}}

      iex> create_club(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  # def create_club(attrs \\ %{}) do
  #   %Club{}
  #   |> Club.changeset(attrs)
  #   |> Repo.insert()
  # end
  # def create_club(attrs \\ %{}) do
  #   %Club{}
  #   |> Club.changeset_c(attrs)
  #   |> Repo.insert()
  # end

  def create_club(attrs \\ %{}) do
    %Club{}
    |> Club.changeset_app(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a club.

  ## Examples

      iex> update_club(club, %{field: new_value})
      {:ok, %Club{}}

      iex> update_club(club, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_club(%Club{} = club, attrs) do
    club
    |> Club.changeset_app(attrs)
    |> Repo.update()
  end

  def update_club_public(%Club{} = club, attrs) do
    club
    |> Club.set_public(attrs)
    |> Repo.update()
  end

  def update_club_publish(%Club{} = club, attrs) do
    club
    |> Club.set_publish(attrs)
    |> Repo.update()
  end

  def update_club_feature(%Club{} = club, attrs) do
    club
    |> Club.set_featured(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a club.

  ## Examples

      iex> delete_club(club)
      {:ok, %Club{}}

      iex> delete_club(club)
      {:error, %Ecto.Changeset{}}

  """
  def delete_club(%Club{} = club) do
    Repo.delete(club)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking club changes.

  ## Examples

      iex> change_club(club)
      %Ecto.Changeset{source: %Club{}}

  """
  def change_club(%Club{} = club) do
    Club.changeset_c(club, %{})
  end

  alias Bookclub.Content.Member

  @doc """
  Returns the list of members.

  ## Examples

      iex> list_members()
      [%Member{}, ...]

  """
  def list_members do
    Repo.all(Member)
  end

  @doc """
  Gets a single member.

  Raises `Ecto.NoResultsError` if the Member does not exist.

  ## Examples

      iex> get_member!(123)
      %Member{}

      iex> get_member!(456)
      ** (Ecto.NoResultsError)

  """
  def get_member!(id), do: Repo.get!(Member, id)

  def get_club_members(club_id) do
    Repo.all(
      from m in Member,
      where: m.club_id == ^club_id,
      order_by: [asc: m.id]
    )
  end

  def get_user_joined_club(user_id) do
    Repo.all(
      from m in Member,
      where: m.user_id == ^user_id,
      order_by: [desc: m.id]
    )
  end

  def get_member_by_id_and_clubid(userid, clubid) do
    query =
      from m in Member,
        where: m.user_id == ^userid,
        where: m.club_id == ^clubid

    Repo.one(query)
  end

  def check_if_user_is_member(user_id, club_id) do
    query =
      from m in Member,
        where: m.user_id == ^user_id,
        where: m.club_id == ^club_id

    Repo.exists?(query)
  end


  @doc """
  Creates a member.

  ## Examples

      iex> create_member(%{field: value})
      {:ok, %Member{}}

      iex> create_member(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_member(attrs \\ %{}) do
    %Member{}
    |> Member.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a member.

  ## Examples

      iex> update_member(member, %{field: new_value})
      {:ok, %Member{}}

      iex> update_member(member, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_member(%Member{} = member, attrs) do
    member
    |> Member.changeset(attrs)
    |> Repo.update()
  end

  def update_member_status(%Member{} = member, attrs) do
    member
    |> Member.set_status(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a member.

  ## Examples

      iex> delete_member(member)
      {:ok, %Member{}}

      iex> delete_member(member)
      {:error, %Ecto.Changeset{}}

  """
  def delete_member(%Member{} = member) do
    Repo.delete(member)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking member changes.

  ## Examples

      iex> change_member(member)
      %Ecto.Changeset{source: %Member{}}

  """
  def change_member(%Member{} = member) do
    Member.changeset(member, %{})
  end

  alias Bookclub.Content.Rate

  @doc """
  Returns the list of rates.

  ## Examples

      iex> list_rates()
      [%Rate{}, ...]

  """
  def list_rates do
    Repo.all(Rate)
  end

  @doc """
  Gets a single rate.

  Raises `Ecto.NoResultsError` if the Rate does not exist.

  ## Examples

      iex> get_rate!(123)
      %Rate{}

      iex> get_rate!(456)
      ** (Ecto.NoResultsError)

  """
  def get_rate!(id), do: Repo.get!(Rate, id)

  def check_if_user_rated_club(user_id, club_id) do
    query =
      from r in Rate,
        where: r.user_id == ^user_id,
        where: r.club_id == ^club_id

    Repo.exists?(query)
  end

  def get_rating_by_club_user(userid, clubid) do
    query =
      from r in Rate,
        where: r.user_id == ^userid,
        where: r.club_id == ^clubid

    Repo.one(query)
  end

  def get_ratings_by_club(club_id) do
    Repo.all(
      from r in Rate,
      where: r.club_id == ^club_id,
      order_by: [desc: r.id]
    )
  end

  @doc """
  Creates a rate.

  ## Examples

      iex> create_rate(%{field: value})
      {:ok, %Rate{}}

      iex> create_rate(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_rate(attrs \\ %{}) do
    %Rate{}
    |> Rate.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a rate.

  ## Examples

      iex> update_rate(rate, %{field: new_value})
      {:ok, %Rate{}}

      iex> update_rate(rate, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_rate(%Rate{} = rate, attrs) do
    rate
    |> Rate.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a rate.

  ## Examples

      iex> delete_rate(rate)
      {:ok, %Rate{}}

      iex> delete_rate(rate)
      {:error, %Ecto.Changeset{}}

  """
  def delete_rate(%Rate{} = rate) do
    Repo.delete(rate)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking rate changes.

  ## Examples

      iex> change_rate(rate)
      %Ecto.Changeset{source: %Rate{}}

  """
  def change_rate(%Rate{} = rate) do
    Rate.changeset(rate, %{})
  end

  alias Bookclub.Content.Poll

  @doc """
  Returns the list of polls.

  ## Examples

      iex> list_polls()
      [%Poll{}, ...]

  """
  def list_polls do
    Repo.all(Poll)
  end

  def get_polls_by_club(club_id) do
    Repo.all(
      from p in Poll,
      where: p.club_id == ^club_id,
      order_by: [desc: p.id]
    )
  end

  @doc """
  Gets a single poll.

  Raises `Ecto.NoResultsError` if the Poll does not exist.

  ## Examples

      iex> get_poll!(123)
      %Poll{}

      iex> get_poll!(456)
      ** (Ecto.NoResultsError)

  """
  def get_poll!(id), do: Repo.get!(Poll, id)

  def check_if_any_club_poll_is_current(club_id) do
    query =
      from p in Poll,
        where: p.club_id == ^club_id,
        where: p.current == true

    Repo.exists?(query)
  end

  def get_club_current_poll(club_id) do
    query =
      from p in Poll,
        where: p.club_id == ^club_id,
        where: p.current == true
    Repo.one(query)
  end

  def get_poll_by_id(poll_id) do
    query =
      from p in Poll,
        where: p.id == ^poll_id
    Repo.one(query)
  end

  @doc """
  Creates a poll.

  ## Examples

      iex> create_poll(%{field: value})
      {:ok, %Poll{}}

      iex> create_poll(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_poll(attrs \\ %{}) do
    %Poll{}
    |> Poll.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a poll.

  ## Examples

      iex> update_poll(poll, %{field: new_value})
      {:ok, %Poll{}}

      iex> update_poll(poll, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_poll(%Poll{} = poll, attrs) do
    poll
    |> Poll.changeset(attrs)
    |> Repo.update()
  end

  def update_poll_status(%Poll{} = poll, attrs) do
    poll
    |> Poll.set_status(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a poll.

  ## Examples

      iex> delete_poll(poll)
      {:ok, %Poll{}}

      iex> delete_poll(poll)
      {:error, %Ecto.Changeset{}}

  """
  def delete_poll(%Poll{} = poll) do
    Repo.delete(poll)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking poll changes.

  ## Examples

      iex> change_poll(poll)
      %Ecto.Changeset{source: %Poll{}}

  """
  def change_poll(%Poll{} = poll) do
    Poll.changeset(poll, %{})
  end

  alias Bookclub.Content.List

  @doc """
  Returns the list of lists.

  ## Examples

      iex> list_lists()
      [%List{}, ...]

  """
  def list_lists do
    Repo.all(List)
  end

  @doc """
  Gets a single list.

  Raises `Ecto.NoResultsError` if the List does not exist.

  ## Examples

      iex> get_list!(123)
      %List{}

      iex> get_list!(456)
      ** (Ecto.NoResultsError)

  """
  def get_list!(id), do: Repo.get!(List, id)

  def get_lists_by_club(club_id) do
    Repo.all(
      from l in List,
      where: l.club_id == ^club_id,
      order_by: [desc: l.id]
    )
  end

  def get_list_by_id(list_id) do
    query =
      from l in List,
        where: l.id == ^list_id

    Repo.one(query)
  end

  def get_club_current_book(club_id) do
    query =
      from l in List,
        where: l.club_id == ^club_id,
        where: l.current == true
    Repo.one(query)
  end

  @doc """
  Creates a list.

  ## Examples

      iex> create_list(%{field: value})
      {:ok, %List{}}

      iex> create_list(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_list(attrs \\ %{}) do
    %List{}
    |> List.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a list.

  ## Examples

      iex> update_list(list, %{field: new_value})
      {:ok, %List{}}

      iex> update_list(list, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_list(%List{} = list, attrs) do
    list
    |> List.changeset(attrs)
    |> Repo.update()
  end

  def update_list_status(%List{} = list, attrs) do
    list
    |> List.set_status(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a list.

  ## Examples

      iex> delete_list(list)
      {:ok, %List{}}

      iex> delete_list(list)
      {:error, %Ecto.Changeset{}}

  """
  def delete_list(%List{} = list) do
    Repo.delete(list)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking list changes.

  ## Examples

      iex> change_list(list)
      %Ecto.Changeset{source: %List{}}

  """
  def change_list(%List{} = list) do
    List.changeset(list, %{})
  end

  alias Bookclub.Content.CollectPoll

  @doc """
  Returns the list of collectpolls.

  ## Examples

      iex> list_collectpolls()
      [%CollectPoll{}, ...]

  """
  def list_collectpolls do
    Repo.all(CollectPoll)
  end

  @doc """
  Gets a single collect_poll.

  Raises `Ecto.NoResultsError` if the Collect poll does not exist.

  ## Examples

      iex> get_collect_poll!(123)
      %CollectPoll{}

      iex> get_collect_poll!(456)
      ** (Ecto.NoResultsError)

  """
  def get_collect_poll!(id), do: Repo.get!(CollectPoll, id)

  def get_votes_by_poll(poll_id) do
    Repo.all(
      from c in CollectPoll,
      where: c.poll_id == ^poll_id
    )
  end

  def get_votes_by_poll_and_user(poll_id, user_id) do
    query =
      from c in CollectPoll,
        where: c.poll_id == ^poll_id,
        where: c.user_id == ^user_id
    Repo.one(query)
  end
  @doc """
  Creates a collect_poll.

  ## Examples

      iex> create_collect_poll(%{field: value})
      {:ok, %CollectPoll{}}

      iex> create_collect_poll(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_collect_poll(attrs \\ %{}) do
    %CollectPoll{}
    |> CollectPoll.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a collect_poll.

  ## Examples

      iex> update_collect_poll(collect_poll, %{field: new_value})
      {:ok, %CollectPoll{}}

      iex> update_collect_poll(collect_poll, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_collect_poll(%CollectPoll{} = collect_poll, attrs) do
    collect_poll
    |> CollectPoll.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a collect_poll.

  ## Examples

      iex> delete_collect_poll(collect_poll)
      {:ok, %CollectPoll{}}

      iex> delete_collect_poll(collect_poll)
      {:error, %Ecto.Changeset{}}

  """
  def delete_collect_poll(%CollectPoll{} = collect_poll) do
    Repo.delete(collect_poll)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking collect_poll changes.

  ## Examples

      iex> change_collect_poll(collect_poll)
      %Ecto.Changeset{source: %CollectPoll{}}

  """
  def change_collect_poll(%CollectPoll{} = collect_poll) do
    CollectPoll.changeset(collect_poll, %{})
  end

  alias Bookclub.Content.Report

  @doc """
  Returns the list of reports.

  ## Examples

      iex> list_reports()
      [%Report{}, ...]

  """
  def list_reports do
    Repo.all(Report)
  end

  @doc """
  Gets a single report.

  Raises `Ecto.NoResultsError` if the Report does not exist.

  ## Examples

      iex> get_report!(123)
      %Report{}

      iex> get_report!(456)
      ** (Ecto.NoResultsError)

  """
  def get_report!(id), do: Repo.get!(Report, id)

  @doc """
  Creates a report.

  ## Examples

      iex> create_report(%{field: value})
      {:ok, %Report{}}

      iex> create_report(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_report(attrs \\ %{}) do
    %Report{}
    |> Report.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a report.

  ## Examples

      iex> update_report(report, %{field: new_value})
      {:ok, %Report{}}

      iex> update_report(report, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_report(%Report{} = report, attrs) do
    report
    |> Report.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a report.

  ## Examples

      iex> delete_report(report)
      {:ok, %Report{}}

      iex> delete_report(report)
      {:error, %Ecto.Changeset{}}

  """
  def delete_report(%Report{} = report) do
    Repo.delete(report)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking report changes.

  ## Examples

      iex> change_report(report)
      %Ecto.Changeset{source: %Report{}}

  """
  def change_report(%Report{} = report) do
    Report.changeset(report, %{})
  end

  alias Bookclub.Content.Favorite

  @doc """
  Returns the list of favorites.

  ## Examples

      iex> list_favorites()
      [%Favorite{}, ...]

  """
  def list_favorites do
    Repo.all(Favorite)
  end

  @doc """
  Gets a single favorite.

  Raises `Ecto.NoResultsError` if the Favorite does not exist.

  ## Examples

      iex> get_favorite!(123)
      %Favorite{}

      iex> get_favorite!(456)
      ** (Ecto.NoResultsError)

  """
  def get_favorite!(id), do: Repo.get!(Favorite, id)

  def get_fav_by_club_and_user(club_id, user_id) do
    query =
      from f in Favorite,
        where: f.club_id == ^club_id,
        where: f.user_id == ^user_id
    Repo.one(query)
  end

  @doc """
  Creates a favorite.

  ## Examples

      iex> create_favorite(%{field: value})
      {:ok, %Favorite{}}

      iex> create_favorite(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_favorite(attrs \\ %{}) do
    %Favorite{}
    |> Favorite.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a favorite.

  ## Examples

      iex> update_favorite(favorite, %{field: new_value})
      {:ok, %Favorite{}}

      iex> update_favorite(favorite, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_favorite(%Favorite{} = favorite, attrs) do
    favorite
    |> Favorite.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a favorite.

  ## Examples

      iex> delete_favorite(favorite)
      {:ok, %Favorite{}}

      iex> delete_favorite(favorite)
      {:error, %Ecto.Changeset{}}

  """
  def delete_favorite(%Favorite{} = favorite) do
    Repo.delete(favorite)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking favorite changes.

  ## Examples

      iex> change_favorite(favorite)
      %Ecto.Changeset{source: %Favorite{}}

  """
  def change_favorite(%Favorite{} = favorite) do
    Favorite.changeset(favorite, %{})
  end

  alias Bookclub.Content.FeaturedBook

  @doc """
  Returns the list of featured_books.

  ## Examples

      iex> list_featured_books()
      [%FeaturedBook{}, ...]

  """
  def list_featured_books do
    Repo.all(FeaturedBook)
  end

  def list_feat_books_by_status() do
    Repo.all(
      from f in FeaturedBook,
      where: f.status == true,
      order_by: [desc: f.id]
    )
  end

  @doc """
  Gets a single featured_book.

  Raises `Ecto.NoResultsError` if the Featured book does not exist.

  ## Examples

      iex> get_featured_book!(123)
      %FeaturedBook{}

      iex> get_featured_book!(456)
      ** (Ecto.NoResultsError)

  """
  def get_featured_book!(id), do: Repo.get!(FeaturedBook, id)

  @doc """
  Creates a featured_book.

  ## Examples

      iex> create_featured_book(%{field: value})
      {:ok, %FeaturedBook{}}

      iex> create_featured_book(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_featured_book(attrs \\ %{}) do
    %FeaturedBook{}
    |> FeaturedBook.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a featured_book.

  ## Examples

      iex> update_featured_book(featured_book, %{field: new_value})
      {:ok, %FeaturedBook{}}

      iex> update_featured_book(featured_book, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_featured_book(%FeaturedBook{} = featured_book, attrs) do
    featured_book
    |> FeaturedBook.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a featured_book.

  ## Examples

      iex> delete_featured_book(featured_book)
      {:ok, %FeaturedBook{}}

      iex> delete_featured_book(featured_book)
      {:error, %Ecto.Changeset{}}

  """
  def delete_featured_book(%FeaturedBook{} = featured_book) do
    Repo.delete(featured_book)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking featured_book changes.

  ## Examples

      iex> change_featured_book(featured_book)
      %Ecto.Changeset{source: %FeaturedBook{}}

  """
  def change_featured_book(%FeaturedBook{} = featured_book) do
    FeaturedBook.changeset(featured_book, %{})
  end
end

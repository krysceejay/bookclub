defmodule Bookclub.ContentTest do
  use Bookclub.DataCase

  alias Bookclub.Content

  describe "books" do
    alias Bookclub.Content.Book

    @valid_attrs %{author: "some author", bookcover: "some bookcover", description: "some description", genre: [], link: "some link", published: true, title: "some title"}
    @update_attrs %{author: "some updated author", bookcover: "some updated bookcover", description: "some updated description", genre: [], link: "some updated link", published: false, title: "some updated title"}
    @invalid_attrs %{author: nil, bookcover: nil, description: nil, genre: nil, link: nil, published: nil, title: nil}

    def book_fixture(attrs \\ %{}) do
      {:ok, book} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Content.create_book()

      book
    end

    test "list_books/0 returns all books" do
      book = book_fixture()
      assert Content.list_books() == [book]
    end

    test "get_book!/1 returns the book with given id" do
      book = book_fixture()
      assert Content.get_book!(book.id) == book
    end

    test "create_book/1 with valid data creates a book" do
      assert {:ok, %Book{} = book} = Content.create_book(@valid_attrs)
      assert book.author == "some author"
      assert book.bookcover == "some bookcover"
      assert book.description == "some description"
      assert book.genre == []
      assert book.link == "some link"
      assert book.published == true
      assert book.title == "some title"
    end

    test "create_book/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_book(@invalid_attrs)
    end

    test "update_book/2 with valid data updates the book" do
      book = book_fixture()
      assert {:ok, %Book{} = book} = Content.update_book(book, @update_attrs)
      assert book.author == "some updated author"
      assert book.bookcover == "some updated bookcover"
      assert book.description == "some updated description"
      assert book.genre == []
      assert book.link == "some updated link"
      assert book.published == false
      assert book.title == "some updated title"
    end

    test "update_book/2 with invalid data returns error changeset" do
      book = book_fixture()
      assert {:error, %Ecto.Changeset{}} = Content.update_book(book, @invalid_attrs)
      assert book == Content.get_book!(book.id)
    end

    test "delete_book/1 deletes the book" do
      book = book_fixture()
      assert {:ok, %Book{}} = Content.delete_book(book)
      assert_raise Ecto.NoResultsError, fn -> Content.get_book!(book.id) end
    end

    test "change_book/1 returns a book changeset" do
      book = book_fixture()
      assert %Ecto.Changeset{} = Content.change_book(book)
    end
  end

  describe "genres" do
    alias Bookclub.Content.Genre

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def genre_fixture(attrs \\ %{}) do
      {:ok, genre} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Content.create_genre()

      genre
    end

    test "list_genres/0 returns all genres" do
      genre = genre_fixture()
      assert Content.list_genres() == [genre]
    end

    test "get_genre!/1 returns the genre with given id" do
      genre = genre_fixture()
      assert Content.get_genre!(genre.id) == genre
    end

    test "create_genre/1 with valid data creates a genre" do
      assert {:ok, %Genre{} = genre} = Content.create_genre(@valid_attrs)
      assert genre.name == "some name"
    end

    test "create_genre/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_genre(@invalid_attrs)
    end

    test "update_genre/2 with valid data updates the genre" do
      genre = genre_fixture()
      assert {:ok, %Genre{} = genre} = Content.update_genre(genre, @update_attrs)
      assert genre.name == "some updated name"
    end

    test "update_genre/2 with invalid data returns error changeset" do
      genre = genre_fixture()
      assert {:error, %Ecto.Changeset{}} = Content.update_genre(genre, @invalid_attrs)
      assert genre == Content.get_genre!(genre.id)
    end

    test "delete_genre/1 deletes the genre" do
      genre = genre_fixture()
      assert {:ok, %Genre{}} = Content.delete_genre(genre)
      assert_raise Ecto.NoResultsError, fn -> Content.get_genre!(genre.id) end
    end

    test "change_genre/1 returns a genre changeset" do
      genre = genre_fixture()
      assert %Ecto.Changeset{} = Content.change_genre(genre)
    end
  end

  describe "readers" do
    alias Bookclub.Content.Reader

    @valid_attrs %{book_id: 42, user_id: 42}
    @update_attrs %{book_id: 43, user_id: 43}
    @invalid_attrs %{book_id: nil, user_id: nil}

    def reader_fixture(attrs \\ %{}) do
      {:ok, reader} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Content.create_reader()

      reader
    end

    test "list_readers/0 returns all readers" do
      reader = reader_fixture()
      assert Content.list_readers() == [reader]
    end

    test "get_reader!/1 returns the reader with given id" do
      reader = reader_fixture()
      assert Content.get_reader!(reader.id) == reader
    end

    test "create_reader/1 with valid data creates a reader" do
      assert {:ok, %Reader{} = reader} = Content.create_reader(@valid_attrs)
      assert reader.book_id == 42
      assert reader.user_id == 42
    end

    test "create_reader/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_reader(@invalid_attrs)
    end

    test "update_reader/2 with valid data updates the reader" do
      reader = reader_fixture()
      assert {:ok, %Reader{} = reader} = Content.update_reader(reader, @update_attrs)
      assert reader.book_id == 43
      assert reader.user_id == 43
    end

    test "update_reader/2 with invalid data returns error changeset" do
      reader = reader_fixture()
      assert {:error, %Ecto.Changeset{}} = Content.update_reader(reader, @invalid_attrs)
      assert reader == Content.get_reader!(reader.id)
    end

    test "delete_reader/1 deletes the reader" do
      reader = reader_fixture()
      assert {:ok, %Reader{}} = Content.delete_reader(reader)
      assert_raise Ecto.NoResultsError, fn -> Content.get_reader!(reader.id) end
    end

    test "change_reader/1 returns a reader changeset" do
      reader = reader_fixture()
      assert %Ecto.Changeset{} = Content.change_reader(reader)
    end
  end

  describe "ratings" do
    alias Bookclub.Content.Rating

    @valid_attrs %{book_id: 42, rating: 42, user_id: 42}
    @update_attrs %{book_id: 43, rating: 43, user_id: 43}
    @invalid_attrs %{book_id: nil, rating: nil, user_id: nil}

    def rating_fixture(attrs \\ %{}) do
      {:ok, rating} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Content.create_rating()

      rating
    end

    test "list_ratings/0 returns all ratings" do
      rating = rating_fixture()
      assert Content.list_ratings() == [rating]
    end

    test "get_rating!/1 returns the rating with given id" do
      rating = rating_fixture()
      assert Content.get_rating!(rating.id) == rating
    end

    test "create_rating/1 with valid data creates a rating" do
      assert {:ok, %Rating{} = rating} = Content.create_rating(@valid_attrs)
      assert rating.book_id == 42
      assert rating.rating == 42
      assert rating.user_id == 42
    end

    test "create_rating/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_rating(@invalid_attrs)
    end

    test "update_rating/2 with valid data updates the rating" do
      rating = rating_fixture()
      assert {:ok, %Rating{} = rating} = Content.update_rating(rating, @update_attrs)
      assert rating.book_id == 43
      assert rating.rating == 43
      assert rating.user_id == 43
    end

    test "update_rating/2 with invalid data returns error changeset" do
      rating = rating_fixture()
      assert {:error, %Ecto.Changeset{}} = Content.update_rating(rating, @invalid_attrs)
      assert rating == Content.get_rating!(rating.id)
    end

    test "delete_rating/1 deletes the rating" do
      rating = rating_fixture()
      assert {:ok, %Rating{}} = Content.delete_rating(rating)
      assert_raise Ecto.NoResultsError, fn -> Content.get_rating!(rating.id) end
    end

    test "change_rating/1 returns a rating changeset" do
      rating = rating_fixture()
      assert %Ecto.Changeset{} = Content.change_rating(rating)
    end
  end

  describe "topics" do
    alias Bookclub.Content.Topic

    @valid_attrs %{book_id: "some book_id", topic_status: "some topic_status", topic_text: "some topic_text", user_id: "some user_id"}
    @update_attrs %{book_id: "some updated book_id", topic_status: "some updated topic_status", topic_text: "some updated topic_text", user_id: "some updated user_id"}
    @invalid_attrs %{book_id: nil, topic_status: nil, topic_text: nil, user_id: nil}

    def topic_fixture(attrs \\ %{}) do
      {:ok, topic} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Content.create_topic()

      topic
    end

    test "list_topics/0 returns all topics" do
      topic = topic_fixture()
      assert Content.list_topics() == [topic]
    end

    test "get_topic!/1 returns the topic with given id" do
      topic = topic_fixture()
      assert Content.get_topic!(topic.id) == topic
    end

    test "create_topic/1 with valid data creates a topic" do
      assert {:ok, %Topic{} = topic} = Content.create_topic(@valid_attrs)
      assert topic.book_id == "some book_id"
      assert topic.topic_status == "some topic_status"
      assert topic.topic_text == "some topic_text"
      assert topic.user_id == "some user_id"
    end

    test "create_topic/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_topic(@invalid_attrs)
    end

    test "update_topic/2 with valid data updates the topic" do
      topic = topic_fixture()
      assert {:ok, %Topic{} = topic} = Content.update_topic(topic, @update_attrs)
      assert topic.book_id == "some updated book_id"
      assert topic.topic_status == "some updated topic_status"
      assert topic.topic_text == "some updated topic_text"
      assert topic.user_id == "some updated user_id"
    end

    test "update_topic/2 with invalid data returns error changeset" do
      topic = topic_fixture()
      assert {:error, %Ecto.Changeset{}} = Content.update_topic(topic, @invalid_attrs)
      assert topic == Content.get_topic!(topic.id)
    end

    test "delete_topic/1 deletes the topic" do
      topic = topic_fixture()
      assert {:ok, %Topic{}} = Content.delete_topic(topic)
      assert_raise Ecto.NoResultsError, fn -> Content.get_topic!(topic.id) end
    end

    test "change_topic/1 returns a topic changeset" do
      topic = topic_fixture()
      assert %Ecto.Changeset{} = Content.change_topic(topic)
    end
  end
end

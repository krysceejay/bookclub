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

  describe "clubs" do
    alias Bookclub.Content.Club

    @valid_attrs %{image: "some image", name: "some name"}
    @update_attrs %{image: "some updated image", name: "some updated name"}
    @invalid_attrs %{image: nil, name: nil}

    def club_fixture(attrs \\ %{}) do
      {:ok, club} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Content.create_club()

      club
    end

    test "list_clubs/0 returns all clubs" do
      club = club_fixture()
      assert Content.list_clubs() == [club]
    end

    test "get_club!/1 returns the club with given id" do
      club = club_fixture()
      assert Content.get_club!(club.id) == club
    end

    test "create_club/1 with valid data creates a club" do
      assert {:ok, %Club{} = club} = Content.create_club(@valid_attrs)
      assert club.image == "some image"
      assert club.name == "some name"
    end

    test "create_club/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_club(@invalid_attrs)
    end

    test "update_club/2 with valid data updates the club" do
      club = club_fixture()
      assert {:ok, %Club{} = club} = Content.update_club(club, @update_attrs)
      assert club.image == "some updated image"
      assert club.name == "some updated name"
    end

    test "update_club/2 with invalid data returns error changeset" do
      club = club_fixture()
      assert {:error, %Ecto.Changeset{}} = Content.update_club(club, @invalid_attrs)
      assert club == Content.get_club!(club.id)
    end

    test "delete_club/1 deletes the club" do
      club = club_fixture()
      assert {:ok, %Club{}} = Content.delete_club(club)
      assert_raise Ecto.NoResultsError, fn -> Content.get_club!(club.id) end
    end

    test "change_club/1 returns a club changeset" do
      club = club_fixture()
      assert %Ecto.Changeset{} = Content.change_club(club)
    end
  end

  describe "members" do
    alias Bookclub.Content.Member

    @valid_attrs %{status: "some status", user_id: "some user_id"}
    @update_attrs %{status: "some updated status", user_id: "some updated user_id"}
    @invalid_attrs %{status: nil, user_id: nil}

    def member_fixture(attrs \\ %{}) do
      {:ok, member} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Content.create_member()

      member
    end

    test "list_members/0 returns all members" do
      member = member_fixture()
      assert Content.list_members() == [member]
    end

    test "get_member!/1 returns the member with given id" do
      member = member_fixture()
      assert Content.get_member!(member.id) == member
    end

    test "create_member/1 with valid data creates a member" do
      assert {:ok, %Member{} = member} = Content.create_member(@valid_attrs)
      assert member.status == "some status"
      assert member.user_id == "some user_id"
    end

    test "create_member/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_member(@invalid_attrs)
    end

    test "update_member/2 with valid data updates the member" do
      member = member_fixture()
      assert {:ok, %Member{} = member} = Content.update_member(member, @update_attrs)
      assert member.status == "some updated status"
      assert member.user_id == "some updated user_id"
    end

    test "update_member/2 with invalid data returns error changeset" do
      member = member_fixture()
      assert {:error, %Ecto.Changeset{}} = Content.update_member(member, @invalid_attrs)
      assert member == Content.get_member!(member.id)
    end

    test "delete_member/1 deletes the member" do
      member = member_fixture()
      assert {:ok, %Member{}} = Content.delete_member(member)
      assert_raise Ecto.NoResultsError, fn -> Content.get_member!(member.id) end
    end

    test "change_member/1 returns a member changeset" do
      member = member_fixture()
      assert %Ecto.Changeset{} = Content.change_member(member)
    end
  end

  describe "rates" do
    alias Bookclub.Content.Rate

    @valid_attrs %{first_name: "some first_name"}
    @update_attrs %{first_name: "some updated first_name"}
    @invalid_attrs %{first_name: nil}

    def rate_fixture(attrs \\ %{}) do
      {:ok, rate} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Content.create_rate()

      rate
    end

    test "list_rates/0 returns all rates" do
      rate = rate_fixture()
      assert Content.list_rates() == [rate]
    end

    test "get_rate!/1 returns the rate with given id" do
      rate = rate_fixture()
      assert Content.get_rate!(rate.id) == rate
    end

    test "create_rate/1 with valid data creates a rate" do
      assert {:ok, %Rate{} = rate} = Content.create_rate(@valid_attrs)
      assert rate.first_name == "some first_name"
    end

    test "create_rate/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_rate(@invalid_attrs)
    end

    test "update_rate/2 with valid data updates the rate" do
      rate = rate_fixture()
      assert {:ok, %Rate{} = rate} = Content.update_rate(rate, @update_attrs)
      assert rate.first_name == "some updated first_name"
    end

    test "update_rate/2 with invalid data returns error changeset" do
      rate = rate_fixture()
      assert {:error, %Ecto.Changeset{}} = Content.update_rate(rate, @invalid_attrs)
      assert rate == Content.get_rate!(rate.id)
    end

    test "delete_rate/1 deletes the rate" do
      rate = rate_fixture()
      assert {:ok, %Rate{}} = Content.delete_rate(rate)
      assert_raise Ecto.NoResultsError, fn -> Content.get_rate!(rate.id) end
    end

    test "change_rate/1 returns a rate changeset" do
      rate = rate_fixture()
      assert %Ecto.Changeset{} = Content.change_rate(rate)
    end
  end

  describe "polls" do
    alias Bookclub.Content.Poll

    @valid_attrs %{first_name: "some first_name"}
    @update_attrs %{first_name: "some updated first_name"}
    @invalid_attrs %{first_name: nil}

    def poll_fixture(attrs \\ %{}) do
      {:ok, poll} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Content.create_poll()

      poll
    end

    test "list_polls/0 returns all polls" do
      poll = poll_fixture()
      assert Content.list_polls() == [poll]
    end

    test "get_poll!/1 returns the poll with given id" do
      poll = poll_fixture()
      assert Content.get_poll!(poll.id) == poll
    end

    test "create_poll/1 with valid data creates a poll" do
      assert {:ok, %Poll{} = poll} = Content.create_poll(@valid_attrs)
      assert poll.first_name == "some first_name"
    end

    test "create_poll/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_poll(@invalid_attrs)
    end

    test "update_poll/2 with valid data updates the poll" do
      poll = poll_fixture()
      assert {:ok, %Poll{} = poll} = Content.update_poll(poll, @update_attrs)
      assert poll.first_name == "some updated first_name"
    end

    test "update_poll/2 with invalid data returns error changeset" do
      poll = poll_fixture()
      assert {:error, %Ecto.Changeset{}} = Content.update_poll(poll, @invalid_attrs)
      assert poll == Content.get_poll!(poll.id)
    end

    test "delete_poll/1 deletes the poll" do
      poll = poll_fixture()
      assert {:ok, %Poll{}} = Content.delete_poll(poll)
      assert_raise Ecto.NoResultsError, fn -> Content.get_poll!(poll.id) end
    end

    test "change_poll/1 returns a poll changeset" do
      poll = poll_fixture()
      assert %Ecto.Changeset{} = Content.change_poll(poll)
    end
  end

  describe "lists" do
    alias Bookclub.Content.List

    @valid_attrs %{first_name: "some first_name"}
    @update_attrs %{first_name: "some updated first_name"}
    @invalid_attrs %{first_name: nil}

    def list_fixture(attrs \\ %{}) do
      {:ok, list} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Content.create_list()

      list
    end

    test "list_lists/0 returns all lists" do
      list = list_fixture()
      assert Content.list_lists() == [list]
    end

    test "get_list!/1 returns the list with given id" do
      list = list_fixture()
      assert Content.get_list!(list.id) == list
    end

    test "create_list/1 with valid data creates a list" do
      assert {:ok, %List{} = list} = Content.create_list(@valid_attrs)
      assert list.first_name == "some first_name"
    end

    test "create_list/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_list(@invalid_attrs)
    end

    test "update_list/2 with valid data updates the list" do
      list = list_fixture()
      assert {:ok, %List{} = list} = Content.update_list(list, @update_attrs)
      assert list.first_name == "some updated first_name"
    end

    test "update_list/2 with invalid data returns error changeset" do
      list = list_fixture()
      assert {:error, %Ecto.Changeset{}} = Content.update_list(list, @invalid_attrs)
      assert list == Content.get_list!(list.id)
    end

    test "delete_list/1 deletes the list" do
      list = list_fixture()
      assert {:ok, %List{}} = Content.delete_list(list)
      assert_raise Ecto.NoResultsError, fn -> Content.get_list!(list.id) end
    end

    test "change_list/1 returns a list changeset" do
      list = list_fixture()
      assert %Ecto.Changeset{} = Content.change_list(list)
    end
  end

  describe "collectpolls" do
    alias Bookclub.Content.CollectPoll

    @valid_attrs %{first_name: "some first_name"}
    @update_attrs %{first_name: "some updated first_name"}
    @invalid_attrs %{first_name: nil}

    def collect_poll_fixture(attrs \\ %{}) do
      {:ok, collect_poll} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Content.create_collect_poll()

      collect_poll
    end

    test "list_collectpolls/0 returns all collectpolls" do
      collect_poll = collect_poll_fixture()
      assert Content.list_collectpolls() == [collect_poll]
    end

    test "get_collect_poll!/1 returns the collect_poll with given id" do
      collect_poll = collect_poll_fixture()
      assert Content.get_collect_poll!(collect_poll.id) == collect_poll
    end

    test "create_collect_poll/1 with valid data creates a collect_poll" do
      assert {:ok, %CollectPoll{} = collect_poll} = Content.create_collect_poll(@valid_attrs)
      assert collect_poll.first_name == "some first_name"
    end

    test "create_collect_poll/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_collect_poll(@invalid_attrs)
    end

    test "update_collect_poll/2 with valid data updates the collect_poll" do
      collect_poll = collect_poll_fixture()
      assert {:ok, %CollectPoll{} = collect_poll} = Content.update_collect_poll(collect_poll, @update_attrs)
      assert collect_poll.first_name == "some updated first_name"
    end

    test "update_collect_poll/2 with invalid data returns error changeset" do
      collect_poll = collect_poll_fixture()
      assert {:error, %Ecto.Changeset{}} = Content.update_collect_poll(collect_poll, @invalid_attrs)
      assert collect_poll == Content.get_collect_poll!(collect_poll.id)
    end

    test "delete_collect_poll/1 deletes the collect_poll" do
      collect_poll = collect_poll_fixture()
      assert {:ok, %CollectPoll{}} = Content.delete_collect_poll(collect_poll)
      assert_raise Ecto.NoResultsError, fn -> Content.get_collect_poll!(collect_poll.id) end
    end

    test "change_collect_poll/1 returns a collect_poll changeset" do
      collect_poll = collect_poll_fixture()
      assert %Ecto.Changeset{} = Content.change_collect_poll(collect_poll)
    end
  end

  describe "reports" do
    alias Bookclub.Content.Report

    @valid_attrs %{first_name: "some first_name"}
    @update_attrs %{first_name: "some updated first_name"}
    @invalid_attrs %{first_name: nil}

    def report_fixture(attrs \\ %{}) do
      {:ok, report} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Content.create_report()

      report
    end

    test "list_reports/0 returns all reports" do
      report = report_fixture()
      assert Content.list_reports() == [report]
    end

    test "get_report!/1 returns the report with given id" do
      report = report_fixture()
      assert Content.get_report!(report.id) == report
    end

    test "create_report/1 with valid data creates a report" do
      assert {:ok, %Report{} = report} = Content.create_report(@valid_attrs)
      assert report.first_name == "some first_name"
    end

    test "create_report/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_report(@invalid_attrs)
    end

    test "update_report/2 with valid data updates the report" do
      report = report_fixture()
      assert {:ok, %Report{} = report} = Content.update_report(report, @update_attrs)
      assert report.first_name == "some updated first_name"
    end

    test "update_report/2 with invalid data returns error changeset" do
      report = report_fixture()
      assert {:error, %Ecto.Changeset{}} = Content.update_report(report, @invalid_attrs)
      assert report == Content.get_report!(report.id)
    end

    test "delete_report/1 deletes the report" do
      report = report_fixture()
      assert {:ok, %Report{}} = Content.delete_report(report)
      assert_raise Ecto.NoResultsError, fn -> Content.get_report!(report.id) end
    end

    test "change_report/1 returns a report changeset" do
      report = report_fixture()
      assert %Ecto.Changeset{} = Content.change_report(report)
    end
  end

  describe "favorites" do
    alias Bookclub.Content.Favorite

    @valid_attrs %{first_name: "some first_name"}
    @update_attrs %{first_name: "some updated first_name"}
    @invalid_attrs %{first_name: nil}

    def favorite_fixture(attrs \\ %{}) do
      {:ok, favorite} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Content.create_favorite()

      favorite
    end

    test "list_favorites/0 returns all favorites" do
      favorite = favorite_fixture()
      assert Content.list_favorites() == [favorite]
    end

    test "get_favorite!/1 returns the favorite with given id" do
      favorite = favorite_fixture()
      assert Content.get_favorite!(favorite.id) == favorite
    end

    test "create_favorite/1 with valid data creates a favorite" do
      assert {:ok, %Favorite{} = favorite} = Content.create_favorite(@valid_attrs)
      assert favorite.first_name == "some first_name"
    end

    test "create_favorite/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_favorite(@invalid_attrs)
    end

    test "update_favorite/2 with valid data updates the favorite" do
      favorite = favorite_fixture()
      assert {:ok, %Favorite{} = favorite} = Content.update_favorite(favorite, @update_attrs)
      assert favorite.first_name == "some updated first_name"
    end

    test "update_favorite/2 with invalid data returns error changeset" do
      favorite = favorite_fixture()
      assert {:error, %Ecto.Changeset{}} = Content.update_favorite(favorite, @invalid_attrs)
      assert favorite == Content.get_favorite!(favorite.id)
    end

    test "delete_favorite/1 deletes the favorite" do
      favorite = favorite_fixture()
      assert {:ok, %Favorite{}} = Content.delete_favorite(favorite)
      assert_raise Ecto.NoResultsError, fn -> Content.get_favorite!(favorite.id) end
    end

    test "change_favorite/1 returns a favorite changeset" do
      favorite = favorite_fixture()
      assert %Ecto.Changeset{} = Content.change_favorite(favorite)
    end
  end
end

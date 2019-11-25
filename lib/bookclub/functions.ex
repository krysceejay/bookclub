defmodule Bookclub.Functions do

  import Ecto.Query, warn: false
  alias Bookclub.Repo
  alias Bookclub.Content

  def count_column(query, column)  do
    query |> Repo.aggregate(:count, column)
  end

  def sum_column(query, column)  do
    query |> Repo.aggregate(:sum, column)
  end

  def avg_column(query, column)  do
    query |> Repo.aggregate(:avg, column)
  end

  def calculate_ratings(book_id) do
    column_sum = Content.get_ratings_by_book(book_id) |> sum_column(:rating)
    column_count = Content.get_ratings_by_book(book_id) |> count_column(:rating)

    rating_sum =
          case column_sum do
            nil -> 5
            _ -> 5 + column_sum
          end
    rating_count =
          case column_count do
            0 -> 1
            _ -> 1 + column_count
          end

    star_rating = rating_sum / rating_count

    {
      rating_count,
      star_rating
    }

  end

  def top_five_genres do
    all_genres = Content.list_genres

    genre_n_count = Enum.reduce all_genres, %{}, fn x, acc ->
      Map.put(acc, x.name, Content.books_by_genre([x.name]) |> count_column(:id))
    end

    genre_sort =
      genre_n_count
        |> Enum.sort_by(&elem(&1, 1), &>=/2)
        |> Enum.slice(0, 5)

    genre_sort
  end

end

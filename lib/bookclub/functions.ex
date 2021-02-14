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

  def rand_string(length) do
    length
    |> :crypto.strong_rand_bytes
    |> Base.encode64
    |> binary_part(0, length)
  end

  def rand_digit do
    Enum.random(1_000..9_999) |> Integer.to_string
  end

end

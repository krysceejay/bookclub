defmodule Bookclub.Aggregate do

  import Ecto.Query, warn: false
  alias Bookclub.Repo

  def count_column(query, column)  do
    query |> Repo.aggregate(:count, column)
  end

  def sum_column(query, column)  do
    query |> Repo.aggregate(:sum, column)
  end

  def avg_column(query, column)  do
    query |> Repo.aggregate(:avg, column)
  end

end

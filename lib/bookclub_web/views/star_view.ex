defmodule BookclubWeb.StarView do
  use BookclubWeb, :view

  alias Bookclub.Content
  alias Bookclub.Functions

  def calculate_ratings(book_id) do
    column_sum = Content.get_ratings_by_book(book_id) |> Functions.sum_column(:rating)
    column_count = Content.get_ratings_by_book(book_id) |> Functions.count_column(:rating)

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

end

defmodule BookclubWeb.StarView do
  use BookclubWeb, :view

  alias Bookclub.Content
  alias Bookclub.Functions

  def calculate_ratings(book_id) do
    column_sum = Content.get_ratings_by_book(book_id) |> Functions.sum_column(:rating)
    column_count = Content.get_ratings_by_book(book_id) |> Functions.count_column(:rating)

    rating_sum =
          case column_sum do
            nil -> 0
            _ -> column_sum
          end

    star_rating =
        case column_count do
          0 -> 0.0
          _ ->
              rating_sum / column_count
              |> Decimal.from_float
              |> Decimal.round(1)
        end
    {
      column_count,
      star_rating
    }

  end

  def total_reviewers(book_id) do
    column_count = Content.get_ratings_by_book(book_id) |> Functions.count_column(:rating)
    rating_count =
          case column_count do
            0 -> 0
            _ -> column_count
          end
  end

  def total_reviewers_num(book_id, num) do
    review_count = Content.get_rating_by_book_num(book_id, num) |> Functions.count_column(:rating)
    column_count = Content.get_ratings_by_book(book_id) |> Functions.count_column(:rating)

    rating_percent =
      case column_count do
          0 -> 0
          _ -> (review_count / column_count) * 100
      end

      {
        review_count,
        rating_percent
      }

  end

end

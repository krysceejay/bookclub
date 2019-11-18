defmodule BookclubWeb.Pagination do
  import Ecto.Query, warn: false
  alias Bookclub.Repo

  defp page(query, per_page, current_page \\ 1) do
    query
    |> limit(^per_page)
    |> offset(^((current_page - 1) * per_page))
    |> Repo.all

  end

  defp number_of_links(query, pp) do
    total_result = Repo.aggregate(query, :count, :id)

    links(total_result, pp)
  end

  def paginate(query, per_page, current_page \\ 1) do
    {
      page(query, per_page, current_page),
      number_of_links(query, per_page)
    }

  end

  def count_query(query)  do
    query |> Repo.aggregate(:count, :id)
  end

  defp links(t, pp) do
    links_div = div(t, pp)
    num_links_rems = rem(t, pp)
    if num_links_rems == 0 do
      links_div
    else
      links_div + 1
    end

  end

end

defmodule BookclubWeb.Pagination do

  import Ecto.Query, warn: false
  alias Bookclub.Repo
  alias BookclubWeb.PaginationView

  defp page(query, per_page, current_page \\ 1) do
    query
    |> limit(^per_page)
    |> offset(^((current_page - 1) * per_page))
    |> Repo.all

  end

  defp number_of_links(query, pp) do
    total_result = count_query(query)

    links(total_result, pp)
  end

  def paginate(query, per_page, conn) do
    {
      page(query, per_page, get_current_page(conn)),
      number_of_links(query, per_page)
    }

  end

  def count_query(query)  do
    query |> Repo.aggregate(:count, :id)
  end

  def get_current_page(conn) do
    curpage = PaginationView.get_param(conn.query_params)
    curpage
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

defmodule BookclubWeb.PaginationView do
  use BookclubWeb, :view

  def get_param(params) do
    {page, ""} = Integer.parse(params["page"] || "1")
      page
  end

end

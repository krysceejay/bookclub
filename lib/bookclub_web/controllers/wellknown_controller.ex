defmodule BookclubWeb.WellknownController do
  use BookclubWeb, :controller

  def index(conn, _params) do
    render(conn, "index.json")
  end

end

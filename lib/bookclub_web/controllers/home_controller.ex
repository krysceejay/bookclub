defmodule BookclubWeb.HomeController do
  use BookclubWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end

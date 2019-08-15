defmodule BookclubWeb.UserController do
  use BookclubWeb, :controller

  plug BookclubWeb.Plugs.RequireAuth

  def index(conn, _params) do
    render(conn, "dashboard.html")
  end
end

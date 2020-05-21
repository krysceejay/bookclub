defmodule BookclubWeb.ErrorController do
  use BookclubWeb, :controller
  alias BookclubWeb.ErrorView

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(ErrorView)
    |> render("404.html")
  end

  def call(conn, {:error, :unathorized}) do
    conn
    |> put_status(403)
    |> put_view(ErrorView)
    |> render("403.html")
  end

  def call(conn, {:error, :internal_server_error}) do
    conn
    |> put_status(500)
    |> put_view(ErrorView)
    |> render("500.html")
  end

end

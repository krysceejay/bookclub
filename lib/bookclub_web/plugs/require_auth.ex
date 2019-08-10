defmodule BookclubWeb.Plugs.RequireAuth do

  import Plug.Conn
  import Phoenix.Controller

  alias BookclubWeb.Router.Helpers

  def init(_opts) do

  end

  def call(conn,_) do

    if conn.assigns[:user] do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in")
      |> redirect(to: Helpers.auth_path(conn, :login))
      |> halt()

    end

  end

end

defmodule BookclubWeb.Plugs.AdminAuth do
  import Plug.Conn
  import Phoenix.Controller

  alias BookclubWeb.Router.Helpers

  def init(_opts) do

  end

  def call(conn,_) do

    if conn.assigns[:user].role_id == 2 do
      conn
    else
      conn
      |> put_flash(:error, "Unauthorized route")
      |> redirect(to: Helpers.home_path(conn, :index))
      |> halt()

    end

  end

end

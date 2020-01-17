defmodule BookclubWeb.Plugs.RedirectToDashboard do
  import Plug.Conn
  import Phoenix.Controller

  alias BookclubWeb.Router.Helpers

  def init(_opts) do

  end

  def call(conn,_) do

    if conn.assigns[:user] do
      conn
      |> redirect(to: Helpers.user_path(conn, :index))
    else
      conn
    end

  end
end

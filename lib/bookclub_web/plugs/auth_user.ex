defmodule BookclubWeb.Plugs.AuthUser do
  import Plug.Conn
  alias Bookclub.Repo
  alias Bookclub.Accounts.User

  def init(_opts) do

  end

  def call(conn,_) do
    user_id = get_session(conn, :user_id)

    cond do
      user = user_id && Repo.get(User, user_id) -> assign(conn, :user, user)
      true -> assign(conn, :user, nil)
    end

  end

end

defmodule BookclubWeb.LoginController do
  use BookclubWeb, :controller

  alias Bookclub.Repo
  alias Bookclub.Accounts.{User, Auth}

  def login(conn, _params) do
    render conn, "login.html", layout: {BookclubWeb.LayoutView, "auth.html"}
  end

  def create(conn, login_params) do
    case Auth.login(login_params, Repo) do
      {:ok, user} ->
        conn
        |> put_session(:current_user, user.id)
        |> put_flash(:info, "Logged in")
        |> redirect(to: Routes.user_path(conn, :dashboard))

      :error ->
        conn
        |> put_flash(:error, "Incorrect email or password")
        |> render("login.html", layout: {BookclubWeb.LayoutView, "auth.html"})

    end
  end

  def delete(conn, _) do
    conn
    |> delete_session(:current_user)
    |> put_flash(:info, "Logged out")
    |> redirect(to: Routes.login_path(conn, :login))
  end


end

defmodule BookclubWeb.LoginController do
  use BookclubWeb, :controller

  alias Bookclub.Repo
  alias Bookclub.Accounts.{User, Auth}

  def login(conn, _params) do

    if conn.assigns[:user] do
      redirect(conn, to: Routes.admin_path(conn, :dashboard))
    end

    render conn, "login.html", layout: {BookclubWeb.LayoutView, "auth.html"}
  end

  def create(conn, login_params) do
    case Auth.login(login_params, Repo) do
      {:ok, user} ->
        conn
        |> put_session(:user_id, user.id)
        |> put_flash(:info, "Logged in")
        |> redirect(to: Routes.admin_path(conn, :dashboard))

      :error ->
        conn
        |> put_flash(:error, "Incorrect email or password")
        |> render("login.html", layout: {BookclubWeb.LayoutView, "auth.html"})

    end
  end

  def delete(conn, _) do
    conn
    |> configure_session(drop: true)
    |> put_flash(:info, "Logged out")
    |> redirect(to: Routes.login_path(conn, :login))
  end


end

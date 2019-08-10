defmodule BookclubWeb.AuthController do
  use BookclubWeb, :controller

  alias Bookclub.Repo
  alias Bookclub.Accounts
  alias Bookclub.Accounts.{User, Auth}

  def loginform(conn, _params) do

    if conn.assigns[:user] do
      redirect(conn, to: Routes.user_path(conn, :index))
    end

    render(conn, "login.html")
  end

  def registerform(conn, _params) do
    
    if conn.assigns[:user] do
      redirect(conn, to: Routes.user_path(conn, :index))
    end

    changeset = Accounts.change_user(%User{})
    render(conn, "register.html", changeset: changeset)
  end

  def login(conn, login_params) do
    case Auth.login(login_params, Repo) do
      {:ok, user} ->
        conn
        |> put_session(:user_id, user.id)
        |> put_flash(:info, "Logged in")
        |> redirect(to: Routes.user_path(conn, :index))

      :error ->
        conn
        |> put_flash(:error, "Incorrect email or password")
        |> render("login.html")

    end
  end

  def register(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: Routes.user_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "register.html", changeset: changeset)
    end
  end

  def delete(conn, _) do
    conn
    |> configure_session(drop: true)
    |> put_flash(:info, "Logged out")
    |> redirect(to: Routes.auth_path(conn, :login))
  end


end

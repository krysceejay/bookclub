defmodule BookclubWeb.AuthController do
  use BookclubWeb, :controller

  alias Bookclub.Repo
  alias Bookclub.Accounts
  alias Bookclub.Accounts.{User, Auth}
  alias Bookclub.Functions

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

        with true <- Auth.check_if_user_verify(user.email, Repo) do
          conn
          |> put_session(:user_id, user.id)
          |> put_flash(:info, "Logged in")
          |> redirect(to: Routes.user_path(conn, :index))
        else
          false ->
            conn
            |> put_flash(:error, "This account is not verified, please go to your email to verify your account")
            |> render("login.html")
        end

      :error ->
        conn
        |> put_flash(:error, "Incorrect email or password")
        |> render("login.html")

    end
  end

  def register(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        with true <- verifyemail(user) do
            Bookclub.Email.confirm_email(user, user.email, get_user_token(user.id))
            |> Bookclub.Mailer.deliver_now
          conn
          |> redirect(to: Routes.auth_path(conn, :confirmemail, user.email))
        else
          false ->
            conn
            |> put_status(500)
            |> put_view(BookclubWeb.ErrorView)
            |> render("500.html")
        end

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "register.html", changeset: changeset)
    end
  end

  defp verifyemail(user) do
    case Accounts.create_verify(user, %{token: Functions.rand_string(20)}) do
      {:ok, _verify} -> true
      {:error, _changeset} -> false
    end
  end

  defp get_user_token(userid) do
    with verify <- Accounts.get_verify_userid(userid) do
      verify.token
    end
  end

  def delete(conn, _) do
    conn
    |> configure_session(drop: true)
    |> put_flash(:info, "Logged out")
    |> redirect(to: Routes.auth_path(conn, :login))
  end

  def confirmemail(conn, %{"slug" => slug}) do
    useremail = Accounts.get_user_by_email(slug)
      case useremail do
        nil ->
          conn
          |> put_status(:not_found)
          |> put_view(BookclubWeb.ErrorView)
          |> render("404.html")

        _ -> render(conn, "confirm_email.html", slug: slug)
      end

  end

  def verifytoken(conn, %{"token" => dtoken}) do
    with {:ok, token} <- Base.decode64(dtoken),
          verified_user <- Accounts.get_verify_by_token(token),
          getuser <- Accounts.get_user!(verified_user.user_id),
          {:ok, _user} <- Accounts.update_user_status(getuser, %{status: 1}) do
            conn
            |> put_flash(:info, "Email verified, you can now login.")
            |> redirect(to: Routes.auth_path(conn, :login))
          end
  end

  def welcome(conn, _) do
    render(conn, "welcome.html")
  end


end

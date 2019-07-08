defmodule Bookclub.Accounts.Session do
  use Ecto.Schema

  alias Bookclub.Repo
  alias Bookclub.Accounts.{Encryption, User}

  def authenticate(args) do
    user = Repo.get_by(User, email: String.downcase(args.email))

    case check_password(user, args.passwordfield) do
      true -> {:ok, user}
      _   ->  {:error, "Incorrect login credentials"}
    end

  end

  defp check_password(user, passwordfield) do
    case user do
      nil -> Encryption.dummy_check_password()
      _  -> Encryption.validate_password(passwordfield, user.password)
    end
  end

end

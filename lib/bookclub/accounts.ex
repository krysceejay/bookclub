defmodule Bookclub.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Bookclub.Repo

  alias Bookclub.Accounts.Role

  @doc """
  Returns the list of roles.

  ## Examples

      iex> list_roles()
      [%Role{}, ...]

  """

  # def data() do
  #     Dataloader.Ecto.new(Bookclub.Repo, query: &query/2)
  # end
  #
  # def query(queryable, _params) do
  #   queryable
  # end

  def data() do
    Dataloader.Ecto.new(Bookclub.Repo, query: &query/2)
  end

  def query(queryable, params) do
    field = params[:order] || :id
    from q in queryable, order_by: [desc: field(q, ^field)]
  end

  def list_roles do
    Repo.all(Role)
  end

  @doc """
  Gets a single role.

  Raises `Ecto.NoResultsError` if the Role does not exist.

  ## Examples

      iex> get_role!(123)
      %Role{}

      iex> get_role!(456)
      ** (Ecto.NoResultsError)

  """
  def get_role!(id), do: Repo.get!(Role, id)

  @doc """
  Creates a role.

  ## Examples

      iex> create_role(%{field: value})
      {:ok, %Role{}}

      iex> create_role(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_role(attrs \\ %{}) do
    %Role{}
    |> Role.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a role.

  ## Examples

      iex> update_role(role, %{field: new_value})
      {:ok, %Role{}}

      iex> update_role(role, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_role(%Role{} = role, attrs) do
    role
    |> Role.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Role.

  ## Examples

      iex> delete_role(role)
      {:ok, %Role{}}

      iex> delete_role(role)
      {:error, %Ecto.Changeset{}}

  """
  def delete_role(%Role{} = role) do
    Repo.delete(role)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking role changes.

  ## Examples

      iex> change_role(role)
      %Ecto.Changeset{source: %Role{}}

  """
  def change_role(%Role{} = role) do
    Role.changeset(role, %{})
  end

  alias Bookclub.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User) |> Repo.preload(:role)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  def get_user_by_username(name), do: Repo.get_by(User, username: name)

  def get_user_by_email(email), do: Repo.get_by(User, email: email)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def update_user_slim(%User{} = user, attrs) do
    user
    |> User.changeset_update(attrs)
    |> Repo.update()
  end

  def update_user_status(%User{} = user, attrs) do
    user
    |> User.changeset_for_status(attrs)
    |> Repo.update()
  end

  def update_user_password(%User{} = user, attrs) do
    user
    |> User.changeset_password_reset(attrs)
    |> Repo.update()
  end

  def update_user_app(%User{} = user, attrs) do
    user
    |> User.changeset_ap(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end


  alias Bookclub.Accounts.Verify

  @doc """
  Returns the list of verify_users.

  ## Examples

      iex> list_verify_users()
      [%Verify{}, ...]

  """
  def list_verify_users do
    Repo.all(Verify)
  end

  @doc """
  Gets a single verify.

  Raises `Ecto.NoResultsError` if the Verify does not exist.

  ## Examples

      iex> get_verify!(123)
      %Verify{}

      iex> get_verify!(456)
      ** (Ecto.NoResultsError)

  """
  def get_verify!(id), do: Repo.get!(Verify, id)

  def get_verify_userid(userid), do: Repo.get_by(Verify, user_id: userid)

  def get_verify_by_token(token), do: Repo.get_by(Verify, token: token)

  @doc """
  Creates a verify.

  ## Examples

      iex> create_verify(%{field: value})
      {:ok, %Verify{}}

      iex> create_verify(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_verify(user, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:verify)
    |> Verify.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a verify.

  ## Examples

      iex> update_verify(verify, %{field: new_value})
      {:ok, %Verify{}}

      iex> update_verify(verify, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_verify(%Verify{} = verify, attrs) do
    verify
    |> Verify.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Verify.

  ## Examples

      iex> delete_verify(verify)
      {:ok, %Verify{}}

      iex> delete_verify(verify)
      {:error, %Ecto.Changeset{}}

  """
  def delete_verify(%Verify{} = verify) do
    Repo.delete(verify)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking verify changes.

  ## Examples

      iex> change_verify(verify)
      %Ecto.Changeset{source: %Verify{}}

  """
  def change_verify(%Verify{} = verify) do
    Verify.changeset(verify, %{})
  end

  alias Bookclub.Accounts.ResetPassword

  @doc """
  Returns the list of password_reset.

  ## Examples

      iex> list_password_reset()
      [%ResetPassword{}, ...]

  """
  def list_password_reset do
    Repo.all(ResetPassword)
  end

  @doc """
  Gets a single reset_password.

  Raises `Ecto.NoResultsError` if the Reset password does not exist.

  ## Examples

      iex> get_reset_password!(123)
      %ResetPassword{}

      iex> get_reset_password!(456)
      ** (Ecto.NoResultsError)

  """
  def get_reset_password!(id), do: Repo.get!(ResetPassword, id)

  def get_reset_password_by_email(email), do: Repo.get_by!(ResetPassword, email: email)

  def get_reset_password_by_token(token), do: Repo.get_by!(ResetPassword, token: token)

  def check_if_email_exist(email) do
    query =
      from r in ResetPassword,
        where: r.email == ^email

    Repo.exists?(query)

  end

  @doc """
  Creates a reset_password.

  ## Examples

      iex> create_reset_password(%{field: value})
      {:ok, %ResetPassword{}}

      iex> create_reset_password(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_reset_password(attrs \\ %{}) do
    %ResetPassword{}
    |> ResetPassword.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a reset_password.

  ## Examples

      iex> update_reset_password(reset_password, %{field: new_value})
      {:ok, %ResetPassword{}}

      iex> update_reset_password(reset_password, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_reset_password(%ResetPassword{} = reset_password, attrs) do
    reset_password
    |> ResetPassword.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ResetPassword.

  ## Examples

      iex> delete_reset_password(reset_password)
      {:ok, %ResetPassword{}}

      iex> delete_reset_password(reset_password)
      {:error, %Ecto.Changeset{}}

  """
  def delete_reset_password(%ResetPassword{} = reset_password) do
    Repo.delete(reset_password)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking reset_password changes.

  ## Examples

      iex> change_reset_password(reset_password)
      %Ecto.Changeset{source: %ResetPassword{}}

  """
  def change_reset_password(%ResetPassword{} = reset_password) do
    ResetPassword.changeset(reset_password, %{})
  end
end

defmodule Bookclub.Alerts do
  @moduledoc """
  The Alerts context.
  """

  import Ecto.Query, warn: false
  alias Bookclub.Repo

  def data() do
    Dataloader.Ecto.new(Bookclub.Repo, query: &query/2)
  end

  def query(queryable, params) do
    field = params[:order] || :id
    from q in queryable, order_by: [desc: field(q, ^field)]
  end

  alias Bookclub.Alerts.Notification

  @doc """
  Returns the list of notifications.

  ## Examples

      iex> list_notifications()
      [%Notification{}, ...]

  """
  def list_notifications do
    Repo.all(Notification)
  end

  def get_user_notifications(user_id) do
    Repo.all(
      from n in Notification,
      where: n.receiver_user_id == ^user_id,
      order_by: [desc: n.id]
    )
  end

  def get_user_not_seen_note(user_id) do
    Repo.all(
      from n in Notification,
      where: n.receiver_user_id == ^user_id,
      where: n.seen == false,
      order_by: [desc: n.id]
    )
  end

  @doc """
  Gets a single notification.

  Raises `Ecto.NoResultsError` if the Notification does not exist.

  ## Examples

      iex> get_notification!(123)
      %Notification{}

      iex> get_notification!(456)
      ** (Ecto.NoResultsError)

  """
  def get_notification!(id), do: Repo.get!(Notification, id)

  @doc """
  Creates a notification.

  ## Examples

      iex> create_notification(%{field: value})
      {:ok, %Notification{}}

      iex> create_notification(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_notification(attrs \\ %{}) do
    %Notification{}
    |> Notification.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a notification.

  ## Examples

      iex> update_notification(notification, %{field: new_value})
      {:ok, %Notification{}}

      iex> update_notification(notification, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_notification(%Notification{} = notification, attrs) do
    notification
    |> Notification.changeset(attrs)
    |> Repo.update()
  end

  def set_seen_to_true(user_id) do
    from(
      n in Notification,
      where: n.receiver_user_id == ^user_id,
      where: n.seen == false
      )|> Repo.update_all(set: [seen: true])
  end

  @doc """
  Deletes a notification.

  ## Examples

      iex> delete_notification(notification)
      {:ok, %Notification{}}

      iex> delete_notification(notification)
      {:error, %Ecto.Changeset{}}

  """
  def delete_notification(%Notification{} = notification) do
    Repo.delete(notification)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking notification changes.

  ## Examples

      iex> change_notification(notification)
      %Ecto.Changeset{source: %Notification{}}

  """
  def change_notification(%Notification{} = notification) do
    Notification.changeset(notification, %{})
  end
end

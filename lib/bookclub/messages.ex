defmodule Bookclub.Messages do
  @moduledoc """
  The Messages context.
  """

  import Ecto.Query, warn: false
  alias Bookclub.Repo

  alias Bookclub.Messages.Chat


  @topic inspect(__MODULE__)

  # def subscribe do
  #   Phoenix.PubSub.subscribe(Bookclub.PubSub, @topic)
  # end

  def get_topic(book_id) do
    @topic <> "#{book_id}"
  end


  def subscribe(book_id) do
    Phoenix.PubSub.subscribe(Bookclub.PubSub, @topic <> "#{book_id}")
  end

  @doc """
  Returns the list of chats.

  ## Examples

      iex> list_chats()
      [%Chat{}, ...]

  """
  def list_chats do
    Repo.all(Chat)|> Repo.preload(:user)
  end

  def list_chats_by_bookid(bookid) do

    query =
      from c in Chat,
        where: c.book_id == ^bookid,
        order_by: [asc: c.id],
        preload: [:user]

    Repo.all(query)

  end

  def get_last_chat_by_bookid(bookid) do
    query =
      from c in Chat,
        where: c.book_id == ^bookid,
        preload: [:user]

    query |> last(:inserted_at) |> Repo.one
  end

  def list_last_ten_chats(bookid, current_page, per_page) do

    query =
      from c in Chat,
        where: c.book_id == ^bookid,
        order_by: [desc: c.id],
        offset: ^((current_page - 1) * per_page),
        limit: ^per_page,
        preload: [:user]

    Repo.all(query)

  end

  def count_chats(bookid) do

    query =
      from c in Chat,
        where: c.book_id == ^bookid

    Repo.aggregate(query, :count, :id)

  end

  @doc """
  Gets a single chat.

  Raises `Ecto.NoResultsError` if the Chat does not exist.

  ## Examples

      iex> get_chat!(123)
      %Chat{}

      iex> get_chat!(456)
      ** (Ecto.NoResultsError)

  """
  def get_chat!(id), do: Repo.get!(Chat, id)

  @doc """
  Creates a chat.

  ## Examples

      iex> create_chat(%{field: value})
      {:ok, %Chat{}}

      iex> create_chat(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  # def create_chat(attrs \\ %{}) do
  #   %Chat{}
  #   |> Chat.changeset(attrs)
  #   |> Repo.insert()
  #   |> notify_subscribers([:chat, :inserted])
  # end

  def create_chat(user, %{id: bookid}, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:chats, book_id: bookid)
    |> Chat.changeset(attrs)
    |> Repo.insert()
    |> notify_subscribers([:chat, :inserted])
  end

  @doc """
  Updates a chat.

  ## Examples

      iex> update_chat(chat, %{field: new_value})
      {:ok, %Chat{}}

      iex> update_chat(chat, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_chat(%Chat{} = chat, attrs) do
    chat
    |> Chat.changeset(attrs)
    |> Repo.update()
    |> notify_subscribers([:chat, :updated])
  end

  @doc """
  Deletes a Chat.

  ## Examples

      iex> delete_chat(chat)
      {:ok, %Chat{}}

      iex> delete_chat(chat)
      {:error, %Ecto.Changeset{}}

  """
  def delete_chat(%Chat{} = chat) do
    Repo.delete(chat)
    |> notify_subscribers([:chat, :deleted])
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking chat changes.

  ## Examples

      iex> change_chat(chat)
      %Ecto.Changeset{source: %Chat{}}

  """
  # def change_chat(%Chat{} = chat) do
  #   Chat.changeset(chat, %{})
  # end

  def change_chat(%Chat{} = chat, attrs \\ %{}) do
    Chat.changeset(chat, attrs)
  end

  # def change_chat do
  #   Chat.changeset(%Chat{})
  # end

  # def change_chat(changeset, changes) do
  #   Chat.changeset(changeset, changes)
  # end


  defp notify_subscribers({:ok, result}, event) do
    #Phoenix.PubSub.broadcast(Bookclub.PubSub, @topic, {__MODULE__, event, result})
    Phoenix.PubSub.broadcast(Bookclub.PubSub, @topic <> "#{result.book_id}", {__MODULE__, event, result})
    {:ok, result}
  end

  defp notify_subscribers({:error, reason}, _event), do: {:error, reason}
end

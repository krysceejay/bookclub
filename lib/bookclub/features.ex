defmodule Bookclub.Features do
  @moduledoc """
  The Features context.
  """

  import Ecto.Query, warn: false
  alias Bookclub.Repo

  alias Bookclub.Features.Bookstore

  @doc """
  Returns the list of bookstores.

  ## Examples

      iex> list_bookstores()
      [%Bookstore{}, ...]

  """
  def list_bookstores do
    Repo.all(Bookstore)
  end

  def list_bookstores_by_status() do
    Repo.all(
      from b in Bookstore,
      where: b.status == true,
      order_by: [desc: b.id]
    )
  end

  @doc """
  Gets a single bookstore.

  Raises `Ecto.NoResultsError` if the Bookstore does not exist.

  ## Examples

      iex> get_bookstore!(123)
      %Bookstore{}

      iex> get_bookstore!(456)
      ** (Ecto.NoResultsError)

  """
  def get_bookstore!(id), do: Repo.get!(Bookstore, id)

  @doc """
  Creates a bookstore.

  ## Examples

      iex> create_bookstore(%{field: value})
      {:ok, %Bookstore{}}

      iex> create_bookstore(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_bookstore(attrs \\ %{}) do
    %Bookstore{}
    |> Bookstore.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a bookstore.

  ## Examples

      iex> update_bookstore(bookstore, %{field: new_value})
      {:ok, %Bookstore{}}

      iex> update_bookstore(bookstore, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_bookstore(%Bookstore{} = bookstore, attrs) do
    bookstore
    |> Bookstore.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a bookstore.

  ## Examples

      iex> delete_bookstore(bookstore)
      {:ok, %Bookstore{}}

      iex> delete_bookstore(bookstore)
      {:error, %Ecto.Changeset{}}

  """
  def delete_bookstore(%Bookstore{} = bookstore) do
    Repo.delete(bookstore)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking bookstore changes.

  ## Examples

      iex> change_bookstore(bookstore)
      %Ecto.Changeset{source: %Bookstore{}}

  """
  def change_bookstore(%Bookstore{} = bookstore) do
    Bookstore.changeset(bookstore, %{})
  end
end

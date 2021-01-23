defmodule Bookclub.FeaturesTest do
  use Bookclub.DataCase

  alias Bookclub.Features

  describe "bookstores" do
    alias Bookclub.Features.Bookstore

    @valid_attrs %{first_name: "some first_name", last_name: "some last_name"}
    @update_attrs %{first_name: "some updated first_name", last_name: "some updated last_name"}
    @invalid_attrs %{first_name: nil, last_name: nil}

    def bookstore_fixture(attrs \\ %{}) do
      {:ok, bookstore} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Features.create_bookstore()

      bookstore
    end

    test "list_bookstores/0 returns all bookstores" do
      bookstore = bookstore_fixture()
      assert Features.list_bookstores() == [bookstore]
    end

    test "get_bookstore!/1 returns the bookstore with given id" do
      bookstore = bookstore_fixture()
      assert Features.get_bookstore!(bookstore.id) == bookstore
    end

    test "create_bookstore/1 with valid data creates a bookstore" do
      assert {:ok, %Bookstore{} = bookstore} = Features.create_bookstore(@valid_attrs)
      assert bookstore.first_name == "some first_name"
      assert bookstore.last_name == "some last_name"
    end

    test "create_bookstore/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Features.create_bookstore(@invalid_attrs)
    end

    test "update_bookstore/2 with valid data updates the bookstore" do
      bookstore = bookstore_fixture()
      assert {:ok, %Bookstore{} = bookstore} = Features.update_bookstore(bookstore, @update_attrs)
      assert bookstore.first_name == "some updated first_name"
      assert bookstore.last_name == "some updated last_name"
    end

    test "update_bookstore/2 with invalid data returns error changeset" do
      bookstore = bookstore_fixture()
      assert {:error, %Ecto.Changeset{}} = Features.update_bookstore(bookstore, @invalid_attrs)
      assert bookstore == Features.get_bookstore!(bookstore.id)
    end

    test "delete_bookstore/1 deletes the bookstore" do
      bookstore = bookstore_fixture()
      assert {:ok, %Bookstore{}} = Features.delete_bookstore(bookstore)
      assert_raise Ecto.NoResultsError, fn -> Features.get_bookstore!(bookstore.id) end
    end

    test "change_bookstore/1 returns a bookstore changeset" do
      bookstore = bookstore_fixture()
      assert %Ecto.Changeset{} = Features.change_bookstore(bookstore)
    end
  end
end

defmodule Bookclub.MessagesTest do
  use Bookclub.DataCase

  alias Bookclub.Messages

  describe "chats" do
    alias Bookclub.Messages.Chat

    @valid_attrs %{book_id: "some book_id", message: "some message", user_id: "some user_id"}
    @update_attrs %{book_id: "some updated book_id", message: "some updated message", user_id: "some updated user_id"}
    @invalid_attrs %{book_id: nil, message: nil, user_id: nil}

    def chat_fixture(attrs \\ %{}) do
      {:ok, chat} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Messages.create_chat()

      chat
    end

    test "list_chats/0 returns all chats" do
      chat = chat_fixture()
      assert Messages.list_chats() == [chat]
    end

    test "get_chat!/1 returns the chat with given id" do
      chat = chat_fixture()
      assert Messages.get_chat!(chat.id) == chat
    end

    test "create_chat/1 with valid data creates a chat" do
      assert {:ok, %Chat{} = chat} = Messages.create_chat(@valid_attrs)
      assert chat.book_id == "some book_id"
      assert chat.message == "some message"
      assert chat.user_id == "some user_id"
    end

    test "create_chat/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Messages.create_chat(@invalid_attrs)
    end

    test "update_chat/2 with valid data updates the chat" do
      chat = chat_fixture()
      assert {:ok, %Chat{} = chat} = Messages.update_chat(chat, @update_attrs)
      assert chat.book_id == "some updated book_id"
      assert chat.message == "some updated message"
      assert chat.user_id == "some updated user_id"
    end

    test "update_chat/2 with invalid data returns error changeset" do
      chat = chat_fixture()
      assert {:error, %Ecto.Changeset{}} = Messages.update_chat(chat, @invalid_attrs)
      assert chat == Messages.get_chat!(chat.id)
    end

    test "delete_chat/1 deletes the chat" do
      chat = chat_fixture()
      assert {:ok, %Chat{}} = Messages.delete_chat(chat)
      assert_raise Ecto.NoResultsError, fn -> Messages.get_chat!(chat.id) end
    end

    test "change_chat/1 returns a chat changeset" do
      chat = chat_fixture()
      assert %Ecto.Changeset{} = Messages.change_chat(chat)
    end
  end
end

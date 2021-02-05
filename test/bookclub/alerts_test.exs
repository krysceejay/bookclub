defmodule Bookclub.AlertsTest do
  use Bookclub.DataCase

  alias Bookclub.Alerts

  describe "notifications" do
    alias Bookclub.Alerts.Notification

    @valid_attrs %{first_name: "some first_name", last_name: "some last_name"}
    @update_attrs %{first_name: "some updated first_name", last_name: "some updated last_name"}
    @invalid_attrs %{first_name: nil, last_name: nil}

    def notification_fixture(attrs \\ %{}) do
      {:ok, notification} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Alerts.create_notification()

      notification
    end

    test "list_notifications/0 returns all notifications" do
      notification = notification_fixture()
      assert Alerts.list_notifications() == [notification]
    end

    test "get_notification!/1 returns the notification with given id" do
      notification = notification_fixture()
      assert Alerts.get_notification!(notification.id) == notification
    end

    test "create_notification/1 with valid data creates a notification" do
      assert {:ok, %Notification{} = notification} = Alerts.create_notification(@valid_attrs)
      assert notification.first_name == "some first_name"
      assert notification.last_name == "some last_name"
    end

    test "create_notification/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Alerts.create_notification(@invalid_attrs)
    end

    test "update_notification/2 with valid data updates the notification" do
      notification = notification_fixture()
      assert {:ok, %Notification{} = notification} = Alerts.update_notification(notification, @update_attrs)
      assert notification.first_name == "some updated first_name"
      assert notification.last_name == "some updated last_name"
    end

    test "update_notification/2 with invalid data returns error changeset" do
      notification = notification_fixture()
      assert {:error, %Ecto.Changeset{}} = Alerts.update_notification(notification, @invalid_attrs)
      assert notification == Alerts.get_notification!(notification.id)
    end

    test "delete_notification/1 deletes the notification" do
      notification = notification_fixture()
      assert {:ok, %Notification{}} = Alerts.delete_notification(notification)
      assert_raise Ecto.NoResultsError, fn -> Alerts.get_notification!(notification.id) end
    end

    test "change_notification/1 returns a notification changeset" do
      notification = notification_fixture()
      assert %Ecto.Changeset{} = Alerts.change_notification(notification)
    end
  end
end

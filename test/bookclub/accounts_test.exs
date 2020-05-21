defmodule Bookclub.AccountsTest do
  use Bookclub.DataCase

  alias Bookclub.Accounts

  describe "roles" do
    alias Bookclub.Accounts.Role

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def role_fixture(attrs \\ %{}) do
      {:ok, role} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_role()

      role
    end

    test "list_roles/0 returns all roles" do
      role = role_fixture()
      assert Accounts.list_roles() == [role]
    end

    test "get_role!/1 returns the role with given id" do
      role = role_fixture()
      assert Accounts.get_role!(role.id) == role
    end

    test "create_role/1 with valid data creates a role" do
      assert {:ok, %Role{} = role} = Accounts.create_role(@valid_attrs)
      assert role.name == "some name"
    end

    test "create_role/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_role(@invalid_attrs)
    end

    test "update_role/2 with valid data updates the role" do
      role = role_fixture()
      assert {:ok, %Role{} = role} = Accounts.update_role(role, @update_attrs)
      assert role.name == "some updated name"
    end

    test "update_role/2 with invalid data returns error changeset" do
      role = role_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_role(role, @invalid_attrs)
      assert role == Accounts.get_role!(role.id)
    end

    test "delete_role/1 deletes the role" do
      role = role_fixture()
      assert {:ok, %Role{}} = Accounts.delete_role(role)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_role!(role.id) end
    end

    test "change_role/1 returns a role changeset" do
      role = role_fixture()
      assert %Ecto.Changeset{} = Accounts.change_role(role)
    end
  end

  describe "users" do
    alias Bookclub.Accounts.User

    @valid_attrs %{email: "some email", first_name: "some first_name", last_name: "some last_name", password: "some password", status: 42, username: "some username"}
    @update_attrs %{email: "some updated email", first_name: "some updated first_name", last_name: "some updated last_name", password: "some updated password", status: 43, username: "some updated username"}
    @invalid_attrs %{email: nil, first_name: nil, last_name: nil, password: nil, status: nil, username: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == "some email"
      assert user.first_name == "some first_name"
      assert user.last_name == "some last_name"
      assert user.password == "some password"
      assert user.status == 42
      assert user.username == "some username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.email == "some updated email"
      assert user.first_name == "some updated first_name"
      assert user.last_name == "some updated last_name"
      assert user.password == "some updated password"
      assert user.status == 43
      assert user.username == "some updated username"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  describe "profiles" do
    alias Bookclub.Accounts.Profile

    @valid_attrs %{about: "some about", propix: "some propix", user_id: "some user_id"}
    @update_attrs %{about: "some updated about", propix: "some updated propix", user_id: "some updated user_id"}
    @invalid_attrs %{about: nil, propix: nil, user_id: nil}

    def profile_fixture(attrs \\ %{}) do
      {:ok, profile} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_profile()

      profile
    end

    test "list_profiles/0 returns all profiles" do
      profile = profile_fixture()
      assert Accounts.list_profiles() == [profile]
    end

    test "get_profile!/1 returns the profile with given id" do
      profile = profile_fixture()
      assert Accounts.get_profile!(profile.id) == profile
    end

    test "create_profile/1 with valid data creates a profile" do
      assert {:ok, %Profile{} = profile} = Accounts.create_profile(@valid_attrs)
      assert profile.about == "some about"
      assert profile.propix == "some propix"
      assert profile.user_id == "some user_id"
    end

    test "create_profile/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_profile(@invalid_attrs)
    end

    test "update_profile/2 with valid data updates the profile" do
      profile = profile_fixture()
      assert {:ok, %Profile{} = profile} = Accounts.update_profile(profile, @update_attrs)
      assert profile.about == "some updated about"
      assert profile.propix == "some updated propix"
      assert profile.user_id == "some updated user_id"
    end

    test "update_profile/2 with invalid data returns error changeset" do
      profile = profile_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_profile(profile, @invalid_attrs)
      assert profile == Accounts.get_profile!(profile.id)
    end

    test "delete_profile/1 deletes the profile" do
      profile = profile_fixture()
      assert {:ok, %Profile{}} = Accounts.delete_profile(profile)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_profile!(profile.id) end
    end

    test "change_profile/1 returns a profile changeset" do
      profile = profile_fixture()
      assert %Ecto.Changeset{} = Accounts.change_profile(profile)
    end
  end

  describe "verify_users" do
    alias Bookclub.Accounts.Verify

    @valid_attrs %{token: "some token", user_id: "some user_id"}
    @update_attrs %{token: "some updated token", user_id: "some updated user_id"}
    @invalid_attrs %{token: nil, user_id: nil}

    def verify_fixture(attrs \\ %{}) do
      {:ok, verify} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_verify()

      verify
    end

    test "list_verify_users/0 returns all verify_users" do
      verify = verify_fixture()
      assert Accounts.list_verify_users() == [verify]
    end

    test "get_verify!/1 returns the verify with given id" do
      verify = verify_fixture()
      assert Accounts.get_verify!(verify.id) == verify
    end

    test "create_verify/1 with valid data creates a verify" do
      assert {:ok, %Verify{} = verify} = Accounts.create_verify(@valid_attrs)
      assert verify.token == "some token"
      assert verify.user_id == "some user_id"
    end

    test "create_verify/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_verify(@invalid_attrs)
    end

    test "update_verify/2 with valid data updates the verify" do
      verify = verify_fixture()
      assert {:ok, %Verify{} = verify} = Accounts.update_verify(verify, @update_attrs)
      assert verify.token == "some updated token"
      assert verify.user_id == "some updated user_id"
    end

    test "update_verify/2 with invalid data returns error changeset" do
      verify = verify_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_verify(verify, @invalid_attrs)
      assert verify == Accounts.get_verify!(verify.id)
    end

    test "delete_verify/1 deletes the verify" do
      verify = verify_fixture()
      assert {:ok, %Verify{}} = Accounts.delete_verify(verify)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_verify!(verify.id) end
    end

    test "change_verify/1 returns a verify changeset" do
      verify = verify_fixture()
      assert %Ecto.Changeset{} = Accounts.change_verify(verify)
    end
  end

  describe "password_reset" do
    alias Bookclub.Accounts.ResetPassword

    @valid_attrs %{email: "some email", first_name: "some first_name", last_name: "some last_name", username: "some username"}
    @update_attrs %{email: "some updated email", first_name: "some updated first_name", last_name: "some updated last_name", username: "some updated username"}
    @invalid_attrs %{email: nil, first_name: nil, last_name: nil, username: nil}

    def reset_password_fixture(attrs \\ %{}) do
      {:ok, reset_password} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_reset_password()

      reset_password
    end

    test "list_password_reset/0 returns all password_reset" do
      reset_password = reset_password_fixture()
      assert Accounts.list_password_reset() == [reset_password]
    end

    test "get_reset_password!/1 returns the reset_password with given id" do
      reset_password = reset_password_fixture()
      assert Accounts.get_reset_password!(reset_password.id) == reset_password
    end

    test "create_reset_password/1 with valid data creates a reset_password" do
      assert {:ok, %ResetPassword{} = reset_password} = Accounts.create_reset_password(@valid_attrs)
      assert reset_password.email == "some email"
      assert reset_password.first_name == "some first_name"
      assert reset_password.last_name == "some last_name"
      assert reset_password.username == "some username"
    end

    test "create_reset_password/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_reset_password(@invalid_attrs)
    end

    test "update_reset_password/2 with valid data updates the reset_password" do
      reset_password = reset_password_fixture()
      assert {:ok, %ResetPassword{} = reset_password} = Accounts.update_reset_password(reset_password, @update_attrs)
      assert reset_password.email == "some updated email"
      assert reset_password.first_name == "some updated first_name"
      assert reset_password.last_name == "some updated last_name"
      assert reset_password.username == "some updated username"
    end

    test "update_reset_password/2 with invalid data returns error changeset" do
      reset_password = reset_password_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_reset_password(reset_password, @invalid_attrs)
      assert reset_password == Accounts.get_reset_password!(reset_password.id)
    end

    test "delete_reset_password/1 deletes the reset_password" do
      reset_password = reset_password_fixture()
      assert {:ok, %ResetPassword{}} = Accounts.delete_reset_password(reset_password)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_reset_password!(reset_password.id) end
    end

    test "change_reset_password/1 returns a reset_password changeset" do
      reset_password = reset_password_fixture()
      assert %Ecto.Changeset{} = Accounts.change_reset_password(reset_password)
    end
  end
end

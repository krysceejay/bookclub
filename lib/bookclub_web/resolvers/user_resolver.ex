defmodule BookclubWeb.Resolvers.UserResolver do
  alias Bookclub.Accounts

  def users(_,_,%{context: context}) do
    #IO.inspect(Accounts.list_users())
    {:ok, Accounts.list_users()}
  end

  def user(_,%{id: id}, _resolution) do

    case Accounts.get_user!(id) do
      nil -> {:error, "User ID #{id} not found"}
      user -> {:ok, user}

    end

  end

  def register_user(_,%{input: input},_) do
    Accounts.create_user(input)
  end

end

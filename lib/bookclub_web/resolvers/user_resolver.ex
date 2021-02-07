defmodule BookclubWeb.Resolvers.UserResolver do
  import AbsintheErrorPayload.Payload

  alias AbsintheErrorPayload.ChangesetParser
  alias Bookclub.{Accounts, Email, Mailer, Functions}

  def users(_,_,%{context: _context}) do
    #IO.inspect(Accounts.list_users())
    # IO.puts "+++++++++++++"
    # IO.inspect error_payload(changeset)
    # IO.puts "+++++++++++++"
    {:ok, Accounts.list_users()}
  end

  def update_user(_,%{input: input},%{context: %{current_user: current_user}}) do
    user = Accounts.get_user!(current_user.id)
    case Accounts.update_user_app(user, input) do
      {:ok, user} -> {:ok, success_payload(user)}
      {:error, %Ecto.Changeset{} = changeset} -> {:ok, error_payload(ChangesetParser.extract_messages(changeset))}
    end
  end

  # def user(_,%{id: id}, _resolution) do
  #   case Accounts.get_user!(id) do
  #     user -> {:ok, user}
  #     Ecto.NoResultsError -> {:error, "No result found"}
  #   end
  # end

  def user(_,%{id: id}, _resolution) do
    try do
      user = Accounts.get_user!(id)
      {:ok, user}
    rescue
      Ecto.NoResultsError ->
        {:error, "No result found"}
    end
  end

  def create(%{input: input}, _resolution) do
    case Accounts.create_user(input) do
      {:ok, user} ->
        with false <- createverify(user) do
          {:error, "Something went wrong, please check your internet connection."}
        else
          vtoken ->
              Email.confirm_email(user, user.email, vtoken)
              |> Mailer.deliver_now(response: true)

            {:ok, success_payload(user)}
        end
      {:error, %Ecto.Changeset{} = changeset} -> {:ok, error_payload(ChangesetParser.extract_messages(changeset))}
    end
  end

  defp createverify(user) do
    case Accounts.create_verify(user, %{token: Functions.rand_string(20)}) do
      {:ok, verify} -> verify.token
      {:error, _changeset} -> false
    end
  end

end

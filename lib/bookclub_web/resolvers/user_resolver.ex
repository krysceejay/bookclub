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

  def update_propix(%{input: input}, %{context: %{current_user: current_user}}) do
    user = Accounts.get_user!(current_user.id)
      case Accounts.update_user_propix(user, %{propix: input}) do
        {:ok, _} -> {:ok, true}
        {:error, _changeset} -> {:ok, false}
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
        with false <- create_verification_code(user) do
          {:error, "Something went wrong, please check your internet connection."}
        else
          vtoken ->
              Email.confirm_email_code(user, user.email, vtoken)
              |> Mailer.deliver_now(response: true)

            {:ok, success_payload(user)}
        end
      {:error, %Ecto.Changeset{} = changeset} -> {:ok, error_payload(ChangesetParser.extract_messages(changeset))}
    end
  end

  def resend_code(%{email: email}, _resolution) do
    case Accounts.get_user_by_email(email) do
      nil -> {:error, "User does not exist"}
      user ->
        with false <- resend_verification_code(user) do
          {:error, "Something went wrong."}
        else
          vtoken -> Email.resend_code(user, user.email, vtoken) |> Mailer.deliver_now(response: true)
            {:ok, user}
        end
    end
  end

  def new_password(%{email: email, password: password}, _resolution) do
    user = Accounts.get_user_by_email(email)
      case Accounts.update_user_password(user, %{passwordfield: password}) do
        {:ok, user} -> {:ok, success_payload(user)}
        {:error, %Ecto.Changeset{} = changeset} -> {:ok, error_payload(ChangesetParser.extract_messages(changeset))}
      end
  end

  def verify_token(%{email: email, token: token},_) do
    case Accounts.get_user_by_email(email) do
      nil -> {:error, "User does not exist"}
      user ->
        case Accounts.check_verify_token(user.id, token) do
            false -> {:ok, false}
            true ->
              case Accounts.update_user_status(user, %{status: 1}) do
                {:ok, _} -> {:ok, true}
                {:error, _changeset} -> {:ok, false}
              end
        end
    end
  end

  defp create_verification_code(user) do
    case Accounts.create_verify(user, %{token: Functions.rand_digit()}) do
      {:ok, verify} -> verify.token
      {:error, _changeset} -> false
    end
  end

  defp resend_verification_code(user) do
    verified = Accounts.get_verify_userid(user.id)
    case Accounts.update_verify(verified, %{user_id: user.id, token: Functions.rand_digit()}) do
      {:ok, verify} -> verify.token
      {:error, _changeset} -> false
    end
  end

end

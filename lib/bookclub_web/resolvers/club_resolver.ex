defmodule BookclubWeb.Resolvers.ClubResolver do
  import AbsintheErrorPayload.Payload

  alias AbsintheErrorPayload.ChangesetParser
  alias Bookclub.Content

  def create_club(_,%{input: input},%{context: %{current_user: current_user}}) do
    club_inputs = Map.merge(input, %{user_id: current_user.id})
    case Content.create_club(club_inputs) do
      {:ok, club} -> {:ok, success_payload(club)}
      {:error, %Ecto.Changeset{} = changeset} -> {:ok, error_payload(ChangesetParser.extract_messages(changeset))}
    end
  end

  def all_clubs(_,_,_) do
    {:ok, Content.list_clubs()}
  end

end

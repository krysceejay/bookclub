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

  def create_member(_,%{input: input, club_id: club_id},%{context: %{current_user: current_user}}) do
    member_inputs = Map.merge(input, %{user_id: current_user.id, club_id: club_id})
    case Content.create_member(member_inputs) do
      {:ok, member} -> {:ok, success_payload(member)}
      {:error, %Ecto.Changeset{} = changeset} -> {:ok, error_payload(ChangesetParser.extract_messages(changeset))}
    end
  end

  def create_rate(_,%{input: input, club_id: club_id},%{context: %{current_user: current_user}}) do
    rate_inputs = Map.merge(input, %{user_id: current_user.id, club_id: club_id})

    with true <- Content.check_if_user_rated_club(current_user.id, club_id) do
      rating = Content.get_rating_by_club_user(current_user.id, club_id)
      case Content.update_rate(rating, rate_inputs) do
        {:ok, rate} -> {:ok, success_payload(rate)}
        {:error, %Ecto.Changeset{} = changeset} -> {:ok, error_payload(ChangesetParser.extract_messages(changeset))}
      end
    else
      false ->
        case Content.create_rate(rate_inputs) do
          {:ok, rate} -> {:ok, success_payload(rate)}
          {:error, %Ecto.Changeset{} = changeset} -> {:ok, error_payload(ChangesetParser.extract_messages(changeset))}
        end
    end
  end

  def create_poll(_,%{input: input, club_id: club_id},%{context: %{current_user: current_user}}) do
    poll_inputs = Map.merge(input, %{user_id: current_user.id, club_id: club_id})
    case Content.create_poll(poll_inputs) do
      {:ok, poll} -> {:ok, success_payload(poll)}
      {:error, %Ecto.Changeset{} = changeset} -> {:ok, error_payload(ChangesetParser.extract_messages(changeset))}
    end
  end

  def create_list(_,%{input: input, club_id: club_id},%{context: %{current_user: current_user}}) do
    list_inputs = Map.merge(input, %{user_id: current_user.id, club_id: club_id})
    case Content.create_list(list_inputs) do
      {:ok, list} -> {:ok, success_payload(list)}
      {:error, %Ecto.Changeset{} = changeset} -> {:ok, error_payload(ChangesetParser.extract_messages(changeset))}
    end
  end

  def setPollStatus(_,%{poll_id: poll_id, club_id: club_id},_) do
    poll = Content.get_poll_by_id(poll_id)
    case Content.get_club_current_poll(club_id) do
      nil ->
          case Content.update_poll_status(poll, %{current: true}) do
            {:ok, _poll} -> {:ok, _poll}
            {:error, %Ecto.Changeset{} = changeset} -> {:error, "Some error occured, please check your internet connection and retry."}
          end
      current_poll ->
            if current_poll.id == poll.id do
              case Content.update_poll_status(poll, %{current: false}) do
                {:ok, _poll} -> {:ok, _poll}
                {:error, %Ecto.Changeset{} = changeset} -> {:error, "Some error occured, please check your internet connection and retry."}
              end
            else
              {:error, "You already have a current poll"}
            end
          end
        end

  def setBookStatus(_,%{list_id: list_id, club_id: club_id},_) do
    book = Content.get_list_by_id(list_id)
    case Content.get_club_current_book(club_id) do
      nil ->
          case Content.update_list_status(book, %{current: true}) do
            {:ok, _book} -> {:ok, _book}
            {:error, %Ecto.Changeset{} = changeset} -> {:error, "Some error occured, please check your internet connection and retry."}
          end
      current_book ->
            if current_book.id == book.id do
              case Content.update_list_status(book, %{current: false}) do
                {:ok, _book} -> {:ok, _book}
                {:error, %Ecto.Changeset{} = changeset} -> {:error, "Some error occured, please check your internet connection and retry."}
              end
            else
              {:error, "You already have a current book"}
            end
          end
        end

  def vote_poll(_,%{input: input, poll_id: poll_id},%{context: %{current_user: current_user}}) do
    vote_inputs = Map.merge(input, %{user_id: current_user.id, poll_id: poll_id})
    case Content.get_votes_by_poll_and_user(poll_id, current_user.id) do
      nil ->
        case Content.create_collect_poll(vote_inputs) do
          {:ok, vote} -> {:ok, vote}
          {:error, %Ecto.Changeset{} = changeset} -> {:error, "Some error occured, please check your internet connection and retry."}
        end
      vote ->
        {:error, "You have voted"}
    end
  end

  def removeVote(_,%{vote_id: vote_id},_) do
    vote = Content.get_collect_poll!(vote_id)
    case Content.delete_collect_poll(vote) do
      {:ok, vote} -> {:ok, vote}
      {:error, _} -> {:error, "Some error occured, please check your internet connection and retry."}
    end
  end

  def setClubPublic(_,%{club_id: club_id},%{context: %{current_user: current_user}}) do
    getClub = Content.get_club_by_id_and_user(current_user.id, club_id)
    attr =
      case getClub.public do
        false -> %{public: true}
        true -> %{public: false}
      end

    case Content.update_club_public(getClub,attr) do
      {:ok, club} -> {:ok, club}
      {:error, %Ecto.Changeset{} = changeset} -> {:error, "Some error occured, please check your internet connection and retry."}
    end
  end

  def setClubPublish(_,%{club_id: club_id},%{context: %{current_user: current_user}}) do
    getClub = Content.get_club_by_id_and_user(current_user.id, club_id)
    attr =
      case getClub.public do
        false -> %{publish: true}
        true -> %{publish: false}
      end

    case Content.update_club_publish(getClub,attr) do
      {:ok, club} -> {:ok, club}
      {:error, %Ecto.Changeset{} = changeset} -> {:error, "Some error occured, please check your internet connection and retry."}
    end
  end

  def create_report(_,%{input: input, club_id: club_id},%{context: %{current_user: current_user}}) do
    report_inputs = Map.merge(input, %{user_id: current_user.id, club_id: club_id})
    case Content.create_report(report_inputs) do
      {:ok, report} -> {:ok, success_payload(report)}
      {:error, %Ecto.Changeset{} = changeset} -> {:ok, error_payload(ChangesetParser.extract_messages(changeset))}
    end
  end

  def add_favorite(_,%{club_id: club_id},%{context: %{current_user: current_user}}) do
    favorite_input = %{user_id: current_user.id, club_id: club_id}
    case Content.create_favorite(favorite_input) do
      {:ok, fav} -> {:ok, success_payload(fav)}
      {:error, %Ecto.Changeset{} = changeset} -> {:ok, error_payload(ChangesetParser.extract_messages(changeset))}
    end
  end

  def all_clubs(_,_,_) do
    {:ok, Content.list_clubs()}
  end

  def all_club_polls(_,%{club_id: club_id},_) do
    {:ok, Content.get_polls_by_club(club_id)}
  end

  def get_club_current_poll(_,%{club_id: club_id},_) do
    {:ok, Content.get_club_current_poll(club_id)}
  end

  def get_poll_votes(_,%{poll_id: club_id},_) do
    {:ok, Content.get_votes_by_poll(club_id)}
  end

  def get_club_members(_,%{club_id: club_id},_) do
    {:ok, Content.get_club_members(club_id)}
  end

  def all_club_lists(_,%{club_id: club_id},_) do
    {:ok, Content.get_lists_by_club(club_id)}
  end

  def single_club(_,%{club_id: club_id},_) do
    {:ok, Content.get_club!(club_id)}
  end

end

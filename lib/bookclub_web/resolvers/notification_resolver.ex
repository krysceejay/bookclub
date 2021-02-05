defmodule BookclubWeb.Resolvers.NotificationResolver do
  alias Bookclub.Alerts

  def create_notification(_,%{input: input, club_id: club_id, receiver_user_id: receiver_user_id},%{context: %{current_user: current_user}}) do
    notification_inputs = Map.merge(input, %{club_id: club_id, receiver_user_id: receiver_user_id, sender_user_id: current_user.id})
    case Alerts.create_notification(notification_inputs) do
      {:ok, notification} -> {:ok, notification}
      {:error, _} -> {:error, "Some error occured"}
    end
  end

  # def update_notification(_,_,%{context: %{current_user: current_user}}) do
  #   IO.puts "+++++++++++++"
  #   IO.inspect Alerts.set_seen_to_true(current_user.id)
  #   IO.puts "+++++++++++++"
  # end

  def update_notification(_,_,%{context: %{current_user: current_user}}) do
    {result, _} = Alerts.set_seen_to_true(current_user.id)
     {:ok, result}
  end

  def get_user_notifications(_,_,%{context: %{current_user: current_user}}) do
    {:ok, Alerts.get_user_notifications(current_user.id)}
  end

  def get_user_not_seen_note(_,_,%{context: %{current_user: current_user}}) do
    {:ok, Alerts.get_user_not_seen_note(current_user.id)}
  end

  def get_all_notifications(_,_,_) do
    {:ok, Alerts.list_notifications()}
  end

end

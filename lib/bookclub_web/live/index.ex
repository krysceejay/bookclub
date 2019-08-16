defmodule BookclubWeb.Live.Index do
  use Phoenix.LiveView

  alias Bookclub.Messages
  alias Bookclub.Messages.Chat

  def mount(%{current_user: current_user}, socket) do
    if connected?(socket), do: Messages.subscribe()

    {:ok, fetch(socket, current_user)}
  end

  def render(assigns) do
    BookclubWeb.ChatView.render("index.html", assigns)
  end

  def fetch(socket, current_user, message \\ nil) do
    assign(socket, %{
      chats: Messages.list_chats(),
      changeset: Messages.change_chat(%Chat{message: message}),
      current_user: current_user
      })
  end

  def handle_event("validate", %{"chat" => params}, socket) do
   changeset =
     %Chat{}
     |> Messages.change_chat(params)
     |> Map.put(:action, :insert)

   {:noreply, assign(socket, changeset: changeset)}
 end

 def handle_event("send_message", %{"chat" => params}, socket) do
   case Messages.create_chat(get_current_user(socket), params) do
     {:ok, _chat} ->
       {:noreply, fetch(socket, get_current_user(socket))}

     {:error, %Ecto.Changeset{} = changeset} ->
       {:noreply, assign(socket, changeset: changeset)}
   end
 end

 def handle_info({Messages, [:chat, _event_type], _message}, socket) do
   {:noreply, fetch(socket, get_current_user(socket))}
 end

 #  defp get_user_name(socket) do
 #    socket.assigns
 #    |> Map.get(:user_name)
 #  end
 defp get_current_user(socket) do
   socket.assigns
   |> Map.get(:current_user)
 end

end

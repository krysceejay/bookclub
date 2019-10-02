defmodule BookclubWeb.Live.Index do
  use Phoenix.LiveView

  alias Bookclub.Messages
  alias Bookclub.Messages.Chat
  alias BookclubWeb.Presence

  def mount(%{book: book, current_user: current_user}, socket) do
    if connected?(socket), do: Messages.subscribe(book.id)

    Presence.track(
    self(),
    Messages.get_topic(book.id),
    current_user.id,
    default_user_presence_payload(current_user)
  )

    {:ok, fetch(socket, book, current_user)}
  end

  def render(assigns) do
    BookclubWeb.ChatView.render("index.html", assigns)
  end

  def fetch(socket, book, current_user) do
    assign(socket, %{
      chats: Messages.list_chats_by_bookid(book.id),
      changeset: Messages.change_chat(%Chat{}),
      book: book,
      current_user: current_user,
      users: Presence.list_presences(Messages.get_topic(book.id))
      })
  end

  def handle_event("validate", %{"chat" => params}, socket = %{assigns: %{book: book, current_user: user}}) do

    %{"message" => value} = params

      if value != "" do
        Presence.update_presence(self(), Messages.get_topic(book.id), user.id, %{typing: true})

      else
        Presence.update_presence(self(), Messages.get_topic(book.id), user.id, %{typing: false})
      end

   changeset =
     %Chat{}
     |> Messages.change_chat(params)
     |> Map.put(:action, :insert)

   {:noreply, assign(socket, changeset: changeset)}
 end

 def handle_event(
        "stop_typing",
        value,
        socket = %{assigns: %{book: book, current_user: user, changeset: message}}
      ) do
        IO.puts "+++++++++++++"
        IO.inspect value
        IO.puts "+++++++++++++"
    message = Messages.change_chat(message, %{message: value})
    Presence.update_presence(self(), Messages.get_topic(book.id), user.id, %{typing: false})
    {:noreply, assign(socket, message: message)}
  end

 def handle_event("send_message", %{"chat" => params}, socket) do
   case Messages.create_chat(get_current_user(socket), get_book(socket), params) do
     {:ok, chat} ->
       Presence.update_presence(self(), Messages.get_topic(chat.book_id), chat.user_id, %{typing: false})

       {:noreply, fetch(socket, get_book(socket), get_current_user(socket))}

     {:error, %Ecto.Changeset{} = changeset} ->
       {:noreply, assign(socket, changeset: changeset)}
   end
 end

 def handle_info(%{event: "presence_diff", payload: _payload}, socket = %{assigns: %{book: book}}) do

  {:noreply, assign(socket, users: Presence.list_presences(Messages.get_topic(book.id)))}
end

 def handle_info({Messages, [:chat, :inserted], _chat}, socket) do
   {:noreply, fetch(socket, get_book(socket), get_current_user(socket))}
 end

 defp get_current_user(socket) do
   socket.assigns
   |> Map.get(:current_user)
 end

 defp get_book(socket) do
   socket.assigns
   |> Map.get(:book)
 end

 defp default_user_presence_payload(current_user) do
   %{
     first_name: current_user.first_name,
     email: current_user.email,
     user_id: current_user.id,
     user_name: current_user.username,
     typing: false
   }
 end

 # defp random_color do
 #    hex_code =
 #      ColorStream.hex()
 #      |> Enum.take(1)
 #      |> List.first()
 #
 #    "##{hex_code}"
 #  end
 #
 #  def username_colors(chat) do
 #    Enum.map(chat.messages, fn message -> message.user end)
 #    |> Enum.map(fn user -> user.email end)
 #    |> Enum.uniq()
 #    |> Enum.into(%{}, fn email -> {email, random_color()} end)
 #  end

end

defmodule BookclubWeb.Live.Index do
  use Phoenix.LiveView

  alias Bookclub.{Messages, Content}
  alias Bookclub.Messages.Chat
  alias BookclubWeb.Presence

  def mount(_params, %{"book" => slug, "current_user" => current_user}, socket) do
    book = Content.get_book_by_slug_with_t!(slug)
    if connected?(socket), do: Messages.subscribe(book.id)

    Presence.track(
    self(),
    Messages.get_topic(book.id),
    current_user.id,
    default_user_presence_payload(current_user)
  )

  {:ok,
     socket
     |> assign(page: 1, per_page: 50, book: book, current_user: current_user, show_users: 0, bookdetails: 0, othermenu: 0)
     |> fetch()}

  end

  def render(assigns) do
    BookclubWeb.ChatView.render("index.html", assigns)
  end

  # def fetch(socket, book, current_user, show_users, bookdetails, othermenu) do
  #   assign(socket, %{
  #     chats: Enum.with_index(Messages.list_last_ten_chats(book.id, 10))|> Enum.reverse(),
  #     changeset: Messages.change_chat(%Chat{}),
  #     book: book,
  #     current_user: current_user,
  #     users: Presence.list_presences(Messages.get_topic(book.id)),
  #     show_users: show_users,
  #     show_bookdetails: bookdetails,
  #     show_othermenu: othermenu
  #     })
  # end

  defp fetch(%{assigns: %{page: page, per_page: per, book: book, current_user: current_user, show_users: show_users, bookdetails: bookdetails, othermenu: othermenu}} = socket) do

    assign(socket,
      chats: Enum.reverse(Messages.list_last_ten_chats(book.id, page , per)) |> Enum.with_index(),
      changeset: Messages.change_chat(%Chat{}),
      book: book,
      current_user: current_user,
      users: Presence.list_presences(Messages.get_topic(book.id)),
      show_users: show_users,
      show_bookdetails: bookdetails,
      show_othermenu: othermenu
      )
  end

  def handle_event("validate", %{"chat" => %{"message" => value}}, socket = %{assigns: %{book: book, current_user: user}}) do

    cond do
      value != "" ->
        Presence.update_presence(self(), Messages.get_topic(book.id), user.id, %{typing: true})
      value == "" ->
        Presence.update_presence(self(), Messages.get_topic(book.id), user.id, %{typing: false})
      true ->
        IO.puts "false"
    end

   changeset =
     %Chat{}
     |> Messages.change_chat(%{"message" => value})
     |> Map.put(:action, :insert)

   # {:noreply, assign(socket, changeset: changeset)}
   {:noreply, assign(socket, changeset: changeset,users: Presence.list_presences(Messages.get_topic(book.id)))}
 end

 def handle_event(
        "stop_typing",
        %{"value" => value},
        socket = %{assigns: %{book: book, current_user: user}}
      ) do
    #message = Messages.change_chat(change, %{message: value})
        Presence.update_presence(self(), Messages.get_topic(book.id), user.id, %{typing: false})

  {:noreply, assign(socket, users: Presence.list_presences(Messages.get_topic(book.id)))}


  #{:noreply, socket}
  end


 def handle_event("send_message", %{"chat" => params}, socket) do
   case Messages.create_chat(get_current_user(socket), get_book(socket), params) do
     {:ok, chat} ->
       Presence.update_presence(self(), Messages.get_topic(chat.book_id), chat.user_id, %{typing: false})

       # {:noreply, fetch(socket, get_book(socket), get_current_user(socket),
       # get_show_users(socket), get_show_bookdetails(socket), get_show_othermenu(socket))}
      {:noreply, assign(socket, changeset: Messages.change_chat(%Chat{}))}

     {:error, %Ecto.Changeset{} = changeset} ->

       {:noreply, assign(socket, changeset: changeset)}
   end
 end

 def handle_event("show-users", _value, socket) do
   {:noreply, assign(socket, show_users: 1)}
 end

 def handle_event("hide-users", _value, socket) do
   {:noreply, assign(socket, show_users: 0)}
 end

 def handle_event("show-bookdetails", _value, socket) do

   {:noreply, assign(socket, show_bookdetails: 1)}
 end

 def handle_event("hide-bookdetails", _value, socket) do
   {:noreply, assign(socket, show_bookdetails: 0)}
 end

 def handle_event("show-othermenu", _value, socket) do

   {:noreply, assign(socket, show_othermenu: 1)}
 end

 def handle_event("hide-othermenu", _value, socket) do
   {:noreply, assign(socket, show_othermenu: 0)}
 end

 def handle_info(%{event: "presence_diff", payload: _payload}, socket = %{assigns: %{book: book}}) do

  {:noreply, assign(socket, users: Presence.list_presences(Messages.get_topic(book.id)))}
end

 def handle_info({Messages, [:chat, :inserted], chat}, socket) do
   {:noreply, assign(socket, chats: Enum.reverse(Messages.list_last_ten_chats(chat.book_id, 1, 50)) |> Enum.with_index())}
 end

#  def handle_event("keyup_event", value, _socket) do
#    IO.puts "+++++++++++++++"
#    IO.inspect get_users(socket)
#    IO.puts "+++++++++++++++"
# end
def handle_event("load-more", _value, %{assigns: assigns} = socket) do
  {:noreply, socket |> assign(per_page: assigns.per_page + 50) |> fetch()}
end

 defp get_current_user(socket) do
   socket.assigns
   |> Map.get(:current_user)
 end

 defp get_book(socket) do
   socket.assigns
   |> Map.get(:book)
 end

 defp get_users(socket) do
   socket.assigns
   |> Map.get(:users)
 end

 # defp get_show_users(socket) do
 #   socket.assigns
 #   |> Map.get(:show_users)
 # end
 #
 # defp get_show_bookdetails(socket) do
 #   socket.assigns
 #   |> Map.get(:show_bookdetails)
 # end
 #
 # defp get_show_othermenu(socket) do
 #   socket.assigns
 #   |> Map.get(:show_othermenu)
 # end

 defp default_user_presence_payload(current_user) do
   %{
     first_name: current_user.first_name,
     email: current_user.email,
     user_id: current_user.id,
     user_name: current_user.username,
     typing: false,
     propix: current_user.propix
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

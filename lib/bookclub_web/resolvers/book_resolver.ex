defmodule BookclubWeb.Resolvers.BookResolver do
  alias Bookclub.Content

  def create_book(_,%{input: input},%{context: %{current_user: current_user}}) do
    book_inputs = Map.merge(input, %{user_id: current_user.id})

    case Content.create_book(book_inputs) do
      {:ok, book} ->
        Absinthe.Subscription.publish(BookclubWeb.Endpoint, book, new_book: "*")
        {:ok, book}
        {:error, changeset} -> {:ok, changeset}
      end
  end

  def all_books(_,_,%{context: context}) do
    #IO.inspect(Accounts.list_users())
    {:ok, Content.list_books()}
  end

end

defmodule BookclubWeb.Schema.Types.Booktype do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias Bookclub.Content

      object :book_type do
      field :id, :id
      field :title, :string
      field :author, :string
      field :bookcover, :string
      field :description, :string
      field :link, :string
      field :published, :boolean
      field :genre, list_of(:string)
      field :user, :user_type, resolve: dataloader(Content)
    end

    input_object :book_input_type do
      field :title, non_null(:string)
      field :author, non_null(:string)
      field :bookcover_field, :string
      field :description, non_null(:string)
      field :link, non_null(:string)
      field :published, non_null(:boolean)
      field :genre, list_of(non_null(:string))
    end

end
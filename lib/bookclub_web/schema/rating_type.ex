defmodule BookclubWeb.Schema.Types.RatingType do
  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias Bookclub.Content

      object :rating_type do
        field :id, :id
        field :comment, :string
        field :rating, :integer
        field :insert_at, :date
        field :updated_at, :date
        field :user, :user_type, resolve: dataloader(Content)
        field :book, :book_type, resolve: dataloader(Content)
      end

    input_object :rating_input_type do
      field :comment, non_null(:string)
      field :rating, non_null(:integer)
    end

  end

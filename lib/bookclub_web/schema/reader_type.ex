defmodule BookclubWeb.Schema.Types.ReaderType do
  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias Bookclub.Content

      object :reader_type do
        field :id, :id
        field :status, :boolean
        field :insert_at, :date
        field :updated_at, :date
        field :user, :user_type, resolve: dataloader(Content)
        field :book, :book_type, resolve: dataloader(Content)
      end

    input_object :reader_input_type do
      field :status, non_null(:boolean)
    end

  end

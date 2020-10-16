defmodule BookclubWeb.Schema.Types.TopicType do
  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias Bookclub.Content

      object :topic_type do
        field :id, :id
        field :topic_text, :string
        field :topic_status, :integer
        field :book, :book_type, resolve: dataloader(Content)
      end

    input_object :title_input_type do
      field :topic_text, non_null(:string)
      field :topic_status, non_null(:integer)
    end

  end

defmodule BookclubWeb.Schema.Types.PollType do
  use Absinthe.Schema.Notation
  import AbsintheErrorPayload.Payload
  import_types AbsintheErrorPayload.ValidationMessageTypes

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias Bookclub.Content

      object :poll_type do
        field :id, :id
        field :poll_name, :string
        field :books, list_of(:string)
        field :current, :boolean
        field :insert_at, :date
        field :updated_at, :date
        field :club, :club_type, resolve: dataloader(Content)
      end

    input_object :poll_input_type do
      field :poll_name, non_null(:string)
      field :books, list_of(non_null(:string))
      field :current, :boolean
    end

    payload_object(:poll_payload, :poll_type)

  end

defmodule BookclubWeb.Schema.Types.CollectPoll do
  use Absinthe.Schema.Notation
  import AbsintheErrorPayload.Payload
  import_types AbsintheErrorPayload.ValidationMessageTypes

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias Bookclub.Content

      object :collect_poll_type do
        field :id, :id
        field :poll_index, :integer
        field :insert_at, :date
        field :updated_at, :date
        field :user, :user_type, resolve: dataloader(Content)
        field :poll, :poll_type, resolve: dataloader(Content)
      end

    input_object :collect_poll_input_type do
      field :poll_index, non_null(:integer)
    end

    payload_object(:collect_poll_payload, :collect_poll_type)

  end

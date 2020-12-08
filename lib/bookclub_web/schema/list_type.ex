defmodule BookclubWeb.Schema.Types.ListType do
  use Absinthe.Schema.Notation
  import AbsintheErrorPayload.Payload
  import_types AbsintheErrorPayload.ValidationMessageTypes

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias Bookclub.Content

      object :list_type do
        field :id, :id
        field :title, :string
        field :bookcover, :string
        field :current, :boolean
        field :insert_at, :date
        field :updated_at, :date
        field :club, :club_type, resolve: dataloader(Content)
      end

    input_object :list_input_type do
      field :title, non_null(:string)
      field :bookcover, :string
      field :current, :boolean
    end

    payload_object(:list_payload, :list_type)

  end

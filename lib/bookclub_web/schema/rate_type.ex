defmodule BookclubWeb.Schema.Types.RateType do
  use Absinthe.Schema.Notation
  import AbsintheErrorPayload.Payload
  import_types AbsintheErrorPayload.ValidationMessageTypes

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias Bookclub.Content

      object :rate_type do
        field :id, :id
        field :comment, :string
        field :rating, :integer
        field :insert_at, :date
        field :updated_at, :date
        field :user, :user_type, resolve: dataloader(Content)
        field :club, :club_type, resolve: dataloader(Content)
      end

    input_object :rate_input_type do
      field :comment, non_null(:string)
      field :rating, non_null(:integer)
    end

    payload_object(:rate_payload, :rate_type)

  end

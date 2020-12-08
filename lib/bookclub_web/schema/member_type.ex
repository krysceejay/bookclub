defmodule BookclubWeb.Schema.Types.MemberType do
  use Absinthe.Schema.Notation
  import AbsintheErrorPayload.Payload
  import_types AbsintheErrorPayload.ValidationMessageTypes

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias Bookclub.Content

      object :member_type do
        field :id, :id
        field :status, :boolean
        field :inserted_at, :date
        field :updated_at, :date
        field :user, :user_type, resolve: dataloader(Content)
        field :club, :club_type, resolve: dataloader(Content)
      end

    input_object :member_input_type do
      field :status, :boolean
    end

    payload_object(:member_payload, :member_type)

  end

defmodule BookclubWeb.Schema.Types.ClubType do
  use Absinthe.Schema.Notation
  import AbsintheErrorPayload.Payload
  import_types AbsintheErrorPayload.ValidationMessageTypes

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias Bookclub.Content

      object :club_type do
        field :id, :id
        field :name, :string
        field :image, :string
        field :public, :boolean
        field :user, :user_type, resolve: dataloader(Content)
    end

    input_object :club_input_type do
      field :name, non_null(:string)
      field :image_field, :string
      field :public, :boolean
    end

    payload_object(:club_payload, :club_type)
end

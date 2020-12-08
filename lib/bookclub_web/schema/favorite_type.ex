defmodule BookclubWeb.Schema.Types.FavoriteType do
  use Absinthe.Schema.Notation
  import AbsintheErrorPayload.Payload
  import_types AbsintheErrorPayload.ValidationMessageTypes

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias Bookclub.Content

      object :favorite_type do
        field :id, :id
        field :insert_at, :date
        field :updated_at, :date
        field :user, :user_type, resolve: dataloader(Content)
        field :club, :club_type, resolve: dataloader(Content)
      end

  payload_object(:favorite_payload, :favorite_type)

  end

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
        field :publish, :boolean
        field :description, :string
        field :genre, list_of(:string)
        field :inserted_at, :date
        field :updated_at, :date
        field :user, :user_type, resolve: dataloader(Content)
        field :members, list_of(:member_type), resolve: dataloader(Content)
        field :rates, list_of(:rate_type), resolve: dataloader(Content)
        field :polls, list_of(:poll_type), resolve: dataloader(Content)
        field :lists, list_of(:list_type), resolve: dataloader(Content)
    end

    input_object :club_input_type do
      field :name, non_null(:string)
      field :image, :string
      field :public, :boolean
      field :publish, :boolean
      field :description, non_null(:string)
      field :genre, list_of(non_null(:string))
    end

    payload_object(:club_payload, :club_type)
end

defmodule BookclubWeb.Schema.Types.Usertype do
  use Absinthe.Schema.Notation
  import AbsintheErrorPayload.Payload
  import_types AbsintheErrorPayload.ValidationMessageTypes

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias Bookclub.Accounts

      object :user_type do
        field :id, :id
        field :first_name, :string
        field :email, :string
        field :last_name, :string
        field :username, :string
        field :status, :integer
        field :propix, :string
        field :about, :string
        field :inserted_at, :date
        field :updated_at, :date
        field :books, list_of(:book_type), resolve: dataloader(Accounts)
        field :clubs, list_of(:club_type), resolve: dataloader(Accounts)
        field :members, list_of(:member_type), resolve: dataloader(Accounts)
        field :role, :role_type, resolve: dataloader(Accounts)
    end

    input_object :user_input_type do
      field :first_name, non_null(:string)
      field :last_name, non_null(:string)
      field :email, non_null(:string)
      field :username, non_null(:string)
      field :passwordfield, non_null(:string)
    end

    input_object :user_update_input_type do
      field :first_name, non_null(:string)
      field :last_name, non_null(:string)
      field :username, non_null(:string)
      field :about, non_null(:string)
    end

    payload_object(:user_payload, :user_type)

end

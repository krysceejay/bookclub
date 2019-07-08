defmodule BookclubWeb.Schema.Types.Usertype do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias Bookclub.Accounts

      object :user_type do
      field :id, :id
      field :first_name, :string
      field :email, :string
      field :last_name, :string
      field :username, :string
      field :status, :integer
      #field :role, :string
      field :role, :role_type, resolve: dataloader(Accounts)
    end

    input_object :user_input_type do
      field :first_name, non_null(:string)
      field :last_name, non_null(:string)
      field :email, non_null(:string)
      field :username, non_null(:string)
      field :passwordfield, non_null(:string)
      field :passwordfield_confirmation, non_null(:string)
    end

end

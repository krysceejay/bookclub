defmodule BookclubWeb.Schema.Types.Roletype do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias Bookclub.Accounts

      object :role_type do
      field :id, :id
      field :name, :string
      field :users, list_of(:user_type), resolve: dataloader(Accounts)
    end

    input_object :role_input_type do
      field :name, non_null(:string)
    end

end

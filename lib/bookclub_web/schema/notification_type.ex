defmodule BookclubWeb.Schema.Types.NotificationType do
  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias Bookclub.Alerts

      object :notification_type do
        field :id, :id
        field :type, :string
        field :seen, :boolean
        field :inserted_at, :naive_datetime
        field :updated_at, :naive_datetime
        field :sender_user, :user_type, resolve: dataloader(Alerts)
        field :receiver_user, :user_type, resolve: dataloader(Alerts)
        field :club, :club_type, resolve: dataloader(Alerts)
      end

      input_object :notification_input_type do
        field :type, non_null(:string)
      end

  end

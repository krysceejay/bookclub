defmodule BookclubWeb.Schema.Types.ReportType do
  use Absinthe.Schema.Notation
  import AbsintheErrorPayload.Payload
  import_types AbsintheErrorPayload.ValidationMessageTypes

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias Bookclub.Content

      object :report_type do
        field :id, :id
        field :subject, :string
        field :body, :string
        field :insert_at, :date
        field :updated_at, :date
        field :user, :user_type, resolve: dataloader(Content)
        field :club, :club_type, resolve: dataloader(Content)
      end

    input_object :report_input_type do
      field :subject, non_null(:string)
      field :body, non_null(:string)
    end

  payload_object(:report_payload, :report_type)  

  end

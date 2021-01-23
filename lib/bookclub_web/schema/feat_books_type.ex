defmodule BookclubWeb.Schema.Types.FeatureBook do
  use Absinthe.Schema.Notation

      object :feat_book_type do
        field :id, :id
        field :title, :string
        field :author, :string
        field :bookcover, :string
        field :description, :string
        field :status, :boolean
        field :insert_at, :date
        field :updated_at, :date
      end

    input_object :feat_book_input_type do
      field :title, non_null(:string)
      field :author, non_null(:string)
      field :bookcover_field, :string
      field :description, non_null(:string)
      field :status, :boolean
    end

  end

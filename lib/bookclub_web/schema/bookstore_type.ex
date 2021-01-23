defmodule BookclubWeb.Schema.Types.BookStore do
  use Absinthe.Schema.Notation

      object :bookstore_type do
        field :id, :id
        field :name, :string
        field :address, :string
        field :email, :string
        field :phone, :string
        field :displayimg, :string
        field :description, :string
        field :status, :boolean
        field :insert_at, :date
        field :updated_at, :date
      end

    input_object :bookstore_input_type do
      field :name, non_null(:string)
      field :address, non_null(:string)
      field :email, non_null(:string)
      field :phone, non_null(:string)
      field :displayimg_field, :string
      field :description, non_null(:string)
      field :status, :boolean
    end

  end

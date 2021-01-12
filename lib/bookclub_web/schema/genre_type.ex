defmodule BookclubWeb.Schema.Types.GenreType do
  use Absinthe.Schema.Notation

      object :genre_type do
        field :id, :id
        field :name, :string
        field :insert_at, :date
        field :updated_at, :date
      end

    input_object :genre_input_type do
      field :name, non_null(:string)
    end

  end

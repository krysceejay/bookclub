defmodule BookclubWeb.Resolvers.FeatureResolver do
  alias Bookclub.{Content, Features}

  def get_featured_books(_,_,_) do
    {:ok, Content.list_feat_books_by_status()}
  end

  def get_bookstores(_,_,_) do
    {:ok, Features.list_bookstores_by_status()}
  end

end

defmodule BookclubWeb.Schema.Types do
  use Absinthe.Schema.Notation

  alias BookclubWeb.Schema.Types

  import_types Absinthe.Type.Custom
  import_types Types.Usertype
  import_types Types.Roletype
  import_types Types.SessionType
  import_types Types.Booktype
  import_types Types.TopicType
  import_types Types.RatingType
end

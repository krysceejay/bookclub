defmodule BookclubWeb.Schema.Types do
  use Absinthe.Schema.Notation

  alias BookclubWeb.Schema.Types

  import_types Types.Usertype
  import_types Types.Roletype
  import_types Types.SessionType
  # import_types Types.CommentType
end

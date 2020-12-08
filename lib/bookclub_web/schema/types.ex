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
  import_types Types.ReaderType
  import_types Types.ClubType
  import_types Types.MemberType
  import_types Types.RateType
  import_types Types.PollType
  import_types Types.ListType
  import_types Types.CollectPoll
  import_types Types.ReportType
  import_types Types.FavoriteType
end

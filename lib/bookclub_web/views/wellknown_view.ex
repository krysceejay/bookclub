defmodule BookclubWeb.WellknownView do
  use BookclubWeb, :view
  alias BookclubWeb.WellknownView

  def render("index.json", _) do
    %{
      applinks: %{
        apps: [],
        details: [
         %{
           appID: "com.shelfvibe.Shelfvibe",
           paths: [
             "*"
           ]
         }
        ]
      }
    }
  end
end

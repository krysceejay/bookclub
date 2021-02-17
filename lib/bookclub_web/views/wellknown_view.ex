defmodule BookclubWeb.WellknownView do
  use BookclubWeb, :view
  alias BookclubWeb.WellknownView

  def render("index.json", _) do
    %{
      applinks: %{
        apps: [],
        details: [
         %{
           appID: "org.reactjs.native.example.Shelfvibe",
           paths: [
             "*"
           ]
         }
        ]
      }
    }
  end
end

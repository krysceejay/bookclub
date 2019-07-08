defmodule BookclubWeb.Resolvers.SessionResolver do
  alias Bookclub.{Accounts,Guardian}

  def login_user(_,%{input: input},_) do
    #Check if user exist
    #and return a token and the user if yes
    with {:ok, user} <- Accounts.Session.authenticate(input),
         {:ok, jwt_token, _} <- Guardian.encode_and_sign(user) do
      {:ok, %{token: jwt_token, user: user}}
    end

  end

end

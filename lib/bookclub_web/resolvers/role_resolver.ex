defmodule BookclubWeb.Resolvers.RoleResolver do
  alias Bookclub.Accounts

  def roles(_,_,%{context: _context}) do
    #IO.inspect(context)
  {:ok, Accounts.list_roles()}
  end

  def create_role(_,%{input: input},_) do
    Accounts.create_role(input)
  end

end

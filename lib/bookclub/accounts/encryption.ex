defmodule Bookclub.Accounts.Encryption do
  alias Argon2

  def hash_password(password), do: Argon2.add_hash(password)
  def dummy_check_password(), do: Argon2.dummy_checkpw()
  def validate_password(password, hash), do: Argon2.checkpw(password, hash)

end

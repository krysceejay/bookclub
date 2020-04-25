defmodule Bookclub.Email do
  use Bamboo.Phoenix, view: BookclubWeb.EmailView


  def welcome_text_email(email_address) do
    new_email()
    |> to(email_address)
    |> from("us@example.com")
    |> subject("Welcome!")
    |> text_body("Welcome to MyApp!")
  end

  def confirm_email(user, email, token) do
    base_email()
      |> to(email)
      |> subject("Confirm Email")
      |> render("confirm_email.html", user: user, token: token)
  end

  def reset_password_email(name, email, token) do
    base_email()
      |> to(email)
      |> subject("Reset Password")
      |> render("reset_password.html", name: name, token: token)
  end

  defp base_email() do
    new_email()
      |> from("mail@shelfvibe.com")
      |> put_html_layout({BookclubWeb.LayoutView, "email.html"})
  end

end

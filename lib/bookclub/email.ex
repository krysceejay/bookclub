defmodule Bookclub.Email do
  use Bamboo.Phoenix, view: BookclubWeb.EmailView


  def welcome_text_email(email_address) do
    new_email
    |> to(email_address)
    |> from("us@example.com")
    |> subject("Welcome!")
    |> text_body("Welcome to MyApp!")
  end

  def confirm_email(user, email, token) do
    new_email
      |> to(email)
      |> from("info@pagetalk.club")
      |> subject("Confirm Email")
      |> put_html_layout({BookclubWeb.LayoutView, "email.html"})
      |> render("confirm_email.html", user: user, token: token)
    end

end

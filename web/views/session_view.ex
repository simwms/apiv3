defmodule Apiv3.SessionView do
  use Apiv3.Web, :view
  def render("show.json", %{session: session}) do
    %{session: render_one(session.user, __MODULE__, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{session: render_one(user, __MODULE__, "user.json")}
  end

  def render("user.json", %{session: user}) do
    %{id: user.id,
      user_id: user.id,
      remember_token: user.remember_token,
      email: user.email,
      username: user.username}
  end

end
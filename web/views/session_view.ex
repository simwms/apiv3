defmodule Apiv3.SessionView do
  use Apiv3.Web, :view
  def render("show.json", %{session: session}) do
    %{data: render_one(session.user, __MODULE__, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, __MODULE__, "user.json")}
  end

  def render("user.json", %{session: user}) do
    %{
      id: user.id,
      type: "sessions",
      attributes: %{
        email: user.email,
        remember_token: user.remember_token,
        username: user.username
      },
      relationships: %{
        user: %{
          data: %{
            id: user.id,
            type: "users"
          }
        }
      }
    }
  end

end
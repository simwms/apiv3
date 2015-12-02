defmodule Apiv3.UserView do
  use Apiv3.Web, :view
  def render("show.json", %{user: user}) do
    %{data: render_one(user, __MODULE__, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      type: "users",
      attributes: %{
        email: user.email,
        username: user.username
      }
    }
  end
end
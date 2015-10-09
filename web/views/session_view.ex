defmodule Apiv3.SessionView do
  use Apiv3.Web, :view
  def render("show.json", %{session: session}) do
    %{session: render_one(session, __MODULE__, "session.json")}
  end

  def render("session.json", %{session: session}) do
    %{id: session.user.id}
  end
end
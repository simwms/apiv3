defmodule Apiv3.SanityController do
  use Apiv3.Web, :controller

  def show(conn, _params) do
    conn |> render(Apiv3.ErrorView, "ok.json", [])
  end 
end
defmodule Apiv3.PageController do
  use Apiv3.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end

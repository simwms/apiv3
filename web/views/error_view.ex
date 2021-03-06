defmodule Apiv3.ErrorView do
  use Apiv3.Web, :view

  def render("404.html", _assigns) do
    "Page not found"
  end

  def render("500.html", _assigns) do
    "Server internal error"
  end

  def render("ok.json", _) do
    %{"ok" => "ok"}
  end

  def render("forbidden.json", %{msg: msg}) do
    %{"errors" => %{"msg" => msg}}
  end
  def render("forbidden.json", _assigns) do
    %{"errors" => %{"system" => "yo, seriously not authorized"} }
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render "500.html", assigns
  end
end

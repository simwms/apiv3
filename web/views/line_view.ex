defmodule Apiv3.LineView do
  use Apiv3.Web, :view

  def render("show.json", %{line: line}) do
    %{line: render_one(line, __MODULE__, "line.json")}
  end

  def render("index.json", %{lines: lines}) do
    %{lines: render_many(lines, __MODULE__, "line.json")}
  end

  def render("line.json", %{line: line}) do
    line |> dictify |> reject_blank_keys
  end

  def dictify(line) do
    %{
      id: line.id,
      account_id: line.account_id,
      line_type: line.line_type,
      line_name: line.line_name,
      x: line.x,
      y: line.y,
      a: line.a,
      points: line.points,
      inserted_at: line.inserted_at,
      updated_at: line.updated_at
    }
  end
  
end
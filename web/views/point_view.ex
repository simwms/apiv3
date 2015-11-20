defmodule Apiv3.PointView do
  use Apiv3.Web, :view

  def render("show.json", %{point: point}) do
    %{point: render_one(point, __MODULE__, "point.json")}
  end

  def render("index.json", %{points: points}) do
    %{points: render_many(points, __MODULE__, "point.json")}
  end

  def render("point.json", %{point: point}) do
    point |> dictify |> reject_blank_keys
  end

  def dictify(point) do
    %{
      id: point.id,
      account_id: point.account_id,
      point_type: point.point_type,
      point_name: point.point_name,
      x: point.x,
      y: point.y,
      a: point.a,
      inserted_at: point.inserted_at,
      updated_at: point.updated_at
    }
  end
  
end
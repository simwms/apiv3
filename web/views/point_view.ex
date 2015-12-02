defmodule Apiv3.PointView do
  use Apiv3.Web, :view

  @attributes ~w(point_type point_name x y a inserted_at updated_at)a
  @relationships ~w(account)a
  use Apiv3.JsViewConvention
end
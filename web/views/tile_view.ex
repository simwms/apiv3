defmodule Apiv3.TileView do
  use Apiv3.Web, :view

  @moduledoc """
  This is the more advanced usage of JsViewConvention.

  Declaring the @relationships declares the relationships field in data
  """
  @attributes ~w(tile_type tile_name status a x y z
    width height deleted_at created_at updated_at)a

  @relationships ~w(cameras batches exiting_trucks 
    loading_trucks entering_trucks account)a
  use Apiv3.JsViewConvention
end

defmodule Apiv3.CameraView do
  use Apiv3.Web, :view

  @attributes ~w(permalink camera_name mac_address created_at updated_at camera_style)a
  @relationships ~w(account tile)a
  use Apiv3.JsViewConvention
end

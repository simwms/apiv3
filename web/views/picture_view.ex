defmodule Apiv3.PictureView do
  use Apiv3.Web, :view

  @attributes ~w(location key etag)a
  @relationships ~w(account)a
  use Apiv3.JsViewConvention
end

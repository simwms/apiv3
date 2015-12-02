defmodule Apiv3.LineView do
  use Apiv3.Web, :view
  
  @attributes ~w(line_type line_name x y a points inserted_at updated_at)a
  @relationships ~w(account)a
  use Apiv3.JsViewConvention
end
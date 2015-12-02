defmodule Apiv3.EmployeeView do
  use Apiv3.Web, :view

  @attributes ~w(full_name title arrived_at left_work_at phone email tile_type created_at updated_at role)a
  @relationships ~w(tile pictures account)a
  use Apiv3.JsViewConvention
end

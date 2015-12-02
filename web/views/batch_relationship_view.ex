defmodule Apiv3.BatchRelationshipView do
  use Apiv3.Web, :view

  @attributes []
  @relationships ~w(batch appointment account)a
  use Apiv3.JsViewConvention
end

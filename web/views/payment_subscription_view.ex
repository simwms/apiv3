defmodule Apiv3.PaymentSubscriptionView do
  use Apiv3.Web, :view

  @attributes ~w(inserted_at updated_at token_already_consumed)a
  @relationships ~w(user account service_plan)a
  use Apiv3.JsViewConvention
end
defmodule Apiv3.AccountView do
  use Apiv3.Web, :view

  @attributes ~w(permalink timezone email access_key_id secret_access_key 
    region deleted_at company_name is_properly_setup inserted_at updated_at)a
  @relationships ~w(user payment_subscription service_plan
    appointments batches cameras employees pictures tiles
    trucks weightickets appointment_relationships 
    batch_relationships points lines)a
  use Apiv3.JsViewConvention
end

defmodule Apiv3.WeighticketView do
  use Apiv3.Web, :view
  
  @attributes ~w(pounds license_plate notes finish_pounds created_at updated_at external_reference)a
  @relationships ~w(appointment issuer finisher dock account truck)a
  use Apiv3.JsViewConvention
end

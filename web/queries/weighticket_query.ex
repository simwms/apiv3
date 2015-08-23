defmodule Apiv3.WeighticketQuery do
  import Ecto.Query
  alias Apiv3.Weighticket

  @preload_fields [:appointment, :truck, :pictures]
  def preload_fields, do: @preload_fields
  
  def show(%{"id" => id}) do
    from w in Weighticket,
      where: w.id == ^id,
      select: w
  end

end
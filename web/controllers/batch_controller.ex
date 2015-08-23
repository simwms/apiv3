defmodule Apiv3.BatchController do
  use Apiv3.Web, :controller

  alias Apiv3.Batch
  alias Apiv3.BatchQuery
  plug :scrub_params, "batch" when action in [:create, :update]

  @preload_fields BatchQuery.preload_fields
  use Apiv3.AutomagicControllerConvention
  
  def index(conn, params) do
    account = conn |> current_account
    batches = params 
    |> BatchQuery.index(account)
    |> Repo.all 
    |> Repo.preload(BatchQuery.preload_fields)
    render(conn, "index.json", batches: batches)
  end

end

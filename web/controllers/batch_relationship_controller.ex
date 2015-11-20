defmodule Apiv3.BatchRelationshipController do
  use Apiv3.Web, :controller

  alias Apiv3.BatchRelationshipQuery
  alias Apiv3.BatchRelationshipBuilder
  plug :scrub_params, "batch_relationship" when action in [:create, :update]
  use Apiv3.AutomagicControllerConvention

  @preload_fields BatchRelationshipQuery.preload_fields
  
  def index(conn, %{"appointment_id" => _, "batch_id" => _} = params) do
    batch_relationship = params |> BatchRelationshipQuery.index |> Repo.one!
    render conn, "show.json", batch_relationship: batch_relationship
  end

  def index(conn, params) do
    account = conn |> current_account
    batch_relationships = params |> BatchRelationshipQuery.index(account) |> Repo.all
    render(conn, "index.json", batch_relationships: batch_relationships)
  end

  def create(conn, %{"batch_relationship" => batch_relationship_params}) do
    account = conn |> current_account
    builder = batch_relationship_params |> BatchRelationshipBuilder.create(account)

    if builder.valid? do
      batch_relationship = builder 
      |> BatchRelationshipBuilder.build! 
      |> Repo.preload(@preload_fields)
      render(conn, "show.json", batch_relationship: batch_relationship)
    else
      conn
      |> put_status(:unprocessable_entity)
      |> render(Apiv3.ChangesetView, "error.json", changeset: builder.changeset)
    end
  end

  def delete(conn, %{"model" => batch_relationship}) do
    br = batch_relationship 
    |> BatchRelationshipBuilder.delete!
    |> Repo.preload(@preload_fields)

    render(conn, "show.json", batch_relationship: br)
  end
end

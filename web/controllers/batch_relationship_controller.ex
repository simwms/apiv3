defmodule Apiv3.BatchRelationshipController do
  use Apiv3.Web, :controller

  alias Apiv3.BatchRelationship
  alias Apiv3.BatchRelationshipQuery
  alias Apiv3.BatchRelationshipBuilder
  plug :scrub_params, "batch_relationship" when action in [:create, :update]

  
  def index(conn, %{"appointment_id" => _, "batch_id" => _} = params) do
    batch_relationship = params |> BatchRelationshipQuery.index |> Repo.one!
    render conn, "show.json", batch_relationship: batch_relationship
  end

  def index(conn, params) do
    batch_relationships = params |> BatchRelationshipQuery.index |> Repo.all
    render(conn, "index.json", batch_relationships: batch_relationships)
  end

  def show(conn, %{"id" => id}) do
    batch_relationship = Repo.get!(BatchRelationship, id)
    render conn, "show.json", batch_relationship: batch_relationship
  end

  def create(conn, %{"batch_relationship" => batch_relationship_params}) do
    builder = batch_relationship_params |> BatchRelationshipBuilder.create

    if builder.valid? do
      batch_relationship = builder 
      |> BatchRelationshipBuilder.build! 
      |> Repo.preload(BatchRelationshipQuery.preload_fields)
      render(conn, "show.json", batch_relationship: batch_relationship)
    else
      conn
      |> put_status(:unprocessable_entity)
      |> render(Apiv3.ChangesetView, "error.json", changeset: builder.changeset)
    end
  end

  def update(conn, %{"id" => id, "batch_relationship" => batch_relationship_params}) do
    batch_relationship = Repo.get!(BatchRelationship, id)
    changeset = BatchRelationship.changeset(batch_relationship, batch_relationship_params)

    if changeset.valid? do
      batch_relationship = changeset
      |> Repo.update!
      |> Repo.preload(BatchRelationshipQuery.preload_fields)
      render(conn, "show.json", batch_relationship: batch_relationship)
    else
      conn
      |> put_status(:unprocessable_entity)
      |> render(Apiv3.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    batch_relationship = id
    |> BatchRelationshipBuilder.delete!
    |> Repo.preload(BatchRelationshipQuery.preload_fields)
    render(conn, "show.json", batch_relationship: batch_relationship)
  end
end

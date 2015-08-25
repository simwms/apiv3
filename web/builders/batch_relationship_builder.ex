defmodule Apiv3.BatchRelationshipBuilder do
  alias __MODULE__
  alias Apiv3.BatchRelationship
  alias Apiv3.Batch
  alias Apiv3.Repo
  defstruct valid?: false,
    changeset: BatchRelationship.changeset(%BatchRelationship{}, %{}),
    changesets: []

  def build!(builder) do
    relationship = Repo.insert! builder.changeset
    builder.changesets
    |> Enum.reject(&is_nil/1)
    |> Enum.map(&Repo.update!/1)
    relationship
  end

  def batch_on_create(nil), do: nil
  def batch_on_create(batch_id) do
    batch = Repo.get! Batch, batch_id
    Ecto.Changeset.change(batch, outgoing_count: batch.outgoing_count + 1)
  end
  def batch_on_create(_), do: nil

  def batch_on_delete(nil), do: nil
  def batch_on_delete(batch_id) do
    batch = Repo.get! Batch, batch_id
    Ecto.Changeset.change(batch, outgoing_count: batch.outgoing_count - 1)
  end
  def batch_on_delete(_), do: nil

  def create(params, account) do
    changeset = account
    |> Ecto.Model.build(:batch_relationships)
    |> BatchRelationship.changeset(params)
    batch_changeset = params["batch_id"] |> batch_on_create

    %BatchRelationshipBuilder{
      valid?: changeset.valid?,
      changeset: changeset,
      changesets: [batch_changeset]
    }
  end

  def delete!(batch_relationship) do
    changeset = batch_relationship.batch_id |> batch_on_delete
    unless is_nil(changeset) do
      Repo.update! changeset
    end
    Repo.delete!(batch_relationship)
  end
end
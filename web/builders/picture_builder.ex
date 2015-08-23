defmodule Apiv3.PictureBuilder do
  alias Apiv3.Batch
  alias Apiv3.Employee
  alias Apiv3.Weighticket
  alias Apiv3.Picture
  alias Apiv3.Repo

  def changeset(params) do
    params
    |> find_model
    |> Ecto.Model.build(:pictures)
    |> Picture.changeset(params)
  end

  def find_model(%{"assoc_id" => id, "assoc_type" => "weighticket"}) do
    Repo.get!(Weighticket, id)
  end

  def find_model(%{"assoc_id" => id, "assoc_type" => "batch"}) do
    Repo.get!(Batch, id)
  end

  def find_model(%{"assoc_id" => id, "assoc_type" => "employee"}) do
    Repo.get!(Employee, id)
  end

  def find_model(_) do
    raise(Ecto.NoResultsError, queryable: {"assoc_type", Picture})
  end

end
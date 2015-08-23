defmodule Apiv3.AccountBuilder do
  use Pipe
  alias Apiv3.Account
  alias Apiv3.Repo
  
  def build!(changeset) do
    account = changeset |> Repo.insert!
    pipe_with &state/2,
      {account, []}
      |> seed_tiles
      |> seed_appointments
      |> seed_batches
  end

  def state({account, seeds}=acc, f), do: {account, seeds ++ [f.(acc)]}

  @tile_seeds [
    %{
      "tile_type" => "barn",
      "x" => 2,
      "y" => 2,
      "width" => 1.0,
      "height" => 1.0
    },
    %{
      "tile_type" => "warehouse",
      "x" => 2,
      "y" => 3,
      "width" => 1.0,
      "height" => 1.0
    },
    %{
      "tile_type" => "scale",
      "tile_name" => "entrance scale",
      "x" => 1,
      "y" => 1,
      "width" => 1.0,
      "height" => 1.0
    },
    %{
      "tile_type" => "road",
      "x" => 1,
      "y" => 2,
      "width" => 1.0,
      "height" => 1.0
    }
  ]
  def seed_tiles({account, []}) do
    pipe_with &Enum.map/2,
      @tile_seeds 
      |> build_changeset(account, :tiles) 
      |> Repo.insert!
  end

  @appointment_seeds [%{
    "appointment_type" => "dropoff",
    "material_description" => "test appointment material",
    "company" => "seed test company",
    "expected_at" => Ecto.DateTime.local,
    "fulfilled_at" => Ecto.DateTime.local
  }, %{
    "appointment_type" => "dropoff",
    "material_description" => "not a real material",
    "company" => "base test inc",
    "expected_at" => Ecto.DateTime.local,
    "fulfilled_at" => Ecto.DateTime.local
  }]
  def seed_appointments({account, [_tiles]}) do
    pipe_with &Enum.map/2,
      @appointment_seeds
      |> Dict.put("expected_at", Timex.Date.local)
      |> Dict.put("fulfilled_at", Timex.Date.local)
      |> build_changeset(account, :appointments)
      |> Repo.insert!
  end

  @batch_seeds [%{
    "permalink" => "basic-seed-001",
    "description" => "test batch",
    "quantity" => "some amount"
  }, %{
    "permalink" => "basic-seed-002",
    "description" => "test batch",
    "quantity" => "some amount"
  }, %{
    "permalink" => "basic-seed-003",
    "description" => "test batch",
    "quantity" => "some amount"
  }]
  def seed_batches({account, [tiles, appointments]}) do
    [dock, warehouse|_] = tiles
    [appointment|_] = appointments
    pipe_with &Enum.map/2,
      @batch_seeds
      |> Dict.put("appointment_id", appointment.id)
      |> Dict.put("dock_id", dock.id)
      |> Dict.put("warehouse_id", warehouse.id)
      |> build_changeset(account, :batches)
      |> Repo.insert!
  end

  def build_changeset(params, account, relationship_key) do
    Ecto.Model.build(account, relationship_key, params)
  end
end
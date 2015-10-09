defmodule Apiv3.EctoUtils do
  import Ecto.Model
  import Ecto.Changeset

  def id_object_cast(params, []), do: params
  def id_object_cast(params, [field|fields]) do
    case params |> Dict.pop(field) do
      {nil, dict} -> dict
      {%{id: id}, dict} -> dict |> Dict.put("#{field}_id", id)
    end
    |> id_object_cast(fields)
  end

  def find!(id, model_class), do: Apiv3.Repo.get!(model_class, id)

  def fetch_fields(changeset, fields), do: changeset |> fetch_fields(fields, %{})
  def fetch_fields(_, [], p), do: p
  def fetch_fields(changeset, [field|fields], params) do
    value = changeset |> get_field(field)
    field = field |> Atom.to_string
    params = params |> Dict.put(field, value)
    fetch_fields(changeset, fields, params)
  end

  def build_changeset(params, account, relationship_key, model_class) do
    Ecto.Model.build(account, relationship_key)
    |> model_class.changeset(params)
  end
end
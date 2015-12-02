defmodule Apiv3.ChangesetUtils do
  alias Ecto.Association.BelongsTo
  @moduledoc """
  Changeset Utility functions for creating changesets from JSONAPI data

  consult the specs here: http://jsonapi.org/
  """

  @doc """
  From the specs site, JSONAPI POST PATCH data looks like the following:

  {
    "data": {
      "type": "photos",
      "attributes": {
        "title": "Ember Hamster",
        "src": "http://example.com/images/productivity.png"
      },
      "relationships": {
        "photographer": {
          "data": { "type": "people", "id": "9" }
        }
      }
    }
  }
  however, changesets are created from active-model-like paramters
  so this functions "flattens" out the post requests
  """
  def activemodel_paramify(%{"data" => data}) do
    module = model_module_from_collection_name data["type"]
    
    data
    |> activemodelify_attributes
    |> Map.merge data
    |> activemodelify_relationships(module)
  end

  def activemodel_paramify(_), do: nil

  def activemodelify_attributes(%{"attributes" => attrs}) when is_map(attrs) do
    attrs
  end
  def activemodelify_attributes(_), do: %{}

  def activemodelify_relationships(%{"relationships" => rels}, module) when is_map(rels) do
    rels
    |> Enum.map(&foreign_key_pair(module, &1))
    |> Enum.reject(&is_nil/1)
    |> Enum.into(%{})
  end
  def activemodelify_relationships(_, _), do: %{}

  def foreign_key_pair(module, {association, %{"data" => %{"id" => id}}}) do
    case reflect_association(module, association) do
      %BelongsTo{owner_key: name} -> {to_string(name), id}
      _ -> nil
    end
  end
  def foreign_key_pair(_, _), do: nil

  defp reflect_association(model, field) do
    case field |> maybe_to_existing_atom do
      nil -> nil
      atom ->
        model.__schema__(:association, atom)
    end
  end

  def maybe_to_existing_atom(str) do
    try do
      str |> String.to_existing_atom
    rescue 
      ArgumentError -> nil
    end
  end

  def model_module_from_collection_name(type) do
    x = type
    |> Fox.StringExt.singularize
    |> Fox.StringExt.camelize
    
    
    String.to_existing_atom("Elixir.Apiv3." <> x)
  end
end
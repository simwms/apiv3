defmodule Apiv3.JsViewConvention do
  def infer_fields(view_module) do
    model_module = view_module |> Fox.AtomExt.infer_model_module 
    model_module.__schema__(:fields)
  end
  def infer_associations(view_module) do
    model_module = view_module |> Fox.AtomExt.infer_model_module
    model_module.__schema__(:associations)
  end
  defmacro __using__(_opts) do
    quote location: :keep do
      @model_atom Fox.AtomExt.infer_model_key(__MODULE__)
      @model_name @model_atom |> Atom.to_string
      @collection_atom Fox.AtomExt.infer_collection_key(__MODULE__)
      @attributes Module.get_attribute(__MODULE__, :attributes) || Apiv3.JsViewConvention.infer_fields(__MODULE__)
      @relationships Module.get_attribute(__MODULE__, :relationships) || Apiv3.JsViewConvention.infer_associations(__MODULE__)

      def render("show.json", %{@model_atom => model}) do
        %{data: render_one(model, __MODULE__, "#{@model_name}.json")}
      end

      def render("index.json", %{@collection_atom => models}=assigns) do
        %{data: render_many(models, __MODULE__, "#{@model_name}.json")}
        |> render_meta(assigns)
      end

      def render(@model_name <> ".json", %{@model_atom => model}) do
        model |> jsonapify
      end

      def render_meta(output, %{meta: meta}), do: output |> Dict.put(:meta, meta)
      def render_meta(output, _), do: output

      def jsonapify(model) do
        resource_identifier(model)
        |> Dict.put(:attributes, extract_attributes(model))
        |> Dict.put(:relationships, extract_relationships(model))
      end

      def resource_identifier(model) do
        type = model
        |> Fox.RecordExt.infer_collection_key
        |> Atom.to_string
        %{id: model.id,
          type: type}
      end

      def extract_relationships(model) do
        model
        |> Map.take(@relationships)
        |> Enum.map(render_association(model))
        |> Enum.into(%{})
      end

      def render_association(model) do
        fn {key, association} ->
          {key, %{data: render_association_core(association, model)}}
        end
      end

      defp reflect_association(model, field) do
        model.__struct__.__schema__(:association, field)
      end

      def render_association_core(%Ecto.Association.NotLoaded{__field__: field}, model) do
        case reflect_association(model, field) do
          %{owner_key: id_key, related: typeclass} ->
            id = Map.get(model, id_key)
            type = Fox.AtomExt.infer_collection_key(typeclass)
            if id && type, do: %{id: id, type: type}, else: nil
          %{cardinality: :many} -> []
          _ -> nil
        end
      end
      def render_association_core(model, _) when is_map(model) do
        resource_identifier(model)
      end
      def render_association_core(models, _) when is_list(models) do
        models |> Enum.map(&resource_identifier/1)
      end
      def render_association_core(_, _), do: nil

      def extract_attributes(model) do
        model
        |> Map.take(@attributes)
        |> Fox.DictExt.reject_blank_keys
      end
    end
  end
end
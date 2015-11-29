defmodule Apiv3.JsViewConvention do
  defmacro __using__(_opts) do
    quote location: :keep do
      @model_atom Fox.AtomExt.infer_model_key(__MODULE__)
      @model_name @model_atom |> Atom.to_string
      @collection_atom Fox.AtomExt.infer_collection_key(__MODULE__)
      @collection_name @collection_atom |> Atom.to_string
      @attributes Module.get_attribute(__MODULE__, :attributes) || []

      def render("show.json", %{@model_atom => model}) do
        %{data: render_one(model, __MODULE__, "#{@model_name}.json")}
      end

      def render("index.json", %{@collection_atom => models}) do
        %{data: render_many(models, __MODULE__, "#{@model_name}.json")}
      end

      def render(@model_name <> ".json", %{@model_atom => model}) do
        model |> jsonapify
      end

      def jsonapify(model) do
        %{
          type: @collection_name, 
          id: model.id,
          attributes: extract_attributes(model)
        }
      end

      def extract_attributes(model) do
        model
        |> Map.take(@attributes)
        |> Fox.DictExt.reject_blank_keys
      end
    end
  end
end
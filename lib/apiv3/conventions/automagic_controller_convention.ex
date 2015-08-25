defmodule Apiv3.AutomagicControllerConvention do
  defmacro __using__(_) do
    quote location: :keep do
      @preload_fields Module.get_attribute(__MODULE__, :preload_fields) || []
      use Fox.AtomExt
      alias Apiv3.Repo

      def create(conn, params) do
        make_params = params |> Dict.fetch! infer_model_key |> Atom.to_string
        changeset = conn
        |> current_account
        |> build(infer_collection_key)
        |> infer_model_module.changeset(make_params)

        if changeset.valid? do
          model = Repo.insert!(changeset) |> Repo.preload(@preload_fields)
          render(conn, "show.json", [{infer_model_key, model}])
        else
          conn
          |> put_status(:unprocessable_entity)
          |> render(Apiv3.ChangesetView, "error.json", changeset: changeset)
        end
      end

      def show(conn, %{"model" => model}) do
        model = model |> Repo.preload(@preload_fields)
        conn |> render("show.json", [{infer_model_key, model}])
      end

      def delete(conn, %{"model" => model}) do
        model = model
        |> Repo.delete!
        |> Repo.preload(@preload_fields)
        render(conn, "show.json", [{infer_model_key, model}])
      end

      def update(conn, %{"model" => model}=params) do
        change_params = params |> Dict.fetch! infer_model_key |> Atom.to_string
        changeset = model |> infer_model_module.changeset(change_params)

        if changeset.valid? do
          model = changeset |> Repo.update! |> Repo.preload(@preload_fields)
          conn |> render("show.json", [{infer_model_key, model}])
        else
          conn
          |> put_status(:unprocessable_entity)
          |> render(Apiv3.ChangesetView, "error.json", changeset: changeset)
        end
      end

      plug Apiv3.Plugs.AutoModel,
        actions: [:show, :update, :delete],
        model: Fox.AtomExt.infer_model_module(__MODULE__)
      
      plug Apiv3.Plugs.EnforceOwnership,
        actions: [:show, :update, :delete]

      defoverridable [create: 2, delete: 2]
    end    
  end
end
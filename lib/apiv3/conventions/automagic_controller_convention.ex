defmodule Apiv3.AutomagicControllerConvention do
  defmacro __using__(opts\\[]) do
    plug_on_actions = opts[:only] || [:show, :update, :delete]
    quote location: :keep do
      @preload_fields Module.get_attribute(__MODULE__, :preload_fields) || []
      use Fox.AtomExt
      alias Apiv3.Repo

      def create(conn, params) do
        make_params = params 
        |> Apiv3.ChangesetUtils.activemodel_paramify 
        || params 
        |> Dict.fetch!(infer_model_key |> Atom.to_string)

        conn
        |> current_account
        |> build(infer_collection_key)
        |> infer_model_module.changeset(make_params)
        |> Repo.insert
        |> case do
          {:ok, model} ->
            model = model |> Repo.preload(@preload_fields)
            conn
            |> put_status(:created)
            |> render("show.json", [{infer_model_key, model}])
          {:error, changeset} ->
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
        model |> Repo.delete!
        send_resp(conn, :no_content, "")
      end

      def update(conn, %{"model" => model}=params) do
        change_params = params 
        |> Apiv3.ChangesetUtils.activemodel_paramify
        || params
        |> Dict.fetch!(infer_model_key |> Atom.to_string)
        model 
        |> infer_model_module.changeset(change_params)
        |> Repo.update
        |> case do
          {:ok, model} ->
            model = model |> Repo.preload(@preload_fields)
            conn |> render("show.json", [{infer_model_key, model}])
          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> render(Apiv3.ChangesetView, "error.json", changeset: changeset) 
        end
      end

      plug Apiv3.Plugs.AutoModel,
        actions: unquote(plug_on_actions),
        model: Fox.AtomExt.infer_model_module(__MODULE__)
      
      plug Apiv3.Plugs.EnforceOwnership,
        actions: unquote(plug_on_actions)

      defoverridable [create: 2, delete: 2, show: 2, update: 2]
    end    
  end
end
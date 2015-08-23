defmodule Apiv3.AutomagicControllerConvention do
  defmacro __using__(_) do
    quote location: :keep do
      @preload_fields Module.get_attribute(__MODULE__, :preload_fields) || []
      plug :auto_model, actions: [:show, :update, :delete]
      plug :enforce_ownership, actions: [:show, :update, :delete]

      alias Apiv3.Repo

      def create(conn, params) do
        make_params = params |> Dict.fetch! infer_model_key |> Atom.to_string
        changeset = conn
        |> current_account
        |> build(infer_collection_key)
        |> infer_model_class.changeset(make_params)

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
        changeset = model |> infer_model_class.changeset(change_params)

        if changeset.valid? do
          model = changeset |> Repo.update! |> Repo.preload(@preload_fields)
          conn |> render("show.json", [{infer_model_key, model}])
        else
          conn
          |> put_status(:unprocessable_entity)
          |> render(Apiv3.ChangesetView, "error.json", changeset: changeset)
        end
      end

      defp infer_model_class do
        __MODULE__
        |> Atom.to_string
        |> Fox.StringExt.reverse_consume!("Controller")
        |> String.to_existing_atom
      end

      defp infer_collection_key do
        infer_model_class
        |> Atom.to_string
        |> Fox.StringExt.consume!("Elixir.Apiv3.")
        |> String.downcase
        |> Fox.StringExt.pluralize
        |> String.to_atom
      end

      defp infer_model_key do
        infer_model_class
        |> Atom.to_string
        |> Fox.StringExt.consume!("Elixir.Apiv3.")
        |> String.downcase
        |> String.to_atom
      end

      def auto_model(conn, actions: actions) do
        action = conn |> action_name
        if action in actions, do: auto_model(conn), else: conn
      end
      defp auto_model(conn) do
        primary_id = Map.get(conn.params, "id")
        unless primary_id do
          raise Phoenix.MissingParamError, key: "id"
        end
        model = infer_model_class |> Repo.get_by!(id: primary_id)
        params = Map.put(conn.params, "model", model)
        %{conn | params: params}
      end

      def enforce_ownership(conn, actions: actions) do
        action = conn |> action_name
        if action in actions, do: enforce_ownership(conn), else: conn
      end
      defp enforce_ownership(conn) do
        %{account_id: account_id} = Map.get(conn.params, "model")
        %{id: id} = conn |> current_account
        if account_id == id do
          conn
        else
          conn
          |> put_status(:forbidden)
          |> render(Apiv3.ErrorView, "forbidden.json", msg: "not yours")
          |> halt
        end
      end
    end    
  end
end
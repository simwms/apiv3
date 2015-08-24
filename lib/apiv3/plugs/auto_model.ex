defmodule Apiv3.Plugs.AutoModel do
  import Plug.Conn
  alias Apiv3.Repo
  import Apiv3.AccountSessionHelper
  import Phoenix.Controller, only: [action_name: 1]
  
  def init([actions: actions, model: model]=opts) when is_list(actions) and is_atom(model) do
    opts
  end
  def init(_), do: raise(Apiv3.Plugs.AutoModelError, :model)

  def call(conn, opts) do
    conn |> auto_model(opts)
  end

  defp auto_model(conn, actions: actions, model: model_class) do
    action = conn |> action_name
    if action in actions, do: auto_model(conn, model_class), else: conn
  end
  defp auto_model(conn, model_class) when is_atom(model_class) do
    primary_id = Map.get(conn.params, "id")
    unless primary_id do
      raise Phoenix.MissingParamError, key: "id"
    end
    model = model_class |> Repo.get_by!(id: primary_id)
    params = Map.put(conn.params, "model", model)
    %{conn | params: params}
  end
end

defmodule Apiv3.Plugs.AutoModelError do
  defexception [:message]

  def exception(_) do
    %__MODULE__{
      message: "You forgot to provide the model class"
    }
  end
end
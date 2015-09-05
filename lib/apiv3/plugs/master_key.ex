defmodule Apiv3.Plugs.MasterKey do
  import Plug.Conn
  import Phoenix.Controller, only: [render: 4]

  def init(o), do: o

  def call(conn, _o) do
    case conn |> has_master_key? do
      true -> conn
      _ -> 
        conn
        |> put_status(:forbidden)
        |> render(Apiv3.ErrorView, "forbidden.json", [])
        |> halt
    end
  end

  @master_key Application.get_env(:simwms, :master_key)
  defp has_master_key?(conn) do
    conn 
    |> get_req_header("simwms-master-key")
    |> List.first
    |> equal?(@master_key)
  end

  defp equal?(a,b), do: String.strip("#{a}") == String.strip("#{b}")
end